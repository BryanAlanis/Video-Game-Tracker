import 'package:flutter/material.dart';
import 'package:games_api/games_api.dart';
import 'package:video_game_tracker/widgets/make_image.dart';
import '../util/styles.dart';

class ViewGamesGrid extends StatelessWidget {
  final List<GameModel> games;
  final void Function()? onTap;
  final ScrollPhysics? scrollPhysics;
  final int? maxItems;

  const ViewGamesGrid({
    super.key,
    required this.games,
    this.onTap,
    this.scrollPhysics,
    this.maxItems
  });

  @override
  Widget build(BuildContext context) {
    final double edgePadding = getEdgePadding();

    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          physics: scrollPhysics,
          shrinkWrap: true,
          padding: EdgeInsets.only(
            top: edgePadding,
            right: edgePadding,
            left: edgePadding,
            bottom: edgePadding
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              /// More spacing for bigger devices
              crossAxisSpacing: constraints.maxWidth > 600 ? 20 : 10,
              mainAxisSpacing: constraints.maxWidth > 600 ? 20 : 10,
              /// Posters are 2:3 ratio
              childAspectRatio: 2/3,
              /// Show more items for bigger devices
              crossAxisCount: constraints.maxWidth > 600 ? 5 : 3
          ),
          itemCount: maxItems ?? games.length,
          itemBuilder: (BuildContext context, int index) {
            return
              Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(getBorderRadius()),
              ),
              child: MakeImage(
                game: games[index],
                onTap: onTap,
              ),
            );

          }
        );
      }
    );
  }
}