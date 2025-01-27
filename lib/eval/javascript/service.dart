import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_qjs/flutter_qjs.dart';
import 'package:mangayomi/eval/javascript/dom_selector.dart';
import 'package:mangayomi/eval/javascript/extractors.dart';
import 'package:mangayomi/eval/javascript/http.dart';
import 'package:mangayomi/eval/javascript/preferences.dart';
import 'package:mangayomi/eval/javascript/utils.dart';
import 'package:mangayomi/eval/model/filter.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/video.dart';

import '../interface.dart';

final template = '''
class MProvider {
    get source() {
        return JSON.parse('__SOURCE__');
    }
    get supportsLatest() {
        throw new Error("supportsLatest not implemented");
    }
    getHeaders(url) {
        throw new Error("getHeaders not implemented");
    }
    async getPopular(page) {
        throw new Error("getPopular not implemented");
    }
    async getLatestUpdates(page) {
        throw new Error("getLatestUpdates not implemented");
    }
    async search(query, page, filters) {
        throw new Error("search not implemented");
    }
    async getDetail(url) {
        throw new Error("getDetail not implemented");
    }
    async getPageList() {
        throw new Error("getPageList not implemented");
    }
    async getVideoList(url) {
        throw new Error("getVideoList not implemented");
    }
    async getHtmlContent(url) {
        throw new Error("getHtmlContent not implemented");
    }
    async cleanHtmlContent(html) {
        throw new Error("cleanHtmlContent not implemented");
    }
    getFilterList() {
        throw new Error("getFilterList not implemented");
    }
    getSourcePreferences() {
        throw new Error("getSourcePreferences not implemented");
    }
}
async function jsonStringify(fn) {
    return JSON.stringify(await fn());
}
''';
final instantiation = '__CODE__\nlet extension = new DefaultExtension();';

final templateRegexp = RegExp(r'__(\w+)__');

String replaceMap(String template, Map<String, dynamic> map) => template.replaceAllMapped(
      templateRegexp,
      (match) {
        final key = match[1] ?? '';
        final value = map[key] ?? key;

        return value.toString();
      },
    );

class JsExtensionService implements ExtensionService {
  @override
  late Source source;
  late Map<String, dynamic> values = {
    'SOURCE': jsonEncode(source.toMSource().toJson()),
    'CODE': source.sourceCode!,
  };

  JavascriptRuntime? _runtime;

  JsExtensionService(this.source);

  JavascriptRuntime get runtime {
    if (_runtime != null) {
      return _runtime!;
    }

    _runtime = getJavascriptRuntime(xhr: false);
    JsHttpClient(_runtime!).init();
    JsDomSelector(_runtime!).init();
    JsVideosExtractors(_runtime!).init();
    JsUtils(_runtime!).init();
    JsPreferences(_runtime!, source).init();

    _evaluate(replaceMap(template, values));
    _evaluate(replaceMap(instantiation, values));

    return _runtime!;
  }

  JsEvalResult _evaluate(String code) {
    try {
      final result = runtime.evaluate(code);

      if (result.isError) {
        throw AssertionError(result.stringResult);
      }

      return result;
    } catch (e, trace) {
      if (kDebugMode) {
        final m = RegExp(r'(\w+) not implemented').allMatches(e.toString()).firstOrNull;

        if (m != null) {
          print('Warn: Source "${source.name!} (${source.lang!})" does not support "${m[1]}" method');
        } else {
          print('Evaluating $code');
          print(e);
          print(trace);
        }
      }

      rethrow;
    }
  }

  T _extensionCall<T>(String call, T def) {
    try {
      final res = _evaluate('/*sync*/ JSON.stringify(extension.$call)');

      return jsonDecode(res.stringResult) as T;
    } catch (_) {
      if (def != null) {
        return def;
      }

      rethrow;
    }
  }

  Future<T> _extensionCallAsync<T>(String call, T def) async {
    try {
      final promised = await runtime.handlePromise(
        _evaluate('/*async*/ jsonStringify(() => extension.$call)'),
      );

      return jsonDecode(promised.stringResult) as T;
    } catch (e, trace) {
      if (kDebugMode) {
        final m = RegExp(r'(\w+) not implemented').allMatches(e.toString()).firstOrNull;

        if (m != null) {
          print('Warn: Source "${source.name!} (${source.lang!})" does not support "${m[1]}" method');
        } else {
          print(e);
          print(trace);
        }
      }

      if (def != null) {
        return def;
      }

      rethrow;
    }
  }

  @override
  Map<String, String> getHeaders() {
    return _extensionCall<Map>('getHeaders(`${source.baseUrl ?? ''}`)', {}).toMapStringString!;
  }

  @override
  bool get supportsLatest {
    return _extensionCall<bool>('supportsLatest', true);
  }

  @override
  String get sourceBaseUrl {
    return source.baseUrl!;
  }

  @override
  Future<MPages> getPopular(int page) async {
    return MPages.fromJson(await _extensionCallAsync('getPopular($page)', {}));
  }

  @override
  Future<MPages> getLatestUpdates(int page) async {
    return MPages.fromJson(await _extensionCallAsync('getLatestUpdates($page)', {}));
  }

  @override
  Future<MPages> search(String query, int page, List<dynamic> filters) async {
    return MPages.fromJson(
        await _extensionCallAsync('search("$query",$page,${jsonEncode(filterValuesListToJson(filters))})', {}));
  }

  @override
  Future<MManga> getDetail(String url) async {
    return MManga.fromJson(await _extensionCallAsync('getDetail(`$url`)', {}));
  }

  @override
  Future<List<PageUrl>> getPageList(String url) async {
    return (await _extensionCallAsync<List>('getPageList(`$url`)', []))
        .map((e) => e is String ? PageUrl(e.trim()) : PageUrl.fromJson((e as Map).toMapStringDynamic!))
        .toList();
  }

  @override
  Future<List<Video>> getVideoList(String url) async {
    return (await _extensionCallAsync<List>('getVideoList(`$url`)', []))
        .where((element) => Video.isJson(element))
        .map((e) => Video.fromJson(e))
        .toList()
        .toSet()
        .toList();
  }

  @override
  Future<String> getHtmlContent(String url) async {
    return _extensionCallAsync('getHtmlContent(`$url`)', '');
  }

  @override
  Future<String> cleanHtmlContent(String html) async {
    return _extensionCallAsync('cleanHtmlContent(`$html`)', '');
  }

  @override
  FilterList getFilterList() {
    List<dynamic> list;

    try {
      list = fromJsonFilterValuesToList(_extensionCall('getFilterList()', []));
    } catch (_) {
      list = [];
    }

    return FilterList(list);
  }

  @override
  List<SourcePreference> getSourcePreferences() {
    return _extensionCall('getSourcePreferences()', [])
        .map((e) => SourcePreference.fromJson(e)..sourceId = source.id)
        .toList();
  }
}
