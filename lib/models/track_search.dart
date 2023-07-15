class TrackSearch {
  int? id;

  int? mediaId;

  int? syncId;

  String? title;

  String? lastChapterRead;

  int? totalChapter;

  double? score;

  String? status;

  int? startedReadingDate;

  int? finishedReadingDate;

  String? trackingUrl;

  String? coverUrl;

  String? summary;

  String? publishingStatus;

  String? publishingType;

  String? startDate;

  TrackSearch(
      {this.id,
      this.mediaId,
      this.syncId,
      this.title,
      this.lastChapterRead,
      this.totalChapter,
      this.score,
      this.status = '',
      this.startedReadingDate,
      this.finishedReadingDate,
      this.trackingUrl,
      this.coverUrl= '',
      this.publishingStatus= '',
      this.publishingType= '',
      this.startDate= '',
      this.summary= ''});
}
