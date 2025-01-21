// ignore_for_file: depend_on_referenced_packages
import 'dart:io';

import 'package:isar/isar.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/changed_items.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/models/view_queue_item.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

extension SafeDelete on FileSystemEntity {
  Future<bool> safeRecursiveDelete() async {
    try {
      await delete(recursive: true);

      return true;
    } on FileSystemException {
      return false;
    }
  }

  bool safeRecursiveDeleteSync() {
    try {
      deleteSync(recursive: true);

      return true;
    } on FileSystemException {
      return false;
    }
  }
}

class StorageProvider {
  StorageProvider._();

  static late String documents;
  static const String mangayomi = 'Mangayomi';
  static const String androidStorage = '/storage/emulated/0';
  static const String backup = 'backup';
  static const String torrents = 'torrents';
  static const String downloads = 'downloads';
  static const String databases = 'databases';
  static const String pictures = 'Pictures';

  static Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      Permission permission = Permission.manageExternalStorage;

      if (!(await permission.isGranted)) {
        return false;
      }

      if (PermissionStatus.granted != (await permission.request())) {
        return false;
      }
    }

    documents = (await getApplicationDocumentsDirectory()).path.fixSeparator;

    return true;
  }

  static Future<String> ensureDirectoryPath(String path) async {
    return (await Directory(path.fixSeparator).create(recursive: true)).path;
  }

  static String getDefaultDirectoryPath() {
    return path.join(Platform.isAndroid ? androidStorage : documents, mangayomi);
  }

  static Future<String> getBackupDirectory() async {
    return ensureDirectoryPath(path.join(getDefaultDirectoryPath(), backup));
  }

  static String getBtDirectoryPath() {
    return path.join(getDefaultDirectoryPath(), torrents);
  }

  static Future<String> getBtDirectory() async {
    return ensureDirectoryPath(getBtDirectoryPath());
  }

  static Future<void> deleteBtDirectory() async {
    await Directory(getBtDirectoryPath()).safeRecursiveDelete();
  }

  static String getDownloadsDirectoryPath({bool useDefault = false}) {
    String location = isar.settings.first.downloadLocation?.fixSeparator ?? '';

    if (location.isNotEmpty && !useDefault) {
      return (Platform.isAndroid || path.basename(location.replaceAll(RegExp(r'[\\/]+$'), '')).endsWith(mangayomi))
          ? location
          : path.join(location, mangayomi);
    }

    return path.join(getDefaultDirectoryPath(), downloads);
  }

  static Future<String> getDownloadsDirectory() async {
    final path = await ensureDirectoryPath(getDownloadsDirectoryPath());

    if (Platform.isAndroid) {
      final nomedia = File("$path.nomedia");

      if (!(await nomedia.exists())) {
        await nomedia.create();
      }
    }

    return path;
  }

  static String getChapterDirectoryRelativePath(Chapter chapter) {
    final manga = chapter.manga.value!;
    final isManga = manga.isManga!;

    final mangaPath = getMangaMainDirectoryPath(manga, relative: true);

    if (isManga) {
      final scanlator = chapter.scanlator!;
      final prefix = scanlator.isNotEmpty ? '${scanlator.replaceForbiddenCharacters('_')}_' : '';

      return path.join(mangaPath, '$prefix${chapter.name!.replaceForbiddenCharacters('_')}');
    }

    return mangaPath;
  }

  static Future<String> getMangaChapterDirectory(Chapter chapter) async {
    return ensureDirectoryPath(path.join(
      getDownloadsDirectoryPath(),
      getChapterDirectoryRelativePath(chapter),
    ));
  }

  static String getMangaMainDirectoryPath(Manga manga, {bool relative = false}) {
    final type = manga.isManga! ? 'Manga' : 'Anime';
    final source = '${manga.source} (${manga.lang!.toUpperCase()})';
    final name = manga.name!.replaceForbiddenCharacters('_');

    return relative ? path.join(type, source, name) : path.join(getDownloadsDirectoryPath(), type, source, name);
  }

  static Future<String> getMangaMainDirectory(Manga manga) async {
    return ensureDirectoryPath(getMangaMainDirectoryPath(manga));
  }

  static Future<String> getDatabaseDirectory() async {
    if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      return documents;
    }

    return ensureDirectoryPath(path.join(documents, mangayomi, databases));
  }

  static Future<String> getGalleryDirectory() async {
    String gPath;

    if (Platform.isAndroid) {
      gPath = path.join(androidStorage, pictures, mangayomi);
    } else {
      gPath = path.join(getDownloadsDirectoryPath(), pictures);
    }

    return ensureDirectoryPath(gPath);
  }

  static Future<Isar> initDB(String? path, {bool? inspector = false}) async {
    final String directory = path ?? (await getDatabaseDirectory());
    final schemas = [
      MangaSchema,
      ChangedItemsSchema,
      ChapterSchema,
      CategorySchema,
      UpdateSchema,
      HistorySchema,
      DownloadSchema,
      SourceSchema,
      SettingsSchema,
      TrackPreferenceSchema,
      TrackSchema,
      SyncPreferenceSchema,
      SourcePreferenceSchema,
      SourcePreferenceStringValueSchema,
      ViewQueueItemSchema,
    ];

    final isar = Isar.openSync(schemas, directory: directory, name: "mangayomiDb", inspector: inspector!);

    if (isar.settings.filter().idEqualTo(227).isEmptySync()) {
      isar.settings.first = Settings();
    }

    return isar;
  }
}

extension StringPathExtension on String {
  String get fixSeparator => (path.separator == '/') ? this : replaceAll("/", path.separator);
}
