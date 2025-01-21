import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';

class PreloadTask {
  Chapter chapter;
  String directory;
  PageUrl? pageUrl;
  bool isLocal;
  Uint8List? archiveImage;
  int index;
  int pageIndex;
  GetChapterPagesModel? chapterUrlModel;
  Uint8List? cropImage;

  PreloadTask(
    this.chapter,
    this.directory,
    this.pageUrl,
    this.isLocal,
    this.archiveImage,
    this.index,
    this.chapterUrlModel, {
    this.cropImage,
  }) : pageIndex = index;

  File get preloadFile => file(directory, index);

  bool get isValid => pageUrl?.url.isNotEmpty == true;

  static String filename(int index) => '${padIndex(index + 1)}.jpg';

  static File file(String path, int index) => File('$path${filename(index)}');
}
