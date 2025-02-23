import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'convert_to_cbz.g.dart';

@riverpod
Future<List<String>> convertToCBZ(Ref ref, String sourceDir, String targetDir, String name, int files) async {
  return compute(_convertToCBZ, (sourceDir, targetDir, name, files));
}

List<String> _convertToCBZ((String, String, String, int) datas) {
  final (sourceDir, targetDir, name, files) = datas;
  final source = Directory(sourceDir);

  if (source.existsSync()) {
    final images = source.listSync().whereType<File>().where((file) => file.path.endsWith('.jpg'));

    if (images.isNotEmpty && files == images.length) {
      final sorted = images.toList()..sort((a, b) => a.path.compareTo(b.path));
      final encoder = ZipFileEncoder();

      encoder.create(path.join(targetDir, "$name.cbz"));

      for (var image in sorted) {
        encoder.addFile(image);
      }

      encoder.close();
      source.deleteSync(recursive: true);
    }

    return images.map((file) => file.path).toList();
  }

  return [];
}
