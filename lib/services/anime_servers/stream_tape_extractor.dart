import 'package:mangayomi/models/video.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:mangayomi/services/anime_servers/gogo_cdn_extractor.dart';

class StreamTapeExtractor {
  Future<List<Video>> videosFromUrl(String url,
      {String quality = "StreamTape"}) async {
    const baseUrl = "https://streamtape.com/e/";
    final newUrl =
        !url.startsWith(baseUrl) ? "$baseUrl${url.split("/")[4]}" : url;

    final response = await http.Client().get(Uri.parse(newUrl));
    final document = parse(response.body);

    const targetLine = "document.getElementById('robotlink')";
    String script = "";
    final scri = document
        .querySelectorAll("script")
        .where((element) => element.innerHtml.contains(targetLine))
        .map((e) => e.innerHtml)
        .toList();
    if (scri.isEmpty) {
      return [];
    } else {}
    script = scri.first.split("$targetLine.innerHTML = '").last;
    final videoUrl =
        "https:${script.substringBefore("'")}${script.substringAfter("+ ('xcd").substringBefore("'")}";

    return [Video(videoUrl, quality, videoUrl)];
  }
}
