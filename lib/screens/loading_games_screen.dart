import 'package:flutter/material.dart';

///
/// Creates a screen to show when all games are being loaded
/// from the API/database. All rectangles are greyed out to
/// show the user that the games are being loaded
///

class LoadingAllGamesScreen extends StatelessWidget {
  const LoadingAllGamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('Browse', style: Theme.of(context).textTheme.displaySmall,),
        actions: const [
          Icon(Icons.view_carousel)
        ],
      ),
      body: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.7,
              crossAxisCount: 3
          ),
          itemCount: 15,
          itemBuilder: (BuildContext context, int index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: Colors.white12,
              )
            );
          }
      ),
    );
  }
}
