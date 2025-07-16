import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:games_api/games_api.dart';
import 'package:user_interactions_api/user_interactions_api.dart';
import '../../../bloc/app_wide_blocs/app_auth_bloc/app_auth_bloc.dart';
import '../../../bloc/app_wide_blocs/carousel_view_UI_bloc/carousel_view_bloc.dart';
import '../../../bloc/app_wide_blocs/carousel_view_UI_bloc/carousel_view_events.dart';
import 'bottom_sheet_builder.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final GameModel game;
  const CustomFloatingActionButton({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<UserInteractionsRepository>(
      create: (context) => UserInteractionsRepository(),
      child: BlocProvider<CarouselViewBloc>(
        create: (context) => CarouselViewBloc(
          repository: RepositoryProvider.of<UserInteractionsRepository>(context),
          isAuthenticated: context.read<AppAuthBloc>().state.currentUser.isNotEmpty
        )..add(LoadInteractionsEvent(game.id, 0)),
        child: BlocProvider.value(
         value: context.read<AppAuthBloc>(),
          child: FloatingActionButtonHelper(game: game,)
        ),
      )
    );
  }
}

class FloatingActionButtonHelper extends StatelessWidget {
  final GameModel game;
  const FloatingActionButtonHelper({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: const CircleBorder(),
      onPressed: () async {
        await showModalBottomSheet(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          context: context,
          builder: (context2) {
            return MultiBlocProvider(
              providers: [
                BlocProvider.value(value: context.read<AppAuthBloc>()),
                BlocProvider.value(value: context.read<CarouselViewBloc>())
              ],
              child: BottomSheetBuilder(game: game)
            );
          },
        );
      },
      child: const Icon(Icons.add),
    );
  }
}