import 'package:flutter/material.dart';
import 'package:games_api/games_api.dart';
import 'package:video_game_tracker/screens/lists%20screens/widgets/numbered_circle.dart';
import 'package:video_game_tracker/util/styles.dart';
import 'package:video_game_tracker/widgets/make_image.dart';

class NumberedGamesGrid extends StatelessWidget {
  final List<GameModel> games;
  final int? maxItems;
  final ScrollPhysics? scrollPhysics;

  const NumberedGamesGrid({
    super.key,
    required this.games,
    this.maxItems,
    this.scrollPhysics
  });

  @override
  Widget build(BuildContext context) {
    double edgePadding = getEdgePadding();
    double borderRadius = getBorderRadius();

    return GridView.builder(
      padding: EdgeInsets.all(edgePadding),
      physics: scrollPhysics,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2/3,
        mainAxisExtent: 180,
        crossAxisCount: 3
      ),
      itemCount: maxItems ?? games.length,
      itemBuilder: (BuildContext context, int index) {
        return Stack(
          alignment: Alignment.center,
          children: [
            /*** Image ***/
            Container(
              /// make the image slightly smaller than the overall tile for
              /// overlap effect between image and number
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: MakeImage(game: games[index])
              ),
            ),
            /*** Numbered Circle ***/
            NumberedCircle(
              alignment: Alignment.bottomCenter,
              outerCircleRadius: 12,
              innerCircleRadius: 11,
              index: index
            )
          ]
        );
      }
    );
  }
}