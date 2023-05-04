import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mangayomi/models/manga_history.dart';
import 'package:mangayomi/models/manga_reader.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/views/library/search_text_form_field.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final _textEditingController = TextEditingController();
  bool _isSearch = false;
  // List<MangaHistoryModel> entriesData = [];
  // List<MangaHistoryModel> entriesFilter = [];
  @override
  Widget build(BuildContext context) {
    return Container();
    
    
    
    
    // Scaffold(
    //   appBar: AppBar(
    //     elevation: 0,
    //     backgroundColor: Colors.transparent,
    //     title: _isSearch
    //         ? null
    //         : Text(
    //             'History',
    //             style: TextStyle(color: Theme.of(context).hintColor),
    //           ),
    //     actions: [
    //       _isSearch
    //           ? SeachFormTextField(
    //               onChanged: (value) {
    //                 setState(() {
    //                   entriesFilter = entriesData
    //                       .where((element) => element.modelManga.name!
    //                           .toLowerCase()
    //                           .contains(value.toLowerCase()))
    //                       .toList();
    //                 });
    //               },
    //               onSuffixPressed: () {
    //                 _textEditingController.clear();
    //                 setState(() {});
    //               },
    //               onPressed: () {
    //                 setState(() {
    //                   _isSearch = false;
    //                 });
    //                 _textEditingController.clear();
    //               },
    //               controller: _textEditingController,
    //             )
    //           : IconButton(
    //               splashRadius: 20,
    //               onPressed: () {
    //                 setState(() {
    //                   _isSearch = true;
    //                 });
    //               },
    //               icon: Icon(Icons.search, color: Theme.of(context).hintColor)),
    //       IconButton(
    //           splashRadius: 20,
    //           onPressed: () {
    //             showDialog(
    //                 context: context,
    //                 builder: (context) {
    //                   return AlertDialog(
    //                     title: const Text(
    //                       "Remove everything",
    //                     ),
    //                     content: const Text(
    //                         'Are you sure? All history will be lost.'),
    //                     actions: [
    //                       Row(
    //                         mainAxisAlignment: MainAxisAlignment.end,
    //                         children: [
    //                           TextButton(
    //                               onPressed: () {
    //                                 Navigator.pop(context);
    //                               },
    //                               child: const Text("Cancel")),
    //                           const SizedBox(
    //                             width: 15,
    //                           ),
    //                           TextButton(
    //                               onPressed: () {
    //                                 ref
    //                                     .watch(hiveBoxMangaHistoryProvider)
    //                                     .clear();
    //                                 Navigator.pop(context);
    //                               },
    //                               child: const Text("Ok")),
    //                         ],
    //                       )
    //                     ],
    //                   );
    //                 });
    //           },
    //           icon: Icon(Icons.delete_sweep_outlined,
    //               color: Theme.of(context).hintColor)),
    //     ],
    //   ),
    //   body: Padding(
    //     padding: const EdgeInsets.symmetric(horizontal: 20),
    //     child: ValueListenableBuilder<Box<MangaHistoryModel>>(
    //       valueListenable: ref.watch(hiveBoxMangaHistoryProvider).listenable(),
    //       builder: (context, value, child) {
    //         final entries = value.values.toList();
    //         entriesData = value.values.toList();
    //         final entriesHistory = _textEditingController.text.isNotEmpty
    //             ? entriesFilter
    //             : entries;
    //         if (entries.isNotEmpty) {
    //           return GroupedListView<MangaHistoryModel, String>(
    //             elements: entriesHistory,
    //             groupBy: (element) => element.date.substring(0, 10),
    //             groupSeparatorBuilder: (String groupByValue) => Padding(
    //               padding: const EdgeInsets.only(bottom: 8),
    //               child: Row(
    //                 children: [
    //                   Text(dateFormat(DateTime.parse(groupByValue))),
    //                 ],
    //               ),
    //             ),
    //             itemBuilder: (context, MangaHistoryModel element) {
    //               return SizedBox(
    //                 height: 105,
    //                 child: Row(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     SizedBox(
    //                       width: 60,
    //                       height: 90,
    //                       child: GestureDetector(
    //                         onTap: () {
    //                           context.push('/manga-reader/detail',
    //                               extra: element.modelManga);
    //                         },
    //                         child: ClipRRect(
    //                           borderRadius: BorderRadius.circular(7),
    //                           child: cachedNetworkImage(
    //                               headers: headers(element.modelManga.source!),
    //                               imageUrl: element.modelManga.imageUrl!,
    //                               width: 60,
    //                               height: 90,
    //                               fit: BoxFit.cover),
    //                         ),
    //                       ),
    //                     ),
    //                     Flexible(
    //                       child: ValueListenableBuilder<Box>(
    //                         valueListenable: ref
    //                             .watch(hiveBoxMangaInfoProvider)
    //                             .listenable(),
    //                         builder: (context, value, child) {
    //                           final values = value.get(
    //                               "${element.modelManga.lang}-${element.modelManga.source}/${element.modelManga.name}-chapter_index",
    //                               defaultValue: '');
    //                           if (values.isNotEmpty) {
    //                             return Row(
    //                               children: [
    //                                 Expanded(
    //                                   child: GestureDetector(
    //                                     onTap: () {
    //                                       pushMangaReaderView(
    //                                           context: context,
    //                                           modelManga: element.modelManga,
    //                                           index:
    //                                               int.parse(values.toString()));
    //                                     },
    //                                     child: Container(
    //                                       color: Colors.transparent,
    //                                       child: Padding(
    //                                         padding: const EdgeInsets.all(8.0),
    //                                         child: Column(
    //                                           mainAxisAlignment:
    //                                               MainAxisAlignment.center,
    //                                           crossAxisAlignment:
    //                                               CrossAxisAlignment.start,
    //                                           children: [
    //                                             Text(
    //                                               element.modelManga.name!,
    //                                               style: const TextStyle(
    //                                                   fontSize: 14,
    //                                                   fontWeight:
    //                                                       FontWeight.bold),
    //                                               textAlign: TextAlign.start,
    //                                             ),
    //                                             Wrap(
    //                                               crossAxisAlignment:
    //                                                   WrapCrossAlignment.end,
    //                                               children: [
    //                                                 Text(
    //                                                   element
    //                                                       .modelManga.chapters
    //                                                       .toList()[int.parse(
    //                                                           values
    //                                                               .toString())]
    //                                                       .name!,
    //                                                   style: const TextStyle(
    //                                                     fontSize: 11,
    //                                                   ),
    //                                                 ),
    //                                                 const Text(' - '),
    //                                                 Text(
    //                                                   DateFormat.Hm().format(
    //                                                       DateTime.parse(
    //                                                           element.date)),
    //                                                   style: const TextStyle(
    //                                                       fontSize: 11,
    //                                                       fontWeight:
    //                                                           FontWeight.w400),
    //                                                 ),
    //                                               ],
    //                                             ),
    //                                           ],
    //                                         ),
    //                                       ),
    //                                     ),
    //                                   ),
    //                                 ),
    //                                 IconButton(
    //                                     onPressed: () {
    //                                       showDialog(
    //                                           context: context,
    //                                           builder: (context) {
    //                                             return AlertDialog(
    //                                               title: const Text(
    //                                                 "Remove",
    //                                               ),
    //                                               content: const Text(
    //                                                   'This will remove the read date of this chapter. Are you sure?'),
    //                                               actions: [
    //                                                 Row(
    //                                                   mainAxisAlignment:
    //                                                       MainAxisAlignment.end,
    //                                                   children: [
    //                                                     TextButton(
    //                                                         onPressed: () {
    //                                                           Navigator.pop(
    //                                                               context);
    //                                                         },
    //                                                         child: const Text(
    //                                                             "Cancel")),
    //                                                     const SizedBox(
    //                                                       width: 15,
    //                                                     ),
    //                                                     TextButton(
    //                                                         onPressed: () {
    //                                                           ref
    //                                                               .watch(
    //                                                                   hiveBoxMangaHistoryProvider)
    //                                                               .delete(
    //                                                                   '${element.modelManga.lang}-${element.modelManga.link}');
    //                                                           Navigator.pop(
    //                                                               context);
    //                                                         },
    //                                                         child: const Text(
    //                                                             "Remove")),
    //                                                   ],
    //                                                 )
    //                                               ],
    //                                             );
    //                                           });
    //                                     },
    //                                     icon: const Icon(
    //                                       Icons.delete_outline,
    //                                       size: 25,
    //                                     )),
    //                               ],
    //                             );
    //                           }
    //                           return Container();
    //                         },
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //               );
    //             },
    //             itemComparator: (item1, item2) =>
    //                 item1.date.compareTo(item2.date),
    //             order: GroupedListOrder.DESC,
    //           );
    //         }
    //         return const Center(
    //           child: Text('Nothing read recently'),
    //         );
    //       },
    //     ),
    //   ),
    // );
  }
}
