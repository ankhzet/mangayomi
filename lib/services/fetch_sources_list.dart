import 'dart:convert';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/utils/extensions/others.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<void> fetchSourcesList({
  int? id,
  required bool refresh,
  required Ref ref,
  required ItemType itemType,
  required Repo? repo,
}) async {
  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
  final url = repo?.jsonUrl;
  if (url == null) return;

  final req = await http.get(Uri.parse(url));

  final version = (await PackageInfo.fromPlatform()).version;
  final sourceList =
      (jsonDecode(req.body) as List).map((e) => Source.fromJson(e)).where((source) => source.itemType == itemType);

  bool isSupported(Source source) {
    return (source.appMinVerReq != null) && (compareVersions(version, source.appMinVerReq!) > -1);
  }

  // if (sourceList.isNotEmpty && sourcesOfType.isEmpty) {
  //   throw AssertionError('No extensions that support current app version ($version)');
  // }

  final copy = copyTo(itemType, repo);
  final updated = <Source>[];

  if (id != null) {
    final source = sourceList.firstWhereOrNull((item) => item.id == id);

    if (source != null) {
      if (isSupported(source)) {
        final persisted = isar.sources.getSync(id)!;
        final req = await http.get(Uri.parse(source.sourceCodeUrl!));
        final headers = getExtensionService(source..sourceCode = req.body).getHeaders();

        updated.add(
            copy(persisted, source)..headers = jsonEncode(headers),
        );
        // log("successfully installed or updated");
      } else {
          throw AssertionError('No extensions that support current app version ($version)');
      }
    }
  } else {
    final autoupdate = ref.watch(autoUpdateExtensionsStateProvider);

    for (final source in sourceList) {
      final persisted = isar.sources.getSync(source.id!);

      if (persisted != null) {
        // log("exist");
        if (!(persisted.isAdded! && (compareVersions(persisted.version!, source.version!) < 0))) {
          continue;
        }

        if (autoupdate && isSupported(source)) {
          // log("update available auto update");
          final req = await http.get(Uri.parse(source.sourceCodeUrl!));
          final headers = getExtensionService(source..sourceCode = req.body).getHeaders();

          updated.add(
            copy(persisted, source)..headers = jsonEncode(headers),
          );
        } else {
          // log("update available");
          updated.add(
              persisted
                ..versionLast = source.version
                ..appMinVerReqLast = source.appMinVerReq
          );
        }
      } else if (isSupported(source)) {
        updated.add(copy(Source(), source));
        // log("new source");
      }
    }
  }

  if (updated.isNotEmpty) {
    isar.writeTxnSync(() {
      isar.sources.putAllSync(updated);
    });

    final notifier = ref.read(synchingProvider(syncId: 1).notifier);

    for (final source in updated) {
      notifier.addChangedPart(ActionType.updateExtension, source.id, source.toJson(), false);
    }

    checkIfSourceIsObsolete(sourceList, itemType, url, ref);
  }
}

void checkIfSourceIsObsolete(
    Iterable<Source> sourceList,
    ItemType itemType,
    String repoUrl,
    Ref ref,
) {
  final ids = sourceList.map((e) => e.id).whereType<int>();

  if (ids.isEmpty) {
    return;
  }

  final sources = isar.sources
  //
      .filter()
      .idIsNotNull()
      .itemTypeEqualTo(itemType)
      .and()
      .not()
      .isLocalEqualTo(true)
      .findAllSync();
  final updated = <Source>[];

  for (var source in sources) {
    final isSameRepo = source.repo?.jsonUrl == repoUrl;
    final isObsolete = isSameRepo && (!ids.contains(source.id));
    final isUpdated = source.isObsolete != isObsolete;

    if (isUpdated) {
      updated.add(source..isObsolete = isObsolete);
    }
  }

  if (updated.isNotEmpty) {
    isar.writeTxnSync(() {
      isar.sources.putAllSync(updated, saveLinks: true);
    });

    final notifier = ref.read(synchingProvider(syncId: 1).notifier);

    for (final source in updated) {
      notifier.addChangedPart(ActionType.updateExtension, source.id, source.toJson(), false);
    }
  }
}

Source Function(Source to, Source from) copyTo(ItemType itemType, Repo? repo) {
  return (Source to, Source from) => to
    ..isAdded = true
    ..itemType = itemType
    ..id = from.id
    ..sourceCodeUrl = from.sourceCodeUrl
    ..sourceCode = from.sourceCode
    ..apiUrl = from.apiUrl
    ..baseUrl = from.baseUrl
    ..dateFormat = from.dateFormat
    ..dateFormatLocale = from.dateFormatLocale
    ..hasCloudflare = from.hasCloudflare
    ..iconUrl = from.iconUrl
    ..typeSource = from.typeSource
    ..lang = from.lang
    ..isNsfw = from.isNsfw
    ..name = from.name
    ..version = from.version
    ..versionLast = from.version
    ..isFullData = from.isFullData ?? false
    ..appMinVerReq = from.appMinVerReq
    ..sourceCodeLanguage = from.sourceCodeLanguage
    ..additionalParams = from.additionalParams ?? ""
    ..isObsolete = false
    ..repo = repo;
}

int compareVersions(String version1, String version2) {
  List<String> v1Components = version1.split('.');
  List<String> v2Components = version2.split('.');

  int totalV1 = version1.isNotEmpty ? v1Components.length : 0;
  int totalV2 = version2.isNotEmpty ? v2Components.length : 0;
  int minLength = min(totalV1, totalV2);

  for (int i = 0; i < minLength; i++) {
    String v1 = v1Components[i];
    String v2 = v2Components[i];

    int v1Value = int.parse(totalV1 == i + 1 && v1.length == 1 ? "${v1}0" : v1);
    int v2Value = int.parse(totalV2 == i + 1 && v2.length == 1 ? "${v2}0" : v2);
    int delta = v1Value - v2Value;

    if (delta == 0) {
      continue;
    }

    return delta.sign;
  }

  return (totalV1 - totalV2).sign;
}
