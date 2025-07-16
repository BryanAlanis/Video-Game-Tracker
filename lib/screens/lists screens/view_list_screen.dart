import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_list_api/user_list_api.dart';
import 'package:video_game_tracker/screens/lists%20screens/widgets/numbered_games_grid.dart';
import 'package:video_game_tracker/screens/game%20info%20screens/widgets/appbar_with_opacity.dart';
import 'package:video_game_tracker/screens/game%20info%20screens/widgets/top_image.dart';
import 'package:video_game_tracker/widgets/view_games_grid.dart';
import '../../bloc/list_screen_blocs/all_lists_bloc/all_lists_bloc.dart';
import '../../bloc/list_screen_blocs/all_lists_bloc/all_lists_events.dart';
import '../../bloc/app_wide_blocs/games_bloc/games_bloc.dart';
import 'package:games_api/games_api.dart';
import '../../bloc/list_screen_blocs/edit_list_bloc/edit_list_bloc.dart';
import '../../bloc/list_screen_blocs/edit_list_bloc/edit_list_states.dart';
import '../../util/styles.dart';
import '../../widgets/expanded_text.dart';
import '../browse screens/carousel_browse_screen.dart';
import 'edit_list_screen.dart';

///
/// Display an already existing list.
/// Can show a numbered (ranked) list if the user decided to rank each game
///
class ViewListScreen extends StatelessWidget {
  final List<GameModel> games;
  final UserList userList;
  
  const ViewListScreen({super.key, required this.games, required this.userList});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<UserListRepository>(
      create: (context) => UserListRepository(),
      child: BlocProvider<EditListBloc>(
          create: (context) => EditListBloc(
              repository: RepositoryProvider.of<UserListRepository>(context),
              initialUserList: userList
          ),
          /// Pop to previous screen when changes have been successfully submitted
          child: ViewListScreenView(games: games, initialListId: userList.id,)
      ),
    );
  }
}

class ViewListScreenView extends StatefulWidget {
  final List<GameModel> games;
  final String initialListId;

  const ViewListScreenView({
    super.key,
    required this.games,
    required this.initialListId,
  });

  @override
  State<ViewListScreenView> createState() => _ViewListScreenViewState();
}

class _ViewListScreenViewState extends State<ViewListScreenView> {
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double edgePadding = getEdgePadding();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: BlocSelector<EditListBloc, EditListState, String>(
          selector: (state) => state.title,
          builder: (context, title) {
            return AppBarWithOpacity(
              scrollController: scrollController,
              title: title,
              transitionOffset: 150,
              actions: [
                /*** Carousel Browse Button ***/
                IconButton(
                  onPressed:
                  /// Disable button if there are no games
                  widget.games.isEmpty ? null
                      : (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => CarouselBrowseScreen(games: widget.games)
                    ));
                  },
                  icon: const Icon(Icons.view_carousel),
                ),
                /*** Menu Button ***/
                PopupMenuButton(
                  color: Theme.of(context).colorScheme.surface,
                  itemBuilder: (context) => [
                    /*** Edit List ***/
                    PopupMenuItem(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context2) {
                              return MultiBlocProvider(
                                providers: [
                                  BlocProvider.value(
                                    value: context.read<GamesBloc>(),
                                  ),
                                  BlocProvider.value(
                                    value: context.read<EditListBloc>()
                                  )
                                ],
                                child: const EditListScreen()
                              );
                            }
                        ));
                      },
                      child: ListTile(
                        iconColor: Theme.of(context).colorScheme.onSurface,
                        textColor: Theme.of(context).colorScheme.onSurface,
                        leading: const Icon(Icons.edit),
                        title: const Text('Edit List'),
                      )
                    ),
                    /*** Delete List ***/
                    PopupMenuItem(
                      onTap: () {
                        context.read<AllListsBloc>().add(
                            DeleteListEvent(
                              listID: widget.initialListId)
                        );

                        /// Dismiss bottom sheet or leave [view_list_screen]
                        Navigator.pop(context);
                      },
                      child: ListTile(
                        iconColor: Theme.of(context).colorScheme.onSurface,
                        textColor: Theme.of(context).colorScheme.onSurface,
                        leading: const Icon(Icons.delete),
                        title: const Text('Delete List'),
                      )
                    ),
                  ],
                )
              ],
            );
          }
        ),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                /*** Top Image ***/
                TopImage(
                  imageID:  widget.games[Random().nextInt(widget.games.length)]
                      .screenshots[0].imageId,
                  height: 230,
                  width: double.infinity
                ),
                /*** List Title ***/
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: edgePadding),
                    child: BlocSelector<EditListBloc, EditListState, String>(
                      selector: (state) => state.title,
                      builder: (context, title) {
                        return Text(
                          title,
                          style: Theme.of(context).textTheme.headlineMedium,
                        );
                      },
                    ),
                  ),
                ),
              ]
            ),
            /*** Description ***/
            Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  left: edgePadding,
                  right: edgePadding
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: BlocSelector<EditListBloc, EditListState, String>(
                  selector: (state) => state.description,
                  builder: (context, description) {
                    return ExpandedText(
                      text: description,
                    );
                  }
                ),
              ),
            ),
            /*** Games Grid ***/
            BlocBuilder<EditListBloc, EditListState>(
              buildWhen: (previous, current) => previous.games != current.games
                  || previous.isRanked != current.isRanked,
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: context.read<EditListBloc>().state.isRanked ?
                    NumberedGamesGrid(
                      games: context.read<GamesBloc>().getGamesFromID(state.games),
                      /// allows the whole screen to be scrolled instead of just the grid
                      scrollPhysics: const NeverScrollableScrollPhysics(),
                    ) :
                    ViewGamesGrid(
                      games: context.read<GamesBloc>().getGamesFromID(state.games),
                      /// allows the whole screen to be scrolled instead of just the grid
                      scrollPhysics: const NeverScrollableScrollPhysics(),
                    ),
                );
              }
            )
          ],
        ),
      ),
    );
  }
}