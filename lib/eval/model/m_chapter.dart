class MChapter {
  String? name;

  String? url;

  String? dateUpload;

  String? scanlator;

  bool? isFiller;

  String? thumbnailUrl;

  String? description;

  /// video size
  String? downloadSize;

  /// video duration
  String? duration;

  String? uid;

  String? legacyUrl;

  MChapter({
    this.name,
    this.url,
    this.dateUpload,
    this.scanlator,
    this.isFiller = false,
    this.thumbnailUrl,
    this.description,
    this.downloadSize,
    this.duration,
    this.uid,
    this.legacyUrl,
  });
  factory MChapter.fromJson(Map<String, dynamic> json) {
    return MChapter(
      name: json['name'],
      url: json['url'],
      dateUpload: json['dateUpload'],
      scanlator: json['scanlator'],
      isFiller: json['isFiller'] ?? false,
      thumbnailUrl: json['thumbnailUrl'],
      description: json['description'],
      downloadSize: json['downloadSize'],
      duration: json['duration'],
      uid: json['uid'],
      legacyUrl: json['legacyUrl'],
    );
  }
  Map<String, dynamic> toJson() => {
    'name': name,
    'url': url,
    'dateUpload': dateUpload,
    'scanlator': scanlator,
    'isFiller': isFiller,
    'thumbnailUrl': thumbnailUrl,
    'description': description,
    'downloadSize': downloadSize,
    'duration': duration,
    'uid': uid,
    'legacyUrl': legacyUrl,
  };
}
