import 'package:flutter/material.dart';

class TopImage extends StatelessWidget {
  final String imageID;
  final double height;
  final double width;

  const TopImage({
    super.key,
    required this.imageID,
    required this.height,
    required this.width
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      foregroundDecoration: BoxDecoration(
        /// Create a fading shadow effect that gets darker towards
        /// the bottom of the image
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Theme.of(context).colorScheme.surface,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.7, 0.99]
        ),
      ),
      child: Center(
        child: SizedBox(
          height: height,
          width: width,
          child: Image.network(
            'https://images.igdb.com/igdb/image/upload/t_1080p/'
                '$imageID.jpg',
            fit: BoxFit.cover,
          ),
        ),
      )
    );
  }
}