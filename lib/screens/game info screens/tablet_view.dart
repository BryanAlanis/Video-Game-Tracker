import 'package:flutter/material.dart';
import 'package:video_game_tracker/widgets/make_image.dart';
import '../../util/styles.dart';
import 'widgets/text_tag.dart';
import 'widgets/top_image.dart';
import 'package:games_api/games_api.dart';

class TabletView extends StatelessWidget {
  final GameModel game;
  final BoxConstraints constraints;
  const TabletView({super.key, required this.game, required this.constraints});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getEdgePadding()),
      child: SizedBox(
        height: 450,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            /*** Top Image ***/
            TopImage(
              imageID: game.screenshots[0].imageId,
              height: 350,
              width: constraints.maxWidth,
            ),
            /*** Title and year ***/
            Positioned(
              bottom: 30,
              width: constraints.maxWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(height: 120, width: 90, child: MakeImage(game: game)),
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
                  // Padding(
                  //   padding: EdgeInsets.all(getEdgePadding()),
                  //   child: TextTag(game: game,),
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}