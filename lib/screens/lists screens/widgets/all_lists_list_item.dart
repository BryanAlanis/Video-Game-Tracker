import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_list_api/user_list_api.dart';
import 'package:video_game_tracker/bloc/list_screen_blocs/all_lists_bloc/all_lists_bloc.dart';
import 'package:video_game_tracker/bloc/list_screen_blocs/all_lists_bloc/all_lists_events.dart';
import 'package:video_game_tracker/bloc/app_wide_blocs/games_bloc/games_bloc.dart';
import 'package:video_game_tracker/screens/lists%20screens/edit_list_screen.dart';
import 'package:video_game_tracker/screens/lists%20screens/view_list_screen.dart';
import 'package:games_api/games_api.dart';
import 'package:video_game_tracker/util/styles.dart';
import '../../../widgets/make_image.dart';

class ListItem extends StatelessWidget {
  final UserList userList;
  final List<GameModel> gamesInList;

  const ListItem({super.key, required this.userList, required this.gamesInList});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double edgePadding = getEdgePadding();

    return Card(
      color: Colors.grey.shade900,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0), /// match Card border radius
        onTap: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context2) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: context.read<AllListsBloc>()),
                  BlocProvider.value(value: context.read<GamesBloc>()),
                ],
                child: ViewListScreen(
                  games: gamesInList, userList: userList,
                ),
              )
            )
          );
        },
        onLongPress: () async {
          /// show edit and delete options for this list
          return _showBottomSheet(context);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: edgePadding,
                left: edgePadding,
                right: edgePadding
              ),
              child: SizedBox(
                height: 130,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: List.generate(
                    gamesInList.length < 5 ? gamesInList.length : 5,
                    (index) {
                      return Padding(
                        /// Make image stacking effect with this amount of padding
                        /// between images.
                        padding: EdgeInsets.only(
                          left: size.width * 0.154 * index  //63.0
                        ),
                        child: MakeImage(
                          game: gamesInList[index],
                          onTap: null,
                        ),
                      );
                    }
                  )
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
              child: Text(
                userList.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
              child: Text(
                userList.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.merge(
                  const TextStyle(color: Colors.grey),
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:10, bottom: 15, left: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${userList.games.length} games',
                  style: Theme.of(context).textTheme.bodySmall?.merge(
                    const TextStyle(color: Colors.grey)
                  ),
                ),
              ),
            )
          ],
        )
      ),
    );
  }

  ///
  /// Show additional options (delete and edit) when the user long presses
  /// on the list item.
  ///
  Future<dynamic> _showBottomSheet (BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (context2) {
        return SizedBox(
          height: 210,
          child: Column(
            children: [
              ListTile(
                title: Text(userList.title,),
                subtitle: Text('${userList.games.length} games'),
              ),
              const Divider(),
              ListTile(
                title: const Text('Delete List'),
                leading: const Icon(Icons.delete),
                onTap: (){
                  context.read<AllListsBloc>().add(
                      DeleteListEvent(listID: userList.id));

                  /// Dismiss bottom sheet if list has been deleted
                  Navigator.pop(context);
                },
              ),
              /// Edit the existing list
              ListTile(
                title: const Text('Edit List'),
                leading: const Icon(Icons.edit),
                onTap: () async {
                  bool success = await Navigator.push(context, MaterialPageRoute(
                      builder: (context2) => BlocProvider.value(
                        value: context.read<GamesBloc>(),
                        child: const EditListScreen()
                      )
                    )
                  );

                  /// Dismiss bottom sheet if list has been edited
                  if(context.mounted) {
                    if (success) {
                      Navigator.pop(context);
                    }
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }
}