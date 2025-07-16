import 'package:flutter/material.dart';
import '../../bloc/list_screen_blocs/edit_list_bloc/edit_list_bloc.dart';
import '../../bloc/list_screen_blocs/edit_list_bloc/edit_list_events.dart';
import 'package:games_api/games_api.dart';
import '../../widgets/search_list_item.dart';

///
/// CustomSearchDelegate
///
/// Defines what a search screen would look like for searching games.
/// Used for adding games to a custom list.
///
class CustomSearchDelegate extends SearchDelegate {
  final List<GameModel> games;
  final EditListBloc bloc;

  CustomSearchDelegate({required this.games, required this.bloc,});

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
            onTap: () async{
              /// Only add game if it's not already in the list
              if (!bloc.state.games.contains(filteredList[index].id)) {
                bloc.add(AddGameEvent(filteredList[index].id));

                if(context.mounted) Navigator.of(context).pop();
              }
              else {
                await _showDialog(context);
              }
            },
            child: SearchListItem(game: filteredList[index])
        );
      },
    );
  }

  /// Tell the user that this game is already in the list
  Future<void> _showDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Game already in list'),
        actionsAlignment: MainAxisAlignment.center,
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }
}