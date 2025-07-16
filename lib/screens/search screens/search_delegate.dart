import 'package:flutter/material.dart';
import 'package:video_game_tracker/screens/game%20info%20screens/game_info.dart';
import 'package:games_api/games_api.dart';

import '../../widgets/search_list_item.dart';

///
/// CustomSearchDelegate
///
/// Defines what a search screen would look like for searching games.
///
class CustomSearchDelegate extends SearchDelegate {
  final List<GameModel> games;

  CustomSearchDelegate({required this.games,});

  /// Clear text in text field
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: (){
            query = '';
          },
          icon: const Icon(Icons.clear_rounded)
      )
    ];
  }

  /// Back button
  @override
  Widget? buildLeading(BuildContext context) {
    return BackButton(
      onPressed: () => Navigator.pop(context),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildResultList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResultList();
  }

  /// Creates a list
  /// Used in both buildResults() and buildSuggestions()
  Widget buildResultList() {
    List<GameModel> filteredList = [];

    /// Find games that match the query
    for(var game in games) {
      if(game.name.toLowerCase().contains(query.toLowerCase())) {
        filteredList.add(game);
      }
    }

    if (filteredList.isEmpty) {
      return const SizedBox();
    }

    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameInfo(game: filteredList[index])
                )
              );
            },
            child: SearchListItem(game: filteredList[index])
        );
      },
    );
  }
}