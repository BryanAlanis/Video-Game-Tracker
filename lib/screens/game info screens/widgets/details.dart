import 'package:flutter/material.dart';
import 'package:games_api/games_api.dart';

///
/// Details
///
/// Create a wrap widget that contains text for the details of a game.
/// The name of the category (genre, theme, game modes) and the actual values
/// for the category are included.
///
/// A wrap is used so the text doesn't overflow off the screen if the
/// text is too long
///
class Details extends StatelessWidget {
  final GameModel game;
  const Details({super.key, required this.game,});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DetailText(
          category: 'Genres: ',
          text: game.genres.join(', ')
        ),
        DetailText(
          category: 'Modes: ',
          text: game.modes.join(', ')
        ),
        DetailText(
          category: 'Themes: ',
          text: game.themes.join(', ')
        )
      ],
    );
  }
}

class DetailText extends StatelessWidget {
  final String category, text;
  const DetailText({super.key, required this.category, required this.text});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(category, style: Theme.of(context).textTheme.titleMedium,),
        Text(text, style: Theme.of(context).textTheme.bodyMedium,)
      ],
    );
  }
}
