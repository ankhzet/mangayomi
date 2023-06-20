import 'package:mangayomi/models/source.dart';

const defaultDateFormat = "MMMM dd, yyyy";
const defaultDateFormatLocale = "en_US";

List<Source> get madaraSourcesList => _madaraSourcesList;
List<Source> _madaraSourcesList = [
  Source(
      sourceName: "FR-Scan",
      baseUrl: "https://fr-scan.com",
      lang: "fr",
      typeSource: TypeSource.madara,
      logoUrl: '',
      dateFormat: "MMMM d, yyyy",
      dateFormatLocale: "fr"),
  Source(
      sourceName: "AstralManga",
      baseUrl: "https://astral-manga.fr",
      lang: "fr",
      typeSource: TypeSource.madara,
      logoUrl: '',
      dateFormat: "dd/mm/yyyy",
      dateFormatLocale: "fr"),
  Source(
    sourceName: "Akuma no Tenshi",
    baseUrl: "https://akumanotenshi.com",
    lang: "tr",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "dd/MM/yyyy",
    dateFormatLocale: "pt-BR",
  ),
  Source(
    sourceName: "Adult Webtoon",
    baseUrl: "https://adultwebtoon.com",
    lang: "en",
    typeSource: TypeSource.madara,
    logoUrl: '',
    isNsfw: true,
    dateFormat: defaultDateFormat,
    dateFormatLocale: defaultDateFormatLocale,
  ),
  Source(
    sourceName: "Adult Webtoon",
    baseUrl: "https://adultwebtoon.com",
    lang: "en",
    typeSource: TypeSource.madara,
    logoUrl: '',
    isNsfw: true,
    dateFormat: defaultDateFormat,
    dateFormatLocale: defaultDateFormatLocale,
  ),
  Source(
    sourceName: "ArazNovel",
    baseUrl: "https://www.araznovel.com",
    lang: "tr",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "d MMMM yyyy",
    dateFormatLocale: "en",
  ),
  Source(
    sourceName: "BestManga",
    baseUrl: "https://bestmanga.club",
    lang: "ru",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "dd.MM.yyyy",
    dateFormatLocale: "ru",
  ),
  Source(
    sourceName: "Chibi Manga",
    baseUrl: "https://www.cmreader.info",
    lang: "en",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "MMM dd, yyyy",
    dateFormatLocale: defaultDateFormatLocale,
  ),
  // Source(
  //   sourceName: "Clover Manga",
  //   baseUrl: "https://clover-manga.com",
  //   lang: "tr",
  //   typeSource: TypeSource.madara,
  //   logoUrl: '',
  //   dateFormat: defaultDateFormat,
  //   dateFormatLocale: "tr",
  // ),
  Source(
    sourceName: "CookieToon",
    baseUrl: "https://cookietoon.online",
    lang: "pt-br",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "dd/MM/yyyy",
    dateFormatLocale: "pt-BR",
  ),
  Source(
    sourceName: "Drope Scan",
    baseUrl: "https://dropescan.com",
    lang: "pt-br",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "dd/MM/yyyy",
    dateFormatLocale: "pt-BR",
  ),
  Source(
    sourceName: "EvaScans",
    baseUrl: "https://evascans.com",
    lang: "tr",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "MMM d, yyy",
    dateFormatLocale: "tr",
  ),
  Source(
    sourceName: "Final Scans",
    baseUrl: "https://finalscans.com",
    lang: "pt-br",
    typeSource: TypeSource.madara,
    logoUrl: '',
    isNsfw: true,
    dateFormat: "MMMM d, yyyy",
    dateFormatLocale: "pt-BR",
  ),
  Source(
    sourceName: "Glory Manga",
    baseUrl: "https://glorymanga.com",
    lang: "tr",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "dd/MM/yyy",
    dateFormatLocale: "tr",
  ),
  Source(
    sourceName: "Hentai Manga",
    baseUrl: "https://hentaimanga.me",
    isNsfw: true,
    lang: "en",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "MMMM d, yyyy",
    dateFormatLocale: defaultDateFormatLocale,
  ),
  Source(
    sourceName: "HentaiWebtoon",
    baseUrl: "https://hentaiwebtoon.com",
    isNsfw: true,
    lang: "en",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "MMMM d, yyyy",
    dateFormatLocale: defaultDateFormatLocale,
  ),
  Source(
    sourceName: "Ikifeng",
    baseUrl: "https://ikifeng.com",
    lang: "es",
    typeSource: TypeSource.madara,
    logoUrl: '',
    isNsfw: true,
    dateFormat: "dd/MM/yyyy",
    dateFormatLocale: "es",
  ),
  Source(
    sourceName: "Inmortal Scan",
    baseUrl: "https://manga.mundodrama.site",
    lang: "es",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "MMMM d, yyyy",
    dateFormatLocale: "es",
  ),
  Source(
    sourceName: "Its Your Right Manhua",
    baseUrl: "https://itsyourightmanhua.com/",
    lang: "en",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "MMMM d, yyyy",
    dateFormatLocale: defaultDateFormatLocale,
  ),
  Source(
    sourceName: "Kami Sama Explorer",
    baseUrl: "https://leitor.kamisama.com.br",
    lang: "pt-br",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "dd 'de' MMMM 'de' yyyy",
    dateFormatLocale: "pt-BR",
  ),
  Source(
    sourceName: "KlikManga",
    baseUrl: "https://klikmanga.id",
    lang: "id",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: defaultDateFormat,
    dateFormatLocale: "id",
  ),
  Source(
    sourceName: "KSGroupScans",
    baseUrl: "https://ksgroupscans.com",
    lang: "en",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: defaultDateFormat,
    dateFormatLocale: defaultDateFormatLocale,
  ),
  Source(
    sourceName: "LHTranslation",
    baseUrl: "https://lhtranslation.net",
    lang: "en",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: defaultDateFormat,
    dateFormatLocale: defaultDateFormatLocale,
  ),
  Source(
    sourceName: "Lolicon",
    baseUrl: "https://lolicon.mobi",
    lang: "en",
    isNsfw: true,
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: defaultDateFormat,
    dateFormatLocale: defaultDateFormatLocale,
  ),
  Source(
    sourceName: "Lord Manga",
    baseUrl: "https://lordmanga.com",
    lang: "en",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "MMMM d, yyyy",
    dateFormatLocale: defaultDateFormatLocale,
  ),
  Source(
    sourceName: "MangaVisa",
    baseUrl: "https://mangavisa.com",
    lang: "en",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: defaultDateFormat,
    dateFormatLocale: defaultDateFormatLocale,
  ),
  Source(
    sourceName: "MangaClash",
    baseUrl: "https://mangaclash.com",
    lang: "en",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "MM/dd/yy",
    dateFormatLocale: defaultDateFormatLocale,
  ),
  Source(
    sourceName: "Manga District",
    baseUrl: "https://mangadistrict.com",
    lang: "tr",
    typeSource: TypeSource.madara,
    logoUrl: '',
    isNsfw: true,
    dateFormat: "MMMM d, yyyy",
    dateFormatLocale: defaultDateFormatLocale,
  ),
  Source(
    sourceName: "Manga-fast.com",
    baseUrl: "https://manga-fast.com",
    lang: "en",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "d MMMM'،' yyyy",
    dateFormatLocale: defaultDateFormatLocale,
  ),
  Source(
    sourceName: "Manga Fenix",
    baseUrl: "https://manga-fenix.com",
    lang: "es",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "MMMM d, yyyy",
    dateFormatLocale: "es",
  ),
  Source(
    sourceName: "MangaFreak.online",
    baseUrl: "https://mangafreak.online",
    lang: "en",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "d MMMM، yyy",
    dateFormatLocale: defaultDateFormatLocale,
  ),
  Source(
    sourceName: "MangaGreat",
    baseUrl: "https://mangagreat.com",
    lang: "en",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: defaultDateFormat,
    dateFormatLocale: defaultDateFormatLocale,
  ),
  Source(
    sourceName: "Manga Hentai",
    baseUrl: "https://mangahentai.me",
    lang: "en",
    isNsfw: true,
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: defaultDateFormat,
    dateFormatLocale: defaultDateFormatLocale,
  ),
  Source(
    sourceName: "MangaMe",
    baseUrl: "https://mangame.org",
    lang: "en",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "dd.MM.yyyy",
    dateFormatLocale: defaultDateFormatLocale,
  ),
  Source(
    sourceName: "Manga One Love",
    baseUrl: "https://mangaonelove.site",
    lang: "ru",
    typeSource: TypeSource.madara,
    logoUrl: '',
    isNsfw: true,
    dateFormat: "dd.MM.yyyy",
    dateFormatLocale: defaultDateFormatLocale,
  ),
  Source(
    sourceName: "Manga Read",
    baseUrl: "https://mangaread.co",
    lang: "en",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "yyyy-MM-dd",
    dateFormatLocale: defaultDateFormatLocale,
  ),
  Source(
    sourceName: "MangaRolls",
    baseUrl: "https://mangarolls.com",
    lang: "en",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: defaultDateFormat,
    dateFormatLocale: defaultDateFormatLocale,
  ),
  Source(
    sourceName: "Manga Şehri",
    baseUrl: "https://mangasehri.com",
    lang: "tr",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "dd/MM/yyy",
    dateFormatLocale: "tr",
  ),
  Source(
    sourceName: "Mangasushi",
    baseUrl: "https://mangasushi.org",
    lang: "en",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: defaultDateFormat,
    dateFormatLocale: defaultDateFormatLocale,
  ),
  Source(
    sourceName: "Manhwa68",
    baseUrl: "https://manhwa68.com",
    lang: "en",
    isNsfw: true,
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "MMMM d, yyyy",
    dateFormatLocale: defaultDateFormatLocale,
  ),

  Source(
    sourceName: "Manhwua.fans",
    baseUrl: "https://manhwua.fans",
    lang: "en",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "yyyy'年'M'月'd",
    dateFormatLocale: defaultDateFormatLocale,
  ),
  Source(
    sourceName: "ManyToon.me",
    baseUrl: "https://manytoon.me",
    lang: "en",
    isNsfw: true,
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "MMMM d, yyyy",
    dateFormatLocale: defaultDateFormatLocale,
  ),

  Source(
    sourceName: "Milftoon",
    baseUrl: "https://milftoon.xxx",
    lang: "en",
    isNsfw: true,
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "d MMMM, yyyy",
    dateFormatLocale: defaultDateFormatLocale,
  ),
  Source(
    sourceName: "MurimScan",
    baseUrl: "https://murimscan.run",
    lang: "en",
    isNsfw: true,
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "MMMM d, yyyy",
    dateFormatLocale: defaultDateFormatLocale,
  ),
  Source(
    sourceName: "Ninja Scan",
    baseUrl: "https://ninjascan.xyz",
    lang: "pt-br",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "dd 'de' MMMMM 'de' yyyy",
    dateFormatLocale: "pt-BR",
  ),
  Source(
    sourceName: "NovelCrow",
    baseUrl: "https://novelcrow.com",
    lang: "en",
    typeSource: TypeSource.madara,
    logoUrl: '',
    isNsfw: true,
    dateFormat: defaultDateFormat,
    dateFormatLocale: defaultDateFormatLocale,
  ),
  Source(
    sourceName: "Pirulito Rosa",
    baseUrl: "https://pirulitorosa.site",
    lang: "pt-br",
    typeSource: TypeSource.madara,
    logoUrl: '',
    isNsfw: true,
    dateFormat: "dd/MM/yyy",
    dateFormatLocale: "pt-BR",
  ),
  Source(
    sourceName: "RagnarokScan",
    baseUrl: "https://ragnarokscan.com",
    lang: "es",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "MMMMM dd, yyyy",
    dateFormatLocale: "es",
  ),
  Source(
    sourceName: "Ragnarok Scanlation",
    baseUrl: "https://ragnarokscanlation.com",
    lang: "es",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "MMMM d, yyyy",
    dateFormatLocale: "es",
  ),
  Source(
    sourceName: "Rio2 Manga",
    baseUrl: "https://rio2manga.com",
    lang: "en",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: defaultDateFormat,
    dateFormatLocale: defaultDateFormatLocale,
  ),
  Source(
    sourceName: "Romantik Manga",
    baseUrl: "https://rio2manga.com",
    lang: "tr",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "MMMM d, yyyy",
    dateFormatLocale: defaultDateFormatLocale,
  ),
  Source(
    sourceName: "SamuraiScan",
    baseUrl: "https://samuraiscan.com",
    lang: "es",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "MMMM d, yyyy",
    dateFormatLocale: "es",
  ),
  Source(
    sourceName: "Sdl scans",
    baseUrl: "https://sdlscans.com",
    lang: "es",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "MMMMM dd, yyyy",
    dateFormatLocale: "es",
  ),
  Source(
    sourceName: "Shayami",
    baseUrl: "https://shayami.com",
    lang: "es",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "MMM d, yyy",
    dateFormatLocale: "es",
  ),
  Source(
    sourceName: "Taurus Fansub",
    baseUrl: "https://tatakaescan.com",
    lang: "es",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "dd/MM/yyy",
    dateFormatLocale: "es",
  ),
  Source(
    sourceName: "The Sugar",
    baseUrl: "https://thesugarscan.com",
    lang: "pt-br",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "dd/MM/yyyy",
    dateFormatLocale: "pt-BR",
  ),
  // Source(
  //   sourceName: "365Manga",
  //   baseUrl: "https://365manga.com",
  //   lang: "en",
  //   typeSource: TypeSource.madara,
  //   logoUrl: '',
  //   dateFormat: defaultDateFormat,
  //   dateFormatLocale: defaultDateFormatLocale,
  // ),
  Source(
    sourceName: "Tortuga Ceviri",
    baseUrl: "https://tortuga-ceviri.com",
    lang: "tr",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "MMMM d, yyyy",
    dateFormatLocale: "tr",
  ),
  Source(
    sourceName: "Tumangaonline.site",
    baseUrl: "https://tumangaonline.site",
    lang: "es",
    isNsfw: true,
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "dd MMMMM, yyyy",
    dateFormatLocale: "es",
  ),
  Source(
    sourceName: "Winter Scan",
    baseUrl: "https://winterscan.com",
    lang: "pt-br",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "dd 'de' MMMM 'de' yyyy",
    dateFormatLocale: "pt-BR",
  ),
  Source(
    sourceName: "Yuri Verso",
    baseUrl: "https://yuri.live",
    lang: "pt-br",
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "dd/MM/yyyy",
    dateFormatLocale: "pt-BR",
  ),
  Source(
    sourceName: "Zero Scan",
    baseUrl: "https://zeroscan.com.br",
    lang: "pt-br",
    isNsfw: true,
    typeSource: TypeSource.madara,
    logoUrl: '',
    dateFormat: "dd/MM/yyyy",
    dateFormatLocale: "pt-BR",
  ),
  // Source(
  //   sourceName: "مانجا ليك",
  //   baseUrl: "https://mangalek.com",
  //   lang: "ar",
   
  //   typeSource: TypeSource.madara,
  //   logoUrl: '',
  //   dateFormat: "MMMM dd, yyyy",
  //   dateFormatLocale: "ar",
  // ),
];
