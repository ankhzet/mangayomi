import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'dart:async';
import 'dart:io';
import 'package:mangayomi/eval/model/m_source.dart';
import 'package:mangayomi/main.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart'
    as flutter_inappwebview;
import 'package:mangayomi/models/settings.dart';
import 'package:http/io_client.dart';
import 'package:mangayomi/services/http/rhttp/src/model/settings.dart';
import 'package:mangayomi/utils/extensions/settings.dart';
import 'package:mangayomi/utils/log/log.dart';
import 'package:mangayomi/services/http/rhttp/rhttp.dart' as rhttp;
import 'package:mangayomi/services/http/doh/doh_resolver.dart';
import 'package:mangayomi/services/http/doh/doh_providers.dart';

class MClient {
  MClient();
  static final defaultClient = IOClient(HttpClient());
  static final Map<rhttp.ClientSettings, Client> rhttpPool = {};
  static Client httpClient({
    Map<String, dynamic>? reqcopyWith,
    rhttp.ClientSettings? settings,
  }) {
    if (!(reqcopyWith?["useDartHttpClient"] ?? false)) {
      try {
        settings ??= rhttp.ClientSettings(
          throwOnStatusCode: false,
          proxySettings:
              reqcopyWith?["noProxy"] ?? false
                  ? const rhttp.ProxySettings.noProxy()
                  : null,
          timeout:
              reqcopyWith?["timeout"] != null
                  ? Duration(seconds: reqcopyWith?["timeout"])
                  : null,
          timeoutSettings: TimeoutSettings(
            connectTimeout:
                reqcopyWith?["connectTimeout"] != null
                    ? Duration(seconds: reqcopyWith?["connectTimeout"])
                    : null,
          ),
          tlsSettings: rhttp.TlsSettings(
            verifyCertificates: reqcopyWith?["verifyCertificates"] ?? false,
          ),
        );
        return rhttpPool.putIfAbsent(settings, () {
          return rhttp.RhttpCompatibleClient.createSync(settings: settings);
        });
      } catch (_) {}
    }
    return defaultClient;
  }

  static InterceptedClient init({
    MSource? source,
    Map<String, dynamic>? reqcopyWith,
    rhttp.ClientSettings? settings,
    bool showCloudFlareError = true,
  }) {
    final appSettings = isar.settings.getSync(227);
    final useDoH = appSettings?.doHEnabled ?? false;
    final doHProviderId = appSettings?.doHProviderId;

    DnsSettings? dnsSettings;

    if (useDoH && doHProviderId != null) {
      // Use DoH resolver with specific provider
      final provider = DoHProviders.byId[doHProviderId];
      if (provider != null) {
        dnsSettings = DnsSettings.dynamic(
          resolver: (host) => DoHResolver.resolve(host, provider: provider),
        );
      }
    } else if (customDns != null && customDns!.trim().isNotEmpty) {
      // Fallback to custom static DNS
      dnsSettings = DnsSettings.dynamic(resolver: (host) async => [customDns!]);
    }

    // Apply DNS settings if configured
    final clientSettings =
        dnsSettings != null
            ? settings?.copyWith(dnsSettings: dnsSettings) ??
                ClientSettings(dnsSettings: dnsSettings)
            : settings;

    return InterceptedClient.build(
      client: httpClient(settings: clientSettings, reqcopyWith: reqcopyWith),
      retryPolicy: (showCloudFlareError && !Platform.isLinux) ? ResolveCloudFlareChallenge(showCloudFlareError) : null,
      interceptors: [
        MCookieManager(reqcopyWith),
        if (kDebugMode || useLogger) LoggerInterceptor(),
        if (showCloudFlareError) ClaudflareInterceptor(),
      ],
    );
  }

  static Map<String, String> getCookiesPref(String url) {
    final cookiesList = isar.settings.first.cookiesList ?? [];
    if (cookiesList.isEmpty) return {};
    final host = Uri.parse(url).host;
    final cookies =
        cookiesList
            .firstWhere(
              (element) => element.host == host || host.contains(element.host!),
              orElse: () => MCookie(cookie: ""),
            )
            .cookie!;
    if (cookies.isEmpty) return {};
    return {HttpHeaders.cookieHeader: cookies};
  }

  static Future<void> setCookie(
    String url,
    String ua,
    flutter_inappwebview.InAppWebViewController? webViewController, {
    String? cookie,
  }) async {
    Iterable<String> cookies = [];

    if (Platform.isLinux) {
      cookies = cookie?.split(RegExp('(?<=)(,)(?=[^;]+?=)')).where((cookie) => cookie.isNotEmpty) ?? [];
    } else {
      cookies = (await flutter_inappwebview.CookieManager.instance(
        webViewEnvironment: webViewEnvironment,
      ).getCookies(
        url: flutter_inappwebview.WebUri(url),
        webViewController: webViewController,
      )).map((e) => "${e.name}=${e.value}");
    }

    if (!(cookies.isNotEmpty || ua.isNotEmpty)) {
      return;
    }

    final settings = isar.settings.first;

    if (cookies.isNotEmpty) {
      final host = Uri.parse(url).host;
      final newCookie = cookies.join("; ");
      final filteredCookies = removeCookiesForHost(settings.cookiesList ?? [], host);

      settings.cookiesList = [
        ...filteredCookies,
        MCookie()
          ..host = host
          ..cookie = newCookie,
      ];
    }

    if (ua.isNotEmpty) {
      settings
        ..userAgent = ua
        ..updatedAt = DateTime.now().millisecondsSinceEpoch;
    }

    isar.settings.first = settings;
  }

  static List<MCookie> removeCookiesForHost(
    List<MCookie> allCookies,
    String host,
  ) {
    return allCookies
        .where((cookie) => cookie.host != host && !host.contains(cookie.host!))
        .toList();
  }

  static Future<void> deleteAllCookies(String url) async {
    final settings = await isar.settings.get(227);
    final oldCookies = settings!.cookiesList ?? [];
    final host = Uri.parse(url).host;
    settings.cookiesList = removeCookiesForHost(oldCookies, host);
    await isar.writeTxn(() => isar.settings.put(settings));
  }
}

class MCookieManager extends InterceptorContract {
  MCookieManager(this.reqcopyWith);
  Map<String, dynamic>? reqcopyWith;

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    final cookie = MClient.getCookiesPref(request.url.toString());
    final userAgent = isar.settings.first.userAgent!;

    if (cookie.isNotEmpty) {
      if (request.headers[HttpHeaders.cookieHeader] == null) {
        request.headers.addAll(cookie);
      }
    }

    if (request.headers[HttpHeaders.userAgentHeader] != userAgent) {
      request.headers[HttpHeaders.userAgentHeader] = userAgent;
    }

    if (reqcopyWith != null) {
      try {
        if (reqcopyWith!["followRedirects"] != null) {
          request.followRedirects = reqcopyWith!["followRedirects"];
        }
        if (reqcopyWith!["maxRedirects"] != null) {
          request.maxRedirects = reqcopyWith!["maxRedirects"];
        }
        if (reqcopyWith!["contentLength"] != null) {
          request.contentLength = reqcopyWith!["contentLength"];
        }
        if (reqcopyWith!["persistentConnection"] != null) {
          request.persistentConnection = reqcopyWith!["persistentConnection"];
        }
      } catch (_) {}
    }
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    return response;
  }
}

class LoggerInterceptor extends InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    final content = "-> ${request.toString()}\nheaders: ${request.headers.toString()}";

    // ignore: avoid_print
    print(content);
    Logger.add(LoggerLevel.info, content);

    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    bool cloudflare = isCloudflare(response);
    final content =
        "<- ${response.request?.method}: ${response.request?.url}, statusCode: ${response.statusCode} ${cloudflare ? "Failed to bypass Cloudflare" : ""}";

    // ignore: avoid_print
    print(content);
    Logger.add(LoggerLevel.info, content);

    return response;
  }
}

class ClaudflareInterceptor extends InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
      if (isCloudflare(response)) {
        try {
          botToast(
            "${response.statusCode} Failed to bypass Cloudflare",
            url: response.request!.url.toString(),
          );
        } catch (e) {
          throw "Failed to bypass Cloudflare.\n\n\nYou can try to bypass it manually in the webview \n\n\nstatusCode: ${response.statusCode}";
          //
        }
      }

    return response;
  }
}

bool isCloudflare(BaseResponse response) {
  return [403, 503].contains(response.statusCode) &&
      ["cloudflare-nginx", "cloudflare"].contains(response.headers["server"]);
}

class ResolveCloudFlareChallenge extends RetryPolicy {
  bool showCloudFlareError;
  ResolveCloudFlareChallenge(this.showCloudFlareError);
  @override
  int get maxRetryAttempts => 1;
  @override
  Future<bool> shouldAttemptRetryOnResponse(BaseResponse response) async {
    bool cloudflare = isCloudflare(response);

    if (cloudflare) {
      try {
        return http
            .post(
              Uri.parse('http://localhost:$cfPort/resolve_cf'),
              headers: {HttpHeaders.contentTypeHeader: 'application/json'},
              body: jsonEncode({'url': response.request!.url.toString()}),
            )
            .then((res) {
              if (res.statusCode == 200) {
                final data = jsonDecode(res.body) as Map<String, dynamic>;
                return data['result'] as bool;
              }
              return false;
            });
      } catch (e) {
        return false;
      }
    }

    return false;
  }
}

int cfPort = 0;
HttpServer? _cfServer;

/// Cloudflare Resolution Webview Server
Future<void> cfResolutionWebviewServer() async {
  try {
    _cfServer = await HttpServer.bind(InternetAddress.loopbackIPv4, cfPort);
    cfPort = _cfServer!.port;
    _cfServer!.listen(
      (HttpRequest request) {
        if (request.method == 'POST' && request.uri.path == '/resolve_cf') {
          _handleResolveCf(request);
        } else {
          request.response
            ..statusCode = HttpStatus.notFound
            ..write('Not Found')
            ..close();
        }
      },
      onError: (e, st) {
        debugPrint("CF server listener error: $e\n$st");
      },
      cancelOnError: false,
    );
  } catch (e, st) {
    debugPrint("Couldn't start Cloudflare Resolution Webview Server: $e\n$st");
    botToast("Couldn't start Cloudflare Resolution Webview Server.");
  }
}

Future<void> stopCfResolutionWebviewServer() async {
  final server = _cfServer;
  if (server == null) return;
  try {
    await server.close(force: true);
  } finally {
    _cfServer = null;
    cfPort = 0;
  }
}

Future<bool> isChallengePresent(flutter_inappwebview.InAppWebViewController controller) async {
  try {
    return await controller.platform.evaluateJavascript(
      source:
      "document.head.innerHTML.includes('#challenge-success-text')",
    );
  } catch (_) {
    return false;
  }
}

void _handleResolveCf(HttpRequest request) async {
  final elapse = DateTime.now().add(Duration(seconds: 15));
  bool timeOut = false;
  bool isCloudFlare = true;

  try {
    final body = await utf8.decoder.bind(request).join();
    final data = jsonDecode(body) as Map<String, dynamic>;
    final url = data['url'] as String?;

    if (url == null) {
      request.response
        ..statusCode = HttpStatus.badRequest
        ..write(jsonEncode({'error': 'Missing url parameter'}))
        ..close();
      return;
    }

    flutter_inappwebview.HeadlessInAppWebView? headlessWebView;

    try {
      headlessWebView = flutter_inappwebview.HeadlessInAppWebView(
        webViewEnvironment: webViewEnvironment,
        initialUrlRequest: flutter_inappwebview.URLRequest(
          url: flutter_inappwebview.WebUri(url),
        ),
        shouldInterceptRequest: (controller, request) {
          if (request.url.toString().contains(RegExp('ads|admatic|3lift|dsp-service|beacon|report'))) {
            return flutter_inappwebview.WebResourceResponse(
              reasonPhrase: "Not found",
              statusCode: 404,
            );
          }

          return null;
        },
        onLoadStop: (controller, url) async {
          await Future.doWhile(() async {
            if (timeOut || !isCloudFlare) {
              return false;
            }

            await Future.delayed(Duration(milliseconds: 300));

            if (isCloudFlare) {
              isCloudFlare = await isChallengePresent(controller);
            }

            return isCloudFlare;
          });

          if (!isCloudFlare) {
            final ua = await controller.evaluateJavascript(source: "navigator.userAgent");

            await MClient.setCookie(url.toString(), ua ?? "", controller);
          }
        },
      );
      headlessWebView.run();

      await Future.doWhile(() async {
        timeOut = DateTime.now().isAfter(elapse);

        if (timeOut || !isCloudFlare) {
          return false;
        }

        await Future.delayed(const Duration(milliseconds: 100));
        return true;
      });
    } finally {
      final canDispose = flutter_inappwebview.HeadlessInAppWebView.isMethodSupported(
          flutter_inappwebview.PlatformHeadlessInAppWebViewMethod.dispose
      );

      if (canDispose && headlessWebView != null) {
        headlessWebView.dispose();
      }
    }

    request.response
      ..headers.contentType = ContentType.json
      ..write(jsonEncode({'result': isCloudFlare}))
      ..close();
  } catch (e) {
    request.response
      ..statusCode = HttpStatus.badRequest
      ..write(jsonEncode({'error': 'Invalid JSON'}))
      ..close();
  }
}
