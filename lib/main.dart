import 'package:authentication_repository/authentication_repository.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_game_tracker/bloc/app_wide_blocs/app_auth_bloc/app_auth_bloc.dart';
import 'package:video_game_tracker/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:video_game_tracker/screens/loading_games_screen.dart';
import 'package:video_game_tracker/util/styles.dart';
import 'bloc/app_wide_blocs/games_bloc/games_bloc.dart';
import 'bloc/app_wide_blocs/games_bloc/games_events.dart';
import 'bloc/app_wide_blocs/games_bloc/games_states.dart';
import 'package:games_api/games_api.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  /// Lock screen orientation to portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  /// Set system nav bar and status bar to app background color
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: getBackgroundColor(),
      statusBarColor: getBackgroundColor(),
    )
  );
  
  /// Make sure that firebase is initialized to use Authentication
  /// and Firestore services.
  await Firebase.initializeApp();

  //runApp(DevicePreview(builder: (context) => const MyApp()));
  runApp(const MyApp());
}

///
/// MyApp
///
/// Initialize all app-wide repositories and blocs,
/// [GamesBloc] and [AppAuthBloc] are used throughout the whole app
/// and are initialized here.
///
/// [GamesBloc] requests a list of games from the IGDB database and
/// and displays the home screen if they were loaded successfully.
///
/// [AppAuthBloc] keeps track of the authentication status of the app.
/// Authentication is only important for certain features such as
/// viewing the user profile, creating lists, and logging played, want to play,
/// liked, rated and games.
///
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<GamesRepository>(
          create: (context) => GamesRepository(),
        ),
        RepositoryProvider<AuthenticationRepository>(
          create: (context) => AuthenticationRepository(),
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<GamesBloc>(
            create: (context) => GamesBloc(
              RepositoryProvider.of(context)
            )..add(LoadGamesEvent()),
          ),
          BlocProvider<AppAuthBloc>(
            create: (context) => AppAuthBloc(
              RepositoryProvider.of<AuthenticationRepository>(context)
            ),
          )
        ],
        child: MaterialApp(
          title: 'Video Game Tracker',
          debugShowCheckedModeBanner: false,
          theme: getAppTheme(),
          builder: DevicePreview.appBuilder,
          locale: DevicePreview.locale(context),
          home: BlocBuilder<GamesBloc, GamesState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const LoadingAllGamesScreen();
              }
              return MyHomePage(games: state.games);
            },
          ),
        ),
      )
    );
  }
}