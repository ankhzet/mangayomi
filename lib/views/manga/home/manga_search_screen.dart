import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/services/search_manga.dart';
import 'package:mangayomi/views/manga/home/mang_home_screen.dart';
import 'package:mangayomi/views/widgets/gridview_widget.dart';

class MangaSearchButton extends StatelessWidget {
  final String source;
  final String lang;
  MangaSearchButton({super.key, required this.source, required this.lang});

  late final CustomSearchDelegate _delegate =
      CustomSearchDelegate(source, lang);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: () async {
        await showSearch<dynamic>(
          context: context,
          delegate: _delegate,
        );
      },
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final String source;
  final String lang;
  CustomSearchDelegate(this.source, this.lang);

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const BackButtonIcon(),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text("Empty"));
    }

    return SearchResult(
      query: query,
      source: source,
      lang: lang,
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    if (query.isNotEmpty) {
      return [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
      ];
    }
    return [];
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: const AppBarTheme(),
      inputDecorationTheme: const InputDecorationTheme(hintStyle: TextStyle()),
      textTheme: theme.textTheme
          .copyWith(titleLarge: theme.textTheme.titleLarge!.copyWith()),
    );
  }
}

class SearchResult extends ConsumerWidget {
  final String query;
  final String source;
  final String lang;
  const SearchResult({
    super.key,
    required this.query,
    required this.source,
    required this.lang,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final search = ref.watch(searchMangaProvider(source: source, query: query));
    return search.when(
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
        error: (error, stackTrace) =>  Center(child: Text(error.toString())),
        data: (data) {
          if (data.name.isNotEmpty) {
            return GridViewWidget(
              itemCount: data.name.length,
              itemBuilder: (context, index) {
                return MangaHomeImageCard(
                  url: data.url[index]!,
                  name: data.name[index]!,
                  image: data.image[index]!,
                  source: source,
                  lang: lang,
                );
              },
            );
          }
          return const Center(
            child: Text("Empty"),
          );
        });
  }
}
