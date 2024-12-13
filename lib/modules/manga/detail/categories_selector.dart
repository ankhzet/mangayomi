import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_filter_list_tile_widget.dart';

class CategoriesSelector extends ConsumerStatefulWidget {
  final bool? isManga;
  final dynamic Function(Category category, bool select) onSelect;

  const CategoriesSelector({super.key, required this.isManga, required this.onSelect});

  @override
  ConsumerState<CategoriesSelector> createState() => _CategoriesSelectorState();
}

class _CategoriesSelectorState extends ConsumerState<CategoriesSelector> {
  List<int> selection = [];

  @override
  Widget build(BuildContext context) {
    var query = isar.categorys.filter().idIsNotNull();

    if (widget.isManga != null) {
      query = query.and().forMangaEqualTo(widget.isManga);
    }

    return StreamBuilder(
      stream: query.watch(fireImmediately: true),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container();
        }

        final entries = snapshot.data!;

        return ListView.builder(
          shrinkWrap: true,
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final category = entries[index];
            final id = category.id;

            return ListTileItemFilter(
              label: category.name!,
              type: selection.contains(id) ? 1 : 0,
              onTap: () {
                setState(() {
                  final select = !selection.contains(id);

                  if (widget.onSelect(category, select) != false) {
                    if (select) {
                      selection.add(id!);
                    } else {
                      selection.remove(id);
                    }
                  }
                });
              },
            );
          },
        );
      },
    );
  }
}
