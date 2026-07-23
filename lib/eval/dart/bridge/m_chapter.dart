import 'package:d4rt/d4rt.dart';
import 'package:mangayomi/eval/model/m_chapter.dart';

class MChapterBridge {
  final mChapterBridgedClass = BridgedClass(
    nativeType: MChapter,
    name: 'MChapter',
    constructors: {
      '': (visitor, positionalArgs, namedArgs) {
        return MChapter(
          name: namedArgs.get<String?>('name'),
          url: namedArgs.get<String?>('url'),
          dateUpload: namedArgs.get<String?>('dateUpload'),
          scanlator: namedArgs.get<String?>('scanlator'),
          isFiller: namedArgs.get<bool?>('isFiller'),
          thumbnailUrl: namedArgs.get<String?>('thumbnailUrl'),
          description: namedArgs.get<String?>('description'),
          downloadSize: namedArgs.get<String?>('downloadSize'),
          duration: namedArgs.get<String?>('duration'),
          uid: namedArgs.get<String?>('uid'),
          legacyUrl: namedArgs.get<String?>('legacyUrl'),
        );
      },
    },
    getters: {
      'name': (visitor, target) => (target as MChapter).name,
      'url': (visitor, target) => (target as MChapter).url,
      'dateUpload': (visitor, target) => (target as MChapter).dateUpload,
      'scanlator': (visitor, target) => (target as MChapter).scanlator,
      'isFiller': (visitor, target) => (target as MChapter).isFiller,
      'thumbnailUrl': (visitor, target) => (target as MChapter).thumbnailUrl,
      'description': (visitor, target) => (target as MChapter).description,
      'downloadSize': (visitor, target) => (target as MChapter).downloadSize,
      'duration': (visitor, target) => (target as MChapter).duration,
      'uid': (visitor, target) => (target as MChapter).uid,
      'legacyUrl': (visitor, target) => (target as MChapter).legacyUrl,
    },
    setters: {
      'name':
          (visitor, target, value) =>
              (target as MChapter).name = value as String?,
      'url':
          (visitor, target, value) =>
              (target as MChapter).url = value as String?,
      'dateUpload':
          (visitor, target, value) =>
              (target as MChapter).dateUpload = value as String?,
      'scanlator':
          (visitor, target, value) =>
              (target as MChapter).scanlator = value as String?,
      'isFiller':
          (visitor, target, value) =>
              (target as MChapter).isFiller = value as bool?,
      'thumbnailUrl':
          (visitor, target, value) =>
              (target as MChapter).thumbnailUrl = value as String?,
      'description':
          (visitor, target, value) =>
              (target as MChapter).description = value as String?,
      'downloadSize':
          (visitor, target, value) =>
              (target as MChapter).downloadSize = value as String?,
      'duration':
          (visitor, target, value) =>
              (target as MChapter).duration = value as String?,
      'uid':
          (visitor, target, value) =>
              (target as MChapter).uid = value as String?,
      'legacyUrl':
          (visitor, target, value) =>
              (target as MChapter).legacyUrl = value as String?,
    },
  );
  void registerBridgedClasses(D4rt interpreter) {
    interpreter.registerBridgedClass(
      mChapterBridgedClass,
      'package:mangayomi/bridge_lib.dart',
    );
  }
}
