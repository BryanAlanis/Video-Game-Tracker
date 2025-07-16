import 'package:flutter/material.dart';
import 'package:games_api/games_api.dart';
import 'package:video_game_tracker/widgets/view_games_grid.dart';
import 'package:video_game_tracker/screens/browse%20screens/carousel_browse_screen.dart';

class BrowseScreen extends StatelessWidget {
  final List<GameModel> games;

  const BrowseScreen({super.key, required this.games});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Browse', style: Theme.of(context).textTheme.displaySmall,),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => CarouselBrowseScreen(games: games))
              );
            },
            icon: const Icon(Icons.view_carousel),
          )
        ],
      ),
      body: ViewGamesGrid(games: games,)
    );
  }
}