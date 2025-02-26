import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/models/source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_latest_updates.g.dart';

@riverpod
Future<MPages?> getLatestUpdates(
  Ref ref, {
  required Source source,
  required int page,
}) async {
  return getExtensionService(source).getLatestUpdates(page);
}
