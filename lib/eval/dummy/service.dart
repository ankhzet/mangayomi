import 'package:mangayomi/eval/model/filter.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/video.dart';

import '../interface.dart';

class DummyExtensionService implements ExtensionService {
  @override
  late Source source;

  DummyExtensionService(this.source);

  @override
  void dispose() {
  }

  @override
  Map<String, String> getHeaders() {
    return {};
  }

  @override
  String get sourceBaseUrl {
    return source.baseUrl!;
  }

  @override
  bool get supportsLatest {
    return false;
  }

  @override
  Future<MPages> getPopular(int page) async => MPages(list: []);

  @override
  Future<MPages> getLatestUpdates(int page) async => MPages(list: []);

  @override
  Future<MPages> search(String query, int page, List<dynamic> filters) async {
    return MPages(list: []);
  }

  @override
  Future<MManga> getDetail(String url) async => MManga(link: url);

  @override
  Future<List<PageUrl>> getPageList(String url) async {
    return [];
  }

  @override
  Future<List<Video>> getVideoList(String url) async => [];

  @override
  Future<String> getHtmlContent(String url, String? referer) async => '';

  @override
  Future<String> cleanHtmlContent(String html) async => '';

  @override
  FilterList getFilterList() {
    return FilterList([]);
  }

  @override
  List<SourcePreference> getSourcePreferences() {
    return const [];
  }
}
