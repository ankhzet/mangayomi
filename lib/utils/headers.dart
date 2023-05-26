import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/services/http_service/cloudflare/providers/cookie_providers.dart';
import 'package:mangayomi/sources/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'headers.g.dart';

@riverpod
Map<String, String> headers(HeadersRef ref, {String source = ""}) {
  source = source.toLowerCase();
  final cookie = ref.watch(cookieStateProvider(source));
  final userAgent = isar.settings.getSync(227)!.userAgent!;
  return source == 'mangakawaii'
      ? {
          'Referer': 'https://www.mangakawaii.io/',
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/8\$userAgentRandomizer1.0.4\$userAgentRandomizer3.1\$userAgentRandomizer2 Safari/537.36',
          'Accept-Language': 'fr'
        }
      : source == 'mangahere'
          ? {"Referer": "${getMangaBaseUrl(source)}/", "Cookie": "isAdult=1"}
          : source == 'comick'
              ? {
                  'Referer': "${getMangaBaseUrl(source)}/",
                  'User-Agent': 'Tachiyomi $userAgent'
                }
              : source == "japscan"
                  ? {
                      'User-Agent': userAgent,
                      'Referer': "${getMangaBaseUrl(source)}/",
                      "Cookie": cookie
                    }
                  : source == 'sushiscan'
                      ? {
                          'User-Agent': userAgent,
                          'Referer': "${getMangaBaseUrl(source)}/",
                          "Cookie": cookie
                        }
                      : getMangaTypeSource(source) == TypeSource.madara
                          ? {"Referer": "${getMangaBaseUrl(source)}/"}
                          : {};
}
