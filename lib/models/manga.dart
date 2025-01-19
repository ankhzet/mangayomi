import 'package:isar/isar.dart';
import 'package:mangayomi/models/chapter.dart';

part 'manga.g.dart';

@collection
@Name("Manga")
class Manga {
  late Id id;

  String? name;

  String? link;

  String? imageUrl;

  String? description;

  String? author;

  String? artist;

  @enumerated
  late Status status;

  bool? isManga;

  String? updateError;

  List<String>? genre;

  @Index(name: "favorite")
  bool? favorite;

  @Index(name: "source")
  String? source;

  String? lang;

  int? dateAdded;

  int? lastUpdate;

  int? lastRead;

  List<int>? categories;

  @Index(name: "isLocalArchive")
  bool? isLocalArchive;

  List<byte>? customCoverImage;

  String? customCoverFromTracker;

  @Backlink(to: "manga")
  final chapters = IsarLinks<Chapter>();

  Manga({
    this.id = Isar.autoIncrement,
    required this.source,
    this.status = Status.unknown,
    this.author,
    this.artist,
    this.favorite = false,
    this.genre,
    this.imageUrl,
    this.lang,
    this.link,
    this.name,
    this.description,
    this.isManga = true,
    this.dateAdded,
    this.lastUpdate,
    this.categories,
    this.lastRead = 0,
    this.isLocalArchive = false,
    this.customCoverImage,
    this.customCoverFromTracker,
  });

  Manga.fromJson(Map<String, dynamic> json) {
    author = json['author'];
    artist = json['artist'];
    categories = json['categories']?.cast<int>();
    customCoverImage = json['customCoverImage']?.cast<int>();
    dateAdded = json['dateAdded'];
    description = json['description'];
    favorite = json['favorite']!;
    genre = json['genre']?.cast<String>();
    id = json['id'];
    imageUrl = json['imageUrl'];
    isLocalArchive = json['isLocalArchive'];
    isManga = json['isManga'];
    lang = json['lang'];
    lastRead = json['lastRead'];
    lastUpdate = json['lastUpdate'];
    link = json['link'];
    name = json['name'];
    source = json['source'];
    status = Status.values[json['status']];
    customCoverFromTracker = json['customCoverFromTracker'];
  }

  Map<String, dynamic> toJson() => {
        'author': author,
        'artist': artist,
        'categories': categories,
        'customCoverImage': customCoverImage,
        'dateAdded': dateAdded,
        'description': description,
        'favorite': favorite,
        'genre': genre,
        'id': id,
        'imageUrl': imageUrl,
        'isLocalArchive': isLocalArchive,
        'isManga': isManga,
        'lang': lang,
        'lastRead': lastRead,
        'lastUpdate': lastUpdate,
        'link': link,
        'name': name,
        'source': source,
        'status': status.index,
        'customCoverFromTracker': customCoverFromTracker,
      };
}

enum Status { ongoing, completed, canceled, unknown, onHiatus, publishingFinished }
