import 'package:flutter/material.dart';
import 'package:games_api/games_api.dart';
import 'package:video_game_tracker/screens/browse%20screens/carousel_browse_screen.dart';
import 'package:video_game_tracker/widgets/view_games_grid.dart';

///
/// ViewGamesScreen
///
/// Create the screen where games are shown on a grid.
/// An action button on the app bar allows the user to enter the carousel screen.
///
class ViewGamesScreen extends StatelessWidget {
  final List<GameModel> games;
  final String title;

  const ViewGamesScreen({super.key, required this.games, required this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title, style: Theme.of(context).textTheme.displaySmall,),
          leading: BackButton(
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              onPressed:
              /// Disable button if there are no games
              games.isEmpty ? null
                : (){
                    Navigator.push(context, MaterialPageRoute(
                    builder: (context) => CarouselBrowseScreen(games: games)));
                  },
              icon: const Icon(Icons.view_carousel),
            )
          ],
        ),
        body: games.isEmpty ? const NoGamesFoundText() : ViewGamesGrid(games: games,)
      ),
    );
  }
}

class NoGamesFoundText extends StatelessWidget {
  const NoGamesFoundText({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No Games Found',
        style: Theme.of(context).textTheme.displaySmall,
      ),
    );
  }
}
