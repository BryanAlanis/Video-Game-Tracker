import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_game_tracker/bloc/list_screen_blocs/edit_list_bloc/edit_list_bloc.dart';
import 'package:video_game_tracker/bloc/list_screen_blocs/edit_list_bloc/edit_list_states.dart';
import 'package:video_game_tracker/screens/lists%20screens/description_screen.dart';
import 'package:video_game_tracker/screens/lists%20screens/widgets/is_ranked_icon_button.dart';
import 'package:video_game_tracker/screens/lists%20screens/widgets/preview_games_grid.dart';
import 'package:video_game_tracker/util/styles.dart';
import '../../bloc/list_screen_blocs/edit_list_bloc/edit_list_events.dart';

///
/// A screen where the user can create a list.
///
/// A title, description, list of games, and a bool
/// to determine whether the list is numbered or not are needed to create
/// the list.
///
class EditListScreen extends StatelessWidget {
  const EditListScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<EditListBloc>(),
      /// Pop to previous screen when changes have been successfully submitted
      child: BlocListener<EditListBloc, EditListState>(
        listenWhen: (previous, current) {
          return previous.status != current.status &&
              current.status == EditListStateStatus.success;
        },
        listener: (context, state) {
          context.read<EditListBloc>().add(ResetStatusEvent());
          Navigator.pop(context, true);
        },
        child: const EditListView(),
      )
    );
  }
}

class EditListView extends StatelessWidget {
  const EditListView({super.key});

  @override
  Widget build(BuildContext context) {
    double edgePadding = getEdgePadding();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit List'),
          actions: [
            /// Save changes
            IconButton(
                onPressed: () {
                  context.read<EditListBloc>().add(SubmitChangesEvent());
                },
                icon: const Icon(Icons.check)
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                left: edgePadding,
                right: edgePadding,
                bottom: edgePadding
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*** Title ***/
                  BlocBuilder<EditListBloc, EditListState>(
                    buildWhen: (previous, current) {
                      return previous.title != current.title;
                    },
                    builder: (context, state) {
                      return TextFormField(
                        initialValue: state.title,
                        onChanged: (value) {
                          context.read<EditListBloc>().add(
                              UpdateTitleEvent(value));
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'List title',
                        ),
                      );
                    },
                  ),
                  /*** Description ***/
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context2) => BlocProvider.value(
                                value: context.read<EditListBloc>(),
                                child: const DescriptionScreen()
                            ),)
                          );
                        },
                        /// Rebuild when description is changed
                        child: BlocSelector<EditListBloc, EditListState, String>(
                            selector: (state) => state.description,
                            builder: (context, description) {
                              return Text(description);
                            }
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  /*** Ranked button ***/
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Align(
                        alignment: Alignment.center,
                        child: BlocProvider.value(
                            value: context.read<EditListBloc>(),
                            child: const IsRankedIconButton()
                        )
                    ),
                  ),
                  /*** Games in list preview ***/
                  BlocProvider.value(
                    value: context.read<EditListBloc>(),
                    child: const PreviewGamesGrid(),
                  )
                ]
            ),
          ),
        )
    );
  }
}
