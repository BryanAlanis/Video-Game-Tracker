import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_interactions_api/user_interactions_api.dart';
import 'package:video_game_tracker/bloc/app_wide_blocs/app_auth_bloc/app_auth_bloc.dart';
import 'package:games_api/games_api.dart';
import 'package:video_game_tracker/util/styles.dart';
import 'package:video_game_tracker/widgets/make_image.dart';
import '../../bloc/app_wide_blocs/carousel_view_UI_bloc/carousel_view_bloc.dart';
import '../../bloc/app_wide_blocs/carousel_view_UI_bloc/carousel_view_events.dart';
import '../../bloc/app_wide_blocs/carousel_view_UI_bloc/carousel_view_state.dart';
import '../../widgets/user_interaction_bar.dart';

///
/// CarouselBrowseScreen
///
/// Initialize the repository, bloc and load the first game.
///
class CarouselBrowseScreen extends StatelessWidget {
  final List<GameModel> games;

  const CarouselBrowseScreen({super.key, required this.games});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<UserInteractionsRepository>(
      create: (context) => UserInteractionsRepository(),
      child: BlocProvider<CarouselViewBloc>(
        create: (context) => CarouselViewBloc(
          repository: RepositoryProvider.of<UserInteractionsRepository>(context),
          isAuthenticated: context.read<AppAuthBloc>().state.currentUser.isNotEmpty,
        )..add(LoadInteractionsEvent(games[0].id, 0)),
        child: CarouselBrowseView(games: games)
      ),
    );
  }
}

///
/// CarouselBrowseView
///
/// Show a game's title, cover image, and user interactions.
///
/// The cover image is shown on a carousel widget. When the user scrolls,
/// the title, image, and user interactions are changed to match the currently
/// shown game.
///
class CarouselBrowseView extends StatelessWidget {
  final List<GameModel> games;

  const CarouselBrowseView({super.key, required this.games});

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      top: false,
      child: Scaffold(
        /// Title and release year
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(getAppBarHeight()),
          /// Rebuild appbar when index changes
          child: BlocProvider.value(
            value: BlocProvider.of<CarouselViewBloc>(context),
            child: TitleAppBar(games: games),
          )
        ),
        body: Stack(
          ///alignment: Alignment.center,
          children: [
            /*** Image Carousel ***/
            Align(
              alignment: const Alignment(0, -0.4),
              child: SizedBox(
                width: 320,
                height: 480,
                child: Column(
                  children: [
                    /// Flexible prevents overflow
                    Flexible(
                      child: Swiper(
                        scale: 0.75,
                        fade: 0,
                        itemCount: games.length,
                        onIndexChanged: (index) {
                          final bloc = context.read<CarouselViewBloc>();
                      
                          /// keep showing the rating bar when the user swipes to a new game
                          if (bloc.state.status == StateStatus.showRatingBar) {
                            bloc.add(ShowRatingBarEvent(games[index].id));
                          }
                          else {
                            bloc.add(ShowInteractionsBarEvent(
                              games[index].id, index
                            ));
                          }
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return MakeImage(game: games[index]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            /*** Buttons ***/
            Align(
              alignment: const Alignment(0, 0.95),
              child: SizedBox(
                width: double.infinity,
                height: 100,
                child: Column(
                  children: [
                    /// Flexible prevents overflow and can only be used in a col/row
                    Flexible(
                      child: BlocProvider.value(
                        value: context.read<CarouselViewBloc>(),
                        child: const UserInteractionBar()
                      )
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///
/// TitleAppBar
///
/// Appbar displays the game title and release year.
/// Signals the user database bloc to update the FireStore database on close.
/// Only appears in this screen.
///
class TitleAppBar extends StatelessWidget {
  final List<GameModel> games;
  const TitleAppBar({super.key, required this.games});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      titleSpacing: 30,
      title: BlocBuilder<CarouselViewBloc, CarouselViewState>(
        bloc: context.read<CarouselViewBloc>(),
          buildWhen: (previous, current) => previous.index != current.index,
        builder: (context, state) {
          return Column(
            children: [
              Text(
                games[state.index].name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                '${games[state.index].firstReleaseDate.year}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          );
        }
      ),
      actions: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
          color: Theme.of(context).colorScheme.onSurface,
        )
      ],
    );
  }
}