import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_game_tracker/bloc/app_wide_blocs/app_auth_bloc/app_auth_bloc.dart';
import 'package:games_api/games_api.dart';
import 'package:video_game_tracker/screens/game%20info%20screens/phone_view.dart';
import 'package:video_game_tracker/screens/game%20info%20screens/tablet_view.dart';
import 'package:video_game_tracker/util/styles.dart';
import 'package:video_game_tracker/screens/game%20info%20screens/widgets/custom_floating_action_button.dart';
import 'package:video_game_tracker/screens/game%20info%20screens/widgets/custom_tab_bar.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:video_game_tracker/screens/game%20info%20screens/view_image_screen.dart';
import 'package:video_game_tracker/widgets/expanded_text.dart';
import 'package:video_game_tracker/screens/game%20info%20screens/widgets/appbar_with_opacity.dart';

///
/// Game Info
///
/// Initialize the authentication repository and auth bloc
/// 
class GameInfo extends StatelessWidget {
  final GameModel game;
  const GameInfo({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthenticationRepository>(
      create: (context) => AuthenticationRepository(),
      child: BlocProvider<AppAuthBloc>(
        create: (context) => AppAuthBloc(
          context.read<AuthenticationRepository>()
        ),
        child: GameInfoView(game: game,),
      ),
    );
  }
}


///
/// Game Info View
///
/// This screen shows all game information for a single game.
/// It will show the year it was released, its genres, game modes, themes,
/// screenshots, and a video. It will also allow the user to mark the current
/// game as liked, played, play later, or rate it.
///
class GameInfoView extends StatefulWidget {
  final GameModel game;

  const GameInfoView({super.key, required this.game});

  @override
  State<GameInfoView> createState() => _GameInfoViewState();
}

class _GameInfoViewState extends State<GameInfoView> with SingleTickerProviderStateMixin{
  final SwiperController _swiperController = SwiperController();
  final ScrollController _scrollController = ScrollController();

  /// Current index of the screenshot carousel
  int currIndex = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBarWithOpacity(
          scrollController: _scrollController,
          title: widget.game.name,
          transitionOffset: 490,  /// show opaque app bar when offset reaches 490
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
           return  ListView(
            controller: _scrollController,
            /// Make image extend behind the app bar
            padding: const EdgeInsets.only(top: 0,),
            children: [
              /*** Top image ***/
              constraints.maxWidth > 600 ?
                  TabletView(game: widget.game, constraints: constraints,) :
                      PhoneView(game: widget.game),
              /*** Summary ***/
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getEdgePadding()),
                child: Text(
                  'Summary',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 5,
                  left: getEdgePadding(),
                  right: getEdgePadding()
                ),
                child: ExpandedText(text:widget.game.summary),
              ),
              Divider(color: getWhiteOpacityColor(),),
              /*** Tab Bar***/
              GameInfoTabBar(game: widget.game),
              Divider(color: getWhiteOpacityColor(),),
              /*** Screenshots ***/
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getEdgePadding(),
                ),
                child: Text(
                  'Screenshots',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: getEdgePadding(),
                  left: getEdgePadding(),
                  right: getEdgePadding(),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      getBorderRadius(factor: 2)
                  ),
                  child: AspectRatio(
                    aspectRatio: 16/9,
                    child: Swiper(
                      index: currIndex,
                      controller: _swiperController,
                      pagination: getPagination(),
                      onIndexChanged: onIndexChanged,
                      itemCount: widget.game.screenshots.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () => _goToFullScreenImage(context, index),
                          child: Image.network(
                            'https://images.igdb.com/igdb/image/upload/t_1080p/'
                                '${widget.game.screenshots[index].imageId}.jpg',
                            fit: BoxFit.fill
                          ),
                        );
                      }
                    )
                  ),
                )
                )
              ]
            );
          }
        ),
        floatingActionButton: BlocProvider.value(
          value: context.read<AppAuthBloc>(),
          child: CustomFloatingActionButton(game: widget.game)
        )
      ),
    );
  }

  ///
  /// Gets back the index where viewImageScreen left on and sets it
  /// on this screen so the user doesn't have to swipe to try and find
  /// the image they were last seeing while in full screen mode.
  ///
  Future<void> _goToFullScreenImage(BuildContext context, int index) async {
    /// ViewImageScreen will return the index where the user left off
    int newIndex = await Navigator.push(context, MaterialPageRoute(
        builder: (context) => ViewImageScreen(
            startIndex: index,
            game: widget.game)
    ));

    _swiperController.move(newIndex);
  }

  void onIndexChanged (int index) {
    currIndex = index;
  }
}