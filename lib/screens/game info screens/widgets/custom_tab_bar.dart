import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:games_api/games_api.dart';
import 'package:video_game_tracker/bloc/game_info_blocs/tab_bar_cubit/tab_bar_cubit.dart';
import 'package:video_game_tracker/util/styles.dart';

import '../../../bloc/game_info_blocs/tab_bar_cubit/tab_bar_state.dart';

///
/// GameInfoTabBar
///
/// Creates a tab bar that changes in height depending on the length
/// of its contents. A [TabBarCubit] is used to keep track of the current [Tab]
/// and rebuilds the widget when a different [Tab] is selected.
///
/// Displays information (modes, details, involved companies) about
/// the given [game].
///
class GameInfoTabBar extends StatelessWidget {
  final GameModel game;
  const GameInfoTabBar({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TabBarCubit()..initializeLists(game),
      child: const GameInfoTabBarView(),
    );
  }
}

///
/// GameInfoTabBarView
///
/// Creates a [TabBar] with 3 tabs: [Modes], [Details], and [Involved Companies]
///
class GameInfoTabBarView extends StatelessWidget {
  const GameInfoTabBarView({super.key,});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DefaultTabController(
          length: 3,
          child: TabBar(
            isScrollable: true,
            dividerColor: Colors.white30,
            labelStyle: Theme.of(context).textTheme.titleMedium,
            tabAlignment: TabAlignment.start,
            onTap: (index) => context.read<TabBarCubit>().changeIndex(index),
            tabs: const [
              Tab(text: 'Modes',), /// modes, genres, themes, player perspectives
              Tab(text: 'Details',), /// alternative names, language supports, releases
              Tab(text: 'Involved Companies',), /// engines, companies, platforms
            ]
          ),
        ),
        BlocProvider.value(
          value: context.read<TabBarCubit>(),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: DynamicTabBarView()
          )
        )
      ],
    );
  }
}

///
/// DynamicTabBarView
///
/// Shows a [Game]'s information depending on what [Tab] is currently
/// being shown according to the [TabBarCubit] which keeps track
/// of the current tab
///
class DynamicTabBarView extends StatelessWidget {
  const DynamicTabBarView({super.key,});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabBarCubit, TabBarState>(
      builder: (context, state) {
        /// Modes
        if (state.index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              state.modes.isNotEmpty ?
                TextList(title: 'Modes', text: state.modes)
                  : const SizedBox(),
              state.genres.isNotEmpty ?
                TextList(title: 'Genres', text: state.genres)
                  : const SizedBox(),
              state.themes.isNotEmpty ?
                TextList(title: 'Themes', text: state.themes)
                  : const SizedBox(),
              state.playerPerspectives.isNotEmpty ?
                TextList(title: 'Player Perspectives', text: state.playerPerspectives)
                  : const SizedBox()
            ],
          );
        }
        /// Details
        else if (state.index == 1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              state.alternativeNames.isNotEmpty ?
                TextList(title: 'Alternative Names', text: state.alternativeNames)
                  : const SizedBox(),
              state.languageSupports.isNotEmpty ?
                TextList(title: 'Supported Languages', text: state.languageSupports)
                  : const SizedBox(),
              state.releaseDates.isNotEmpty ?
                TextList(title: 'Releases', text: state.releaseDates)
                  : const SizedBox()
            ],
          );
        }
        /// Involved Companies
        else if (state.index == 2) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              state.engines.isNotEmpty ?
                TextList(title: 'Engines', text: state.engines)
                  : const SizedBox(),
              state.companies.isNotEmpty ?
                TextList(title: 'Companies', text: state.companies)
                  : const SizedBox(),
              state.platforms.isNotEmpty ?
                TextList(title: 'Platforms', text: state.platforms)
                  : const SizedBox()
            ],
          );
        }

        return const Center(child: Text('Error'),);
      },
    );
  }
}

///
/// TextList
///
/// Takes a [List] of [Strings] and converts it to
/// a [Column] of [Text] widgets.
///
class TextList extends StatelessWidget {
  final String title;
  final List<String> text;

  const TextList({super.key, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: getEdgePadding(),
        right: getEdgePadding(),
        left: getEdgePadding()
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.apply(
                fontStyle: FontStyle.italic)
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: text.map(
              (text) => Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodyLarge
                    ?.apply(fontWeightDelta: -1,)
                )
              ),
            ).toList(),
          )
        ],
      ),
    );
  }
}