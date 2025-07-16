import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_interactions_api/user_interactions_api.dart';
import 'package:video_game_tracker/bloc/app_wide_blocs/app_auth_bloc/app_auth_bloc.dart';
import 'package:video_game_tracker/bloc/app_wide_blocs/app_auth_bloc/app_auth_state.dart';
import 'package:video_game_tracker/bloc/profile_screen_blocs/authenticated_profile_cubit/authenticated_profile_cubit.dart';
import 'package:video_game_tracker/screens/profile%20screens/log_in_screen.dart';
import 'package:video_game_tracker/screens/profile%20screens/authenticated_profile_screen.dart';
import 'package:games_api/games_api.dart';

///
/// ProfileScreen
///
/// This widget determines whether the user is logged in or not.
/// If they are logged in, show their profile. Otherwise, show the sign in page.
///
/// State is managed with auth bloc which handles communication with FireBase Auth
///
class ProfileScreen extends StatelessWidget {
  final List<GameModel> games;
  const ProfileScreen({super.key, required this.games});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppAuthBloc, AppAuthState>(
      builder: (context, state) {
        if (state.appStatus == Status.authenticated) {
          /// Start an instance of the AuthenticatedProfileCubit to show
          /// user likes, played games, etc.
          /// Also provide the AppAuthBloc to be used in ProfileSettingsScreen
          return BlocProvider.value(
            value: context.read<AppAuthBloc>(),
            child: RepositoryProvider<UserInteractionsRepository>(
              create: (context) => UserInteractionsRepository(),
              child: BlocProvider<AuthenticatedProfileCubit>(
                create: (context) => AuthenticatedProfileCubit(
                  repository: RepositoryProvider.of<UserInteractionsRepository>(context),
                  games: games
                )..getInteractions(),
                child: const AuthenticatedProfileScreen()
              ),
            )
          );
        }

        /// User is not logged in yet
        return BlocProvider<AppAuthBloc>.value(
          value: context.read<AppAuthBloc>(),
          child: const LogInScreen(shouldPopContext: false,)
        );
      },
    );
  }
}