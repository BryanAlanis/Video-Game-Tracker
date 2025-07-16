import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_game_tracker/bloc/app_wide_blocs/app_auth_bloc/app_auth_bloc.dart';
import 'package:video_game_tracker/screens/lists%20screens/all_lists_screen.dart';
import 'package:games_api/games_api.dart';
import 'browse screens/browse_all_games_screen.dart';
import 'profile screens/profile_screen.dart';
import 'search screens/search_screen.dart';

///
/// Sets up bottom nav bar with all the screens
///
class MyHomePage extends StatefulWidget {
  final List<GameModel> games;
  const MyHomePage({super.key, required this.games});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: BottomNavigationBar (
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined,),
            activeIcon: Icon(Icons.home_filled),
            label: 'Home',
            tooltip: 'Home',),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined,),
            activeIcon: Icon(Icons.search_rounded),
            label: 'Search',
            tooltip: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined,),
            activeIcon: Icon(Icons.list_alt_rounded,),
            label: 'Lists',
            tooltip: 'Lists'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined,),
            activeIcon: Icon(Icons.account_circle_rounded,),
            label: 'Profile',
            tooltip: 'Profile'),
        ],
      ),
      body: <Widget>[
        /*** Main screen: Show all games ***/
        BrowseScreen(games: widget.games),
        /*** Search screen ***/
        SearchScreen(games: widget.games),
        /*** Lists Screen: Show user's lists ***/
        BlocProvider.value(
          value: context.read<AppAuthBloc>(),
          child: const AllListsScreen()
        ),
        /*** Profile Screen ***/
        BlocProvider.value(
          value: context.read<AppAuthBloc>(),
          child: ProfileScreen(games: widget.games,)
        ),
      ][_currentIndex],
    );
  }
}