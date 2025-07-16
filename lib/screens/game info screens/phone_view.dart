import 'package:flutter/material.dart';
import '../../util/styles.dart';
import 'widgets/text_tag.dart';
import 'widgets/top_image.dart';
import 'package:games_api/games_api.dart';

class PhoneView extends StatelessWidget {
  final GameModel game;
  const PhoneView({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /*** Top Image ***/
        TopImage(
          imageID: game.cover,
          height: 450, //530
          width: double.infinity,
        ),
        /*** Title and year ***/
        Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              Text(
                game.name,
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              Text(
                game.firstReleaseDate.year.toString(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        /*** Platform tags ***/
        Padding(
          padding: EdgeInsets.all(getEdgePadding()),
          child: TextTag(game: game,),
        ),
      ],
    );
  }
}
