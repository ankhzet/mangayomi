import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/fetch_anime_sources.dart';
import 'package:mangayomi/services/fetch_manga_sources.dart';
import 'package:mangayomi/services/fetch_novel_sources.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/language.dart';

class ExtensionListTileWidget extends ConsumerStatefulWidget {
  final Source source;
  final bool isTestSource;
  final String appVersion;

  const ExtensionListTileWidget({super.key, required this.source, required this.appVersion, this.isTestSource = false});

  @override
  ConsumerState<ExtensionListTileWidget> createState() => _ExtensionListTileWidgetState();
}

class _ExtensionListTileWidgetState extends ConsumerState<ExtensionListTileWidget> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final updateAvailable =
        (!widget.isTestSource) && compareVersions(widget.source.version!, widget.source.versionLast!) < 0;
    final sourceNotEmpty = widget.source.sourceCode?.isNotEmpty ?? false;
    final isObsolete = widget.source.isObsolete ?? false;
    final version = (widget.source.appMinVerReqLast?.isNotEmpty ?? false)
        ? widget.source.appMinVerReqLast!
        : widget.source.appMinVerReq ?? '';
    final isSupported = version.isNotEmpty ? compareVersions(widget.appVersion, version) > -1 : true;
    final shouldFetch = !(widget.isTestSource || (!updateAvailable && sourceNotEmpty));

    return ListTile(
      onTap: () async {
        if (widget.isTestSource) {
              isar.writeTxnSync(() {
                isar.sources.putSync(widget.source);
                ref
                    .read(synchingProvider(syncId: 1).notifier)
                    .addChangedPart(ActionType.updateExtension, widget.source.id, widget.source.toJson(), false);
              });
        }

        if (sourceNotEmpty || widget.isTestSource) {
          _open(context);
        } else {
          await _fetch();
        }
      },
      leading: Container(
        height: 37,
        width: 37,
        decoration: BoxDecoration(
          color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(5),
        ),
        child: widget.source.iconUrl!.isEmpty
            ? const Icon(Icons.extension_rounded)
            : cachedNetworkImage(
                imageUrl: widget.source.iconUrl!,
                fit: BoxFit.contain,
                width: 37,
                height: 37,
                errorWidget: const SizedBox(
                  width: 37,
                  height: 37,
                  child: Center(child: Icon(Icons.extension_rounded)),
                ),
                useCustomNetworkImage: false),
      ),
      title: Text(widget.source.name!),
      subtitle: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            completeLanguageName(widget.source.lang!.toLowerCase()),
            style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
          ),
          const SizedBox(width: 4),
          Text(widget.source.version!, style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 12)),
          if (isObsolete)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text("OBSOLETE",
                  style: TextStyle(color: context.primaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          if (!isSupported)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                "UNSUPPORTED ($version > ${widget.appVersion})",
                style: TextStyle(color: context.errorColor, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
        ],
      ),
      trailing: (isSupported || !shouldFetch)
          ? TextButton(
              onPressed: shouldFetch ? _fetch : () => _open(context),
              child: _isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2.0))
                  : Text(widget.isTestSource
                      ? l10n.settings
                      : !sourceNotEmpty
                          ? l10n.install
                          : updateAvailable
                              ? l10n.update
                              : l10n.settings),
            )
          : null,
    );
  }

  _open(BuildContext context) {
    context.push('/extension_detail', extra: widget.source);
  }

  _fetch() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ref.watch(switch (widget.source.itemType) {
        ItemType.manga => fetchMangaSourcesListProvider(id: widget.source.id, reFresh: true).future,
        ItemType.anime => fetchAnimeSourcesListProvider(id: widget.source.id, reFresh: true).future,
        ItemType.novel => fetchNovelSourcesListProvider(id: widget.source.id, reFresh: true).future,
      });
    } catch (e) {
      botToast(e.toString(), isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
