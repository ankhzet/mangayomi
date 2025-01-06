import 'package:mangayomi/eval/javascript/http.dart';

class PageUrl {
  String url;
  Map<String, String>? headers;

  PageUrl(this.url, {this.headers});

  bool get isValid => url.isNotEmpty == true;

  factory PageUrl.fromJson(Map<String, dynamic> json) {
    return PageUrl(
      json['url'].toString().trim(),
      headers: (json['headers'] as Map?)?.toMapStringString,
    );
  }

  Map<String, dynamic> toJson() => {'url': url, 'headers': headers};
}
