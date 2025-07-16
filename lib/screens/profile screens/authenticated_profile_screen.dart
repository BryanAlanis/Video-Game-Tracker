import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_game_tracker/bloc/profile_screen_blocs/authenticated_profile_cubit/authenticated_profile_cubit.dart';
import 'package:video_game_tracker/bloc/profile_screen_blocs/authenticated_profile_cubit/authenticated_profile_state.dart';
import 'package:video_game_tracker/screens/profile%20screens/edit_profile_screen.dart';
import 'package:video_game_tracker/screens/profile%20screens/profile_settings_screen.dart';
import 'package:video_game_tracker/screens/browse%20screens/view_games_screen.dart';
import 'package:video_game_tracker/util/styles.dart';
import 'package:video_game_tracker/widgets/make_image.dart';
import '../../bloc/app_wide_blocs/app_auth_bloc/app_auth_bloc.dart';
import '../../bloc/app_wide_blocs/app_auth_bloc/app_auth_state.dart';
import 'package:games_api/games_api.dart';
import '../../widgets/profile_picture.dart';

///
/// Authenticated Profile Screen
///
/// Shows a user's profile including their name, profile picture,
/// and the games the have liked, played, or marked as play later.
/// It also provides access to a setting's page where the user can sign out,
/// deleter their account, or make other changes to their account
///
/// Only shows if the user has been logged in through FireBase Auth
///
class AuthenticatedProfileScreen extends StatefulWidget {
  const AuthenticatedProfileScreen({super.key,});

  @override
  State<AuthenticatedProfileScreen> createState() => _AuthenticatedProfileScreenState();
}

class _AuthenticatedProfileScreenState extends State<AuthenticatedProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: Theme.of(context).textTheme.displaySmall,),
        actions: [
          /// Profile Settings
          IconButton(
            onPressed: () async {
              Navigator.push(context, MaterialPageRoute(
                builder: (routeContext) =>
                BlocProvider<AppAuthBloc>.value(
                  value: context.read<AppAuthBloc>(),
                  child: const ProfileSettingsScreen()
                )
              ));
            },
            icon: const Icon(Icons.settings)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: getEdgePadding()),
          child: Column(
            children: [
              const SizedBox(height: 20,),
              /*** Profile picture and name ***/
              Center(
                child: Column(
                  children: [
                    BlocBuilder<AppAuthBloc, AppAuthState>(
                      buildWhen: (previous, current) =>
                        previous.currentUser.photo != current.currentUser.photo,
                      builder: (context, state) {
                        return ProfilePicture(
                          pictureURL: context.read<AppAuthBloc>()
                              .state.currentUser.photo ?? '',
                        );
                      }
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: BlocBuilder<AppAuthBloc, AppAuthState>(
                        buildWhen: (previous, current) =>
                          previous.currentUser.name != current.currentUser.name,
                        builder: (context, state) =>  Text(
                          state.currentUser.name ?? 'Unknown User',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15,),
              /// Edit Profile Button
              OutlinedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                        value: context.read<AppAuthBloc>(),
                        child: const EditProfileScreen()
                    ),
                  ));
                },
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(color: Colors.white),
                )
              ),
              const SizedBox(height: 30),
              /*** Game list previews ***/
              BlocBuilder<AuthenticatedProfileCubit, AuthenticatedProfileState>(
                builder: (context, state) {
                  final bloc = context.read<AuthenticatedProfileCubit>();

                  /// Show lists
                  if (state.stateStatus == StateStatus.loaded) {
                    return Column(
                      children: [
                        HorizontalImageList(
                          games: bloc.getLikes(),
                          title: 'Liked Games'
                        ),
                        HorizontalImageList(
                          games: bloc.getPlayed(),
                          title: 'Played Games'
                        ),
                        HorizontalImageList(
                            games: bloc.getPlayLater(),
                            title: 'Play Later'
                        ),
                        HorizontalImageList(
                            games: bloc.getRatings(),
                            title: 'Rated'
                        )
                      ],
                    );
                  }
                  /// Error
                  else if (state.stateStatus == StateStatus.error) {
                    return Center(
                      child: Column(
                        children: [
                          const Icon(Icons.error, color: Colors.red,),
                          Text(
                            state.errorMessage,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge
                          ),
                        ],
                      ),
                    );
                  }
                  /// Loading
                  return const Center(child: CircularProgressIndicator());
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}


///
/// Horizontal List
///
/// Returns a title and a horizontal list view that shows a preview
/// of some of the games in the given category.
///
class HorizontalImageList extends StatelessWidget {
  final String title;
  final List<GameModel> games;

  const HorizontalImageList({super.key, required this.games, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getEdgePadding(), bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title and 'See All' button
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => ViewGamesScreen(
                    games: games, title: title)));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineSmall,),
                if (games.isNotEmpty) ... [
                  Padding(
                    padding: EdgeInsets.only(right: getEdgePadding()),
                    child: Text(
                      'See all',
                      style: Theme.of(context).textTheme.titleMedium?.merge(
                        TextStyle(color: Theme.of(context).colorScheme.primary)),
                    ),
                  )
                ]
              ],
            ),
          ),
          /// Game Covers
          if (games.isNotEmpty) ... [
            SizedBox(
              height: 175,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(top: 15),
                itemCount: games.length < 5 ? games.length : 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: MakeImage(game: games[index])
                  );
                },
              ),
            ),
          ]
          /// Show when there are no games in the list
          else ... [
            SizedBox(
              height: 50,
              child: Center(
                child: Text (
                  'No $title Games',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            )
          ]
        ],
      ),
    );
  }
}