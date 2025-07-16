import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_game_tracker/util/styles.dart';
import '../../../bloc/list_screen_blocs/edit_list_bloc/edit_list_bloc.dart';
import '../../../bloc/list_screen_blocs/edit_list_bloc/edit_list_states.dart';
import '../../../bloc/app_wide_blocs/games_bloc/games_bloc.dart';
import '../../../widgets/view_games_grid.dart';
import 'numbered_games_grid.dart';
import '../../../screens/lists screens/add_games_to_list_screen.dart';


class PreviewGamesGrid extends StatelessWidget {
  const PreviewGamesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 490,
      width: double.infinity,
      child: Stack(
        children: [
          /// Only show the first 9 games.
          /// The grid doesn't need to populate more games than that.
          BlocBuilder<EditListBloc, EditListState>(
            bloc: context.read<EditListBloc>(),
            buildWhen: (previous, current) {
              /// only rebuild when the games or isRanked have changed
              return (previous.games != current.games)
                  || (previous.isRanked != current.isRanked);
            },
            builder: (context, state) {
              int gameListLength = context.read<EditListBloc>().state.games.length;
              if (state.isRanked) {
                return NumberedGamesGrid(
                  games: context.read<GamesBloc>().getGamesFromID(state.games),
                  maxItems: gameListLength > 9 ? 9 : gameListLength,
                );
              }

              return ViewGamesGrid(
                games: context.read<GamesBloc>().getGamesFromID(state.games),
                maxItems: gameListLength > 9 ? 9 : gameListLength,
              );
            }
          ),
          /// Allows grid to be tapped to add more games
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (context2) => BlocProvider.value(
                  value: context.read<EditListBloc>(),
                  child: AddGamesToListScreen(
                    allGames: context.read<GamesBloc>().state.games,
                  ),
                )
            )
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(getBorderRadius(factor: 2)),
                color: Colors.black38,
              ),
              child: Center(
                child: Text(
                  'Tap to add games',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
          ),
        ]
      )
    );
  }
}