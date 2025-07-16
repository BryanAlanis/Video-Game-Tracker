import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:games_api/games_api.dart';
import 'package:video_game_tracker/screens/browse%20screens/view_games_screen.dart';
import 'package:video_game_tracker/util/styles.dart';
import '../../repositories/search_screen_repository.dart';

///
/// Creates the screen that shows the in-depth categories.
/// For example, if a user chooses 'Platforms' on the previous
/// screen, this screen will show a grid with all available platforms.
///
class SearchByCategoriesScreen extends StatelessWidget {
  final int index;
  final List<GameModel> games;

  const SearchByCategoriesScreen({
    super.key,
    required this.index,
    required this.games,
  });

  @override
  Widget build(BuildContext context) {
    String title = context.read<SearchScreenRepository>()
        .categories.keys.elementAt(index);
    List<String> categories = context.read<SearchScreenRepository>()
        .categories.values.elementAt(index);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: GridView.builder(
            padding: EdgeInsets.only(
              top: 30,
              left: getEdgePadding(),
              right: getEdgePadding()
            ),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: (MediaQuery.of(context).size.width) /
                  (MediaQuery.of(context).size.height / 4),
              crossAxisCount: 2,
            ),
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  /** Looks for games where the category matches the button that was clicked**/
                  List<GameModel> filteredList =
                    context.read<SearchScreenRepository>()
                        .getFilteredList(index, title);

                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ViewGamesScreen(
                        title: categories[index], games: filteredList
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
                      categories[index],
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall,
                    )
                  ),
                ),
              );
            }
        ),
      ),
    );
  }
}