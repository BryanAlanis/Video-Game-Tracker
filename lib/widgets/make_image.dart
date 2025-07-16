import 'package:flutter/material.dart';
import 'package:video_game_tracker/screens/game%20info%20screens/game_info.dart';
import 'package:games_api/games_api.dart';

class MakeImage extends StatelessWidget {
  final GameModel game;
  final void Function()? onTap; /// Allows for different behaviour on tap if needed

  const MakeImage({super.key, required this.game, this.onTap});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2/3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: GestureDetector(
          onTap: onTap ?? () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => GameInfo(game: game))
            );
          },
          child: Image.network(
            "https://images.igdb.com/igdb/image/upload/t_1080p/"
                "${game.cover}.jpg",
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}