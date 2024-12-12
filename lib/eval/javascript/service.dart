import 'dart:convert';
import 'package:flutter_qjs/flutter_qjs.dart';
import 'package:mangayomi/eval/javascript/dom_selector.dart';
import 'package:mangayomi/eval/javascript/extractors.dart';
import 'package:mangayomi/eval/javascript/http.dart';
import 'package:mangayomi/eval/javascript/preferences.dart';
import 'package:mangayomi/eval/javascript/utils.dart';
import 'package:mangayomi/eval/dart/model/filter.dart';
import 'package:mangayomi/eval/dart/model/m_manga.dart';
import 'package:mangayomi/eval/dart/model/m_pages.dart';
import 'package:mangayomi/eval/dart/model/source_preference.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/video.dart';

class JsExtensionService {
  late JavascriptRuntime runtime;
  late Source? source;
  JsExtensionService(this.source);

  void _init() {
    runtime = getJavascriptRuntime(xhr: false);
    JsHttpClient(runtime).init();
    JsDomSelector(runtime).init();
    JsVideosExtractors(runtime).init();
    JsUtils(runtime).init();
    JsPreferences(runtime, source).init();

    runtime.evaluate('''
class MProvider {
    get source() {
        return JSON.parse('${jsonEncode(source!.toMSource().toJson())}');
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
''');
    runtime.evaluate('''${source!.sourceCode}
var extention = new DefaultExtension();
''');
  }

  T _extensionCall<T>(String call, T def) {
    _init();

    try {
      final res = runtime.evaluate('JSON.stringify(extention.`$call`)');

      return jsonDecode(res.stringResult) as T;
    } catch (_) {
      if (def != null) {
        return def;
      }

      rethrow;
    }
  }

  Future<T> _extensionCallAsync<T>(String call, T def) async {
    _init();

    try {
      final promised = await runtime.handlePromise(await runtime.evaluateAsync('jsonStringify(() => extention.$call)'));

      return jsonDecode(promised.stringResult) as T;
    } catch (_) {
      if (def != null) {
        return def;
      }

      rethrow;
    }
  }

  Map<String, String> getHeaders(String url) {
    return _extensionCall<Map>('getHeaders(`$url`)', {}).toMapStringString!;
  }

  bool get supportsLatest {
    return _extensionCall<bool>('supportsLatest', true);
  }

  Future<MPages> getPopular(int page) async {
    return MPages.fromJson(await _extensionCallAsync('getPopular($page)', {}));
  }

  Future<MPages> getLatestUpdates(int page) async {
    return MPages.fromJson(await _extensionCallAsync('getLatestUpdates($page)', {}));
  }

  Future<MPages> search(String query, int page, String filters) async {
    return MPages.fromJson(await _extensionCallAsync('search("$query",$page,$filters)', {}));
  }

  Future<MManga> getDetail(String url) async {
    return MManga.fromJson(await _extensionCallAsync('getDetail(`$url`)', {}));
  }

  Future<List<PageUrl>> getPageList(String url) async {
    return (await _extensionCallAsync<List>('getPageList(`$url`)', []))
        .map((e) => e is String
          ? PageUrl(e.trim())
          : PageUrl.fromJson((e as Map).toMapStringDynamic!))
        .toList();
  }

  Future<List<Video>> getVideoList(String url) async {
    return (await _extensionCallAsync<List>('getVideoList(`$url`)', []))
        .where((element) => Video.isJson(element))
        .map((e) => Video.fromJson(e))
        .toList()
        .toSet()
        .toList();
  }

  dynamic getFilterList() {
    return FilterList(fromJsonFilterValuestoList(_extensionCall('getFilterList()', [])));
  }

  List<SourcePreference> getSourcePreferences() {
    return _extensionCall('getSourcePreferences()', [])
        .map((e) => SourcePreference.fromJson(e)..sourceId = source!.id)
        .toList();
  }
}
