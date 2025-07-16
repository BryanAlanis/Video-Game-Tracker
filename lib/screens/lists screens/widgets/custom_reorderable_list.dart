import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_game_tracker/widgets/search_list_item.dart';

import '../../../bloc/list_screen_blocs/edit_list_bloc/edit_list_bloc.dart';
import '../../../bloc/list_screen_blocs/edit_list_bloc/edit_list_events.dart';
import 'package:games_api/games_api.dart';

class CustomReorderableList extends StatefulWidget {
  final List<GameModel> gamesInList;
  final EditListBloc bloc;

  const CustomReorderableList({
    super.key,
    required this.gamesInList,
    required this.bloc
  });

  @override
  State<CustomReorderableList> createState() => _CustomReorderableListState();
}

class _CustomReorderableListState extends State<CustomReorderableList> {

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      dragStartBehavior: DragStartBehavior.down,
      buildDefaultDragHandles: false,
      itemCount: widget.gamesInList.length,
      itemBuilder: (context, index) => ReorderableDragStartListener(
        /// icon should only be draggable if trailing icon is pressed
        enabled: false,
        key: Key('$index'),
        index: index,
        child: InkWell(
          onLongPress: () async {
            return showModalBottomSheet(
              context: context,
              backgroundColor: Theme.of(context).colorScheme.surface,
              builder: (context) {
                return SizedBox(
                  height: 135,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(widget.gamesInList[index].name,),
                        subtitle: Text('${widget.gamesInList[index].firstReleaseDate.year}'),
                      ),
                      ListTile(
                        title: const Text('Remove game from list'),
                        leading: const Icon(Icons.delete),
                        onTap: (){
                          widget.bloc.add(
                              RemoveGameEvent(widget.gamesInList[index].id));

                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                );
              },
            );
          },
          child: SearchListItem(
            game: widget.gamesInList[index],
            showDragIcon: true,
            ranked: widget.bloc.state.isRanked,
            index: index,
          ),
        ),
      ),
      onReorderStart: (index) => HapticFeedback.lightImpact(),
      onReorder: (int oldIndex, int newIndex) {
        /// reorder the list and rebuild the widget
        setState(() {
          if(oldIndex < newIndex) {
            newIndex -= 1;
          }

          /// Update this widget's list
          final GameModel game = widget.gamesInList.removeAt(oldIndex);
          widget.gamesInList.insert(newIndex, game);

          /// update the bloc, so these rank changes persist
          widget.bloc.state.games.removeAt(oldIndex);
          widget.bloc.state.games.insert(newIndex, game.id);
        });
      },
      /// extra space so items can't get stuck (un-draggable) at the bottom of the screen
      footer: const SizedBox(height: 135),
    );
  }
}