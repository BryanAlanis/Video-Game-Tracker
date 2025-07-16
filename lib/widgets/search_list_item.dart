import 'package:flutter/material.dart';
import 'package:games_api/games_api.dart';
import 'package:video_game_tracker/screens/lists%20screens/widgets/numbered_circle.dart';
import 'package:video_game_tracker/util/styles.dart';
import 'make_image.dart';

///
/// SearchListItem
///
/// Builds an item that shows the game's cover image, the title, and year
/// of release.
///
/// The widget can be customized with:
///   -The item's rank if the list is ranked
///   -A trailing icon to show the user that the item is draggable
///
class SearchListItem extends StatelessWidget {
  final GameModel game;
  final bool showDragIcon;
  final bool ranked;
  final int index;

  const SearchListItem({
    super.key,
    required this.game,
    this.showDragIcon = false,
    this.ranked = false,
    this.index = 0,});

  @override
  Widget build(BuildContext context) {
    double edgePadding = getEdgePadding();

    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(right: edgePadding),
          height: 130,
          width: double.infinity,
          child: Row (
            children: [
              if (ranked) Padding(
                padding: const EdgeInsets.only(left: 5),
                child: NumberedImage(
                  game: game,
                  number: index
                ),
              )
              else Padding(
                padding: EdgeInsets.only(left: edgePadding),
                child: SizedBox(
                  height: 115,
                  width:  80,
                  child: MakeImage(
                    game: game,
                    onTap: (){}, /// Make image not clickable
                  )
                ),
              ),
              Expanded( /// Wraps long titles onto the next line
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        game.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${game.firstReleaseDate.year}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    ],
                  )
                ),
              ),
              if (showDragIcon)
                /// Make item only draggable if this icon is pressed
                ReorderableDragStartListener(
                  enabled: true,
                  index: index,
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.reorder, color: Colors.white,)
                  ),
                )
              else
                const SizedBox(),
            ]
          )
        ),
        const Divider(color: Colors.white30,)
      ],
    );
  }
}

///
/// Returns an image with it's ranking on the top left corner
///
class NumberedImage extends StatelessWidget {
  final GameModel game;
  final int number;

  const NumberedImage({super.key, required this.game, required this.number});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125,
      width:  90,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              height: 115,
              width: 80,
              child: MakeImage(
                game: game,
                onTap: (){}, /// Make image not clickable
              ),
            ),
          ),
          NumberedCircle(
            alignment: Alignment.topLeft,
            outerCircleRadius: 13,
            innerCircleRadius: 11,
            index: number
          )
        ]
      )
    );
  }
}