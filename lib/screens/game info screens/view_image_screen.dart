import 'package:flutter/material.dart';
import 'package:games_api/games_api.dart';
import 'package:video_game_tracker/util/styles.dart';
import 'package:card_swiper/card_swiper.dart';


class ViewImageScreen extends StatefulWidget {
  final int startIndex;
  final GameModel game;

  const ViewImageScreen({super.key, required this.startIndex, required this.game});

  @override
  State<ViewImageScreen> createState() => _ViewImageScreenState();
}


class _ViewImageScreenState extends State<ViewImageScreen> {
  /// currIndex is used to keep track of the current image.
  /// I was having issues with the slider returning to startIndex
  /// when animating as the user dragged the image. I believe this is due to
  /// flutter rebuilding the widget tree when animating. startIndex
  /// stayed at it's original value so the slider returned to the original image every time.
  int currIndex = 0;

  // used with AnimatedPositioned to animate dragging an image
  double draggedTop = 0;

  @override
  void initState() {
    currIndex = widget.startIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Make sure currIndex is returned to previous screen when using physical back button
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        /// call to pop() came programmatically so allow the pop
        if (didPop) {
          return;
        }

        /// call came from the system (android gesture)
        /// so make sure to return the current index
        Navigator.pop(context, currIndex);
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          extendBodyBehindAppBar: true,
            appBar: AppBar(
              leading: BackButton(onPressed: () => Navigator.pop(context, currIndex),)  //Send back the index to update previous screen
            ),
            body: Stack(
              children: [
                AnimatedPositioned(
                  top: draggedTop, left: 0, right: 0, bottom: 0,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeOut,
                  child: Swiper(
                    pagination: getPagination(),
                    index: currIndex,
                    onIndexChanged: onIndexChanged,
                    itemCount: widget.game.screenshots.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onVerticalDragUpdate: (DragUpdateDetails details) {
                          /// Variable updated before condition to allow fluid movement
                          /// instead of having the image stuck at the boundaries.
                          draggedTop = draggedTop + details.delta.dy;

                          /// Allow the image to be dragged as long as it stays between these boundaries
                          if (draggedTop <= 225 && draggedTop >= -225) {
                            setState(() {});
                          }
                        },
                        onVerticalDragEnd: (DragEndDetails details) {
                          /// if the image reaches a certain threshold, go to previous screen
                          if (draggedTop > 225 || draggedTop < -225) {
                            Navigator.pop(context, currIndex);
                          }
                          /// otherwise return image to original position
                          else {
                            draggedTop = 0;
                            setState(() {});
                          }
                        },
                        child: InteractiveViewer(
                          child: Image.network(
                            'https://images.igdb.com/igdb/image/upload/t_1080p/'
                                '${widget.game.screenshots[index].imageId}.jpg',
                            fit: BoxFit.contain
                          ),
                        )
                      );
                    }
                  )
                ),
            ]
          )
        ),
      ),
    );
  }

  void onIndexChanged(int index) {
    currIndex = index;
  }
}