import 'package:flutter/material.dart';
import 'package:games_api/games_api.dart';

///
/// Widget used to emphasize text. In this screen it is used to
/// showcase the genres of this specific game.
///
/// Takes in a String and returns a card with that text in the center
///
class TextTag extends StatelessWidget {
  final GameModel game;
  const TextTag({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: game.platforms.length,
        itemBuilder: (context, int i){
          return Card(
            color: Theme.of(context).colorScheme.primary,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 35,
              ),
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    game.platforms[i].name,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              )
            )
          );
        }
      ),
    );
  }
}