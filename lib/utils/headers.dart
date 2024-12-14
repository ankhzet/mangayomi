import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/javascript/http.dart';
import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'headers.g.dart';

@riverpod
Map<String, String> headers(Ref ref, {required String source, required String lang}) {
  final mSource = getSource(lang, source);
  if (mSource == null) return {};
  Map<String, String> headers = {};
  if (mSource.headers?.isNotEmpty ?? false) {
    headers = (jsonDecode(mSource.headers!) as Map).toMapStringString!;
  }
  headers.addAll(getSourceHeaders(mSource));
  final cookies = MClient.getCookiesPref(mSource.baseUrl!);
  headers.addAll(cookies);

  return headers;
}
