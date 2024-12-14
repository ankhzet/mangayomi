import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/modules/manga/detail/widgets/tracker_search_widget.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/manga.dart';
import 'package:mangayomi/utils/extensions/others.dart';
import 'package:mangayomi/utils/global_style.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share_plus/share_plus.dart';

class MangaCover extends StatelessWidget {
  final Manga manga;
  final double width;
  final double height;

  const MangaCover({
    super.key,
    required this.manga,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final imageProvider = manga.imageProvider(ref);

      return GestureDetector(
        onTap: () => _openImage(context, imageProvider),
        child: SizedBox(
          width: width,
          height: height,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    });
  }

  void _openImage(BuildContext context, ImageProvider imageProvider) {
    showDialog(
      context: context,
      builder: (context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: PhotoViewGallery.builder(
                backgroundDecoration: const BoxDecoration(color: Colors.transparent),
                itemCount: 1,
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: imageProvider,
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: 2.0,
                  );
                },
                loadingBuilder: (context, event) {
                  return const ProgressCenter();
                },
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: StreamBuilder(
                      stream: isar.trackPreferences.filter().syncIdIsNotNull().watch(fireImmediately: true),
                      builder: (context, snapshot) {
                        List<TrackPreference>? entries = snapshot.hasData ? snapshot.data! : [];
                        if (entries.isEmpty) {
                          return Container();
                        }
                        return Column(
                          children: entries
                              .map((e) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: MaterialButton(
                                      padding: const EdgeInsets.all(0),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      onPressed: () async {
                                        final trackSearch = await trackersSearchDraggableMenu(
                                          context,
                                          isManga: manga.isManga!,
                                          track: Track(
                                            status: TrackStatus.planToRead,
                                            syncId: e.syncId!,
                                            title: manga.name!,
                                          ),
                                        );

                                        if (trackSearch != null) {
                                          isar.writeTxnSync(() {
                                            isar.mangas.putSync(manga
                                              ..customCoverImage = null
                                              ..customCoverFromTracker = trackSearch.coverUrl);
                                          });

                                          if (context.mounted) {
                                            Navigator.pop(context);
                                            botToast(context.l10n.cover_updated, second: 3);
                                          }
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10), color: trackInfos(e.syncId!).$3),
                                        width: 45,
                                        height: 50,
                                        child: Image.asset(
                                          trackInfos(e.syncId!).$1,
                                          height: 30,
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: context.width(1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: context.isLight ? Colors.white : Colors.black),
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.close),
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: context.isLight ? Colors.white : Colors.black),
                            child: Row(
                              children: [
                                GestureDetector(
                                    onTap: () async {
                                      final bytes = await imageProvider.getBytes(context);
                                      if (bytes != null) {
                                        await Share.shareXFiles(
                                            [XFile.fromData(bytes, name: manga.name, mimeType: 'image/png')]);
                                      }
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(Icons.share),
                                    )),
                                GestureDetector(
                                    onTap: () async {
                                      final dir = await StorageProvider.getGalleryDirectory();

                                      if (context.mounted) {
                                        final bytes = await imageProvider.getBytes(context);
                                        if (bytes != null && context.mounted) {
                                          final file = File('$dir/${manga.name}.png');
                                          file.writeAsBytesSync(bytes);
                                          botToast(context.l10n.cover_saved, second: 3);
                                        }
                                      }
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(Icons.save_outlined),
                                    )),
                                PopupMenuButton(
                                  popUpAnimationStyle: popupAnimationStyle,
                                  itemBuilder: (context) {
                                    return [
                                      if (manga.customCoverImage != null || manga.customCoverFromTracker != null)
                                        PopupMenuItem<int>(value: 0, child: Text(context.l10n.delete)),
                                      PopupMenuItem<int>(value: 1, child: Text(context.l10n.edit)),
                                    ];
                                  },
                                  onSelected: (value) async {
                                    if (value == 0) {
                                      isar.writeTxnSync(() {
                                        isar.mangas.putSync(manga
                                          ..customCoverImage = null
                                          ..customCoverFromTracker = null);
                                      });
                                      Navigator.pop(context);
                                    } else if (value == 1) {
                                      FilePickerResult? result = await FilePicker.platform
                                          .pickFiles(type: FileType.custom, allowedExtensions: ['png', 'jpg', 'jpeg']);
                                      if (result != null && context.mounted) {
                                        if (result.files.first.size < 5000000) {
                                          final customCoverImage = File(result.files.first.path!).readAsBytesSync();
                                          isar.writeTxnSync(() {
                                            isar.mangas.putSync(manga..customCoverImage = customCoverImage);
                                          });
                                          botToast(context.l10n.cover_updated, second: 3);
                                        }
                                      }
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.edit_outlined,
                                        color: !context.isLight ? Colors.white : Colors.black,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
