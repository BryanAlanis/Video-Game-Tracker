import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_game_tracker/bloc/list_screen_blocs/edit_list_bloc/edit_list_states.dart';
import 'package:games_api/games_api.dart';
import 'package:video_game_tracker/screens/lists%20screens/search_delegate.dart';
import 'package:video_game_tracker/screens/lists%20screens/widgets/custom_reorderable_list.dart';
import '../../bloc/app_wide_blocs/games_bloc/games_bloc.dart';
import '../../bloc/list_screen_blocs/edit_list_bloc/edit_list_bloc.dart';

///
/// EditListScreen
///
/// Displays all games currently in the list in order (if ranked).
/// Allows the user to add or remove games to the list.
/// The user can also reorder the list
///
class AddGamesToListScreen extends StatelessWidget {
  final List<GameModel> allGames;

  const AddGamesToListScreen({
    super.key,
    required this.allGames,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Games'),
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<EditListBloc, EditListState>(
        bloc: BlocProvider.of<EditListBloc>(context),
        buildWhen: (previous, current) {
          /// only rebuild when a game is added and not when reordering the list.
          return previous.games != current.games;
        },
        builder: (context, state) {
          return CustomReorderableList(
            gamesInList: context.read<GamesBloc>().getGamesFromID(state.games),
            bloc: context.read<EditListBloc>(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          showSearch(
            context: context,
            delegate: CustomSearchDelegate(
              games: allGames,
              bloc: context.read<EditListBloc>()
            )
          );
        },
        child: const Icon(Icons.add),
      )
    );
  }
}