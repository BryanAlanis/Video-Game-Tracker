import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:games_api/games_api.dart';
import 'package:video_game_tracker/screens/search%20screens/search_by_categories_screen.dart';
import 'package:video_game_tracker/screens/search%20screens/search_delegate.dart';
import 'package:video_game_tracker/util/styles.dart';
import 'package:video_game_tracker/widgets/custom_textfield.dart';
import '../../repositories/search_screen_repository.dart';

///
/// Creates the main search screen that shows the search bar and
/// a grid with the main categories that the user can click to be shown
/// more specific options.
///
class SearchScreen extends StatelessWidget {
  final List<GameModel> games;
  const SearchScreen({super.key, required this.games});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => SearchScreenRepository(games: games),
      child: SearchScreenView(games: games),
    );
  }
}

class SearchScreenView extends StatelessWidget {
  final List<GameModel> games;

  const SearchScreenView({super.key, required this.games});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        body: GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: getEdgePadding()),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 16/9,
            crossAxisCount: 2,
          ),
          itemCount: context.read<SearchScreenRepository>().categories.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context2) => RepositoryProvider.value(
                      value: context.read<SearchScreenRepository>(),
                      child: SearchByCategoriesScreen(
                        games: games,
                        index: index,
                      ),
                    )
                ));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(getBorderRadius()),
                ),
                child: Center(
                  child: Text(
                    context.read<SearchScreenRepository>()
                        .categories.keys.elementAt(index),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  )
                ),
              ),
            );
          }
        ),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              snap: false,
              floating: true,
              backgroundColor: Theme.of(context).colorScheme.surface,
              scrolledUnderElevation: 0,
              bottom: TextField(games: games),
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: EdgeInsets.only(top: 35, left: getEdgePadding(),),
                  child: Text(
                    'Search',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ),
            )
          ];
        },
      )
    );
  }
}

class TextField extends StatelessWidget implements PreferredSizeWidget{
  final List<GameModel> games;
  const TextField({super.key, required this.games});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: getEdgePadding(),
        right: getEdgePadding(),
        bottom: 30,
      ),
      child: GestureDetector(
        onTap: () => showSearch(context: context, delegate: CustomSearchDelegate(games: games)),
        child: const CustomTextField(
          enabled: false,
          hintText: 'Search',
          prefixIcon: Icon(Icons.search, size: 25,),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(250, 100);
}
