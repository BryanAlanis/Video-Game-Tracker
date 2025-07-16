import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_game_tracker/bloc/app_wide_blocs/app_auth_bloc/app_auth_state.dart';
import 'package:video_game_tracker/bloc/list_screen_blocs/all_lists_bloc/all_lists_events.dart';
import 'package:video_game_tracker/bloc/app_wide_blocs/games_bloc/games_bloc.dart';
import 'package:video_game_tracker/screens/lists%20screens/edit_list_screen.dart';
import 'package:user_list_api/user_list_api.dart';
import 'package:video_game_tracker/screens/profile%20screens/log_in_screen.dart';
import 'package:video_game_tracker/util/styles.dart';
import '../../bloc/app_wide_blocs/app_auth_bloc/app_auth_bloc.dart';
import '../../bloc/list_screen_blocs/all_lists_bloc/all_lists_bloc.dart';
import '../../bloc/list_screen_blocs/all_lists_bloc/all_lists_states.dart';
import '../../bloc/list_screen_blocs/edit_list_bloc/edit_list_bloc.dart';
import 'widgets/all_lists_list_item.dart';

class AllListsScreen extends StatelessWidget {
  const AllListsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// Create and pass all necessary blocs
    return RepositoryProvider<UserListRepository>(
      create: (context) => UserListRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<GamesBloc>()),
          BlocProvider(
            create: (context) => AllListsBloc(
              repository: RepositoryProvider.of<UserListRepository>(context)
            )..add(GetListsEvent()),
          ),
          BlocProvider<EditListBloc>(
            create: (context) => EditListBloc(
              repository: RepositoryProvider.of<UserListRepository>(context),
              //initialUserList: userList
            ),
          ),
        ],
        /// Only show User lists when user is logged in
        child: BlocBuilder<AppAuthBloc, AppAuthState>(
          bloc: context.read<AppAuthBloc>(),
          builder: (context, state) {
            /// User is logged in
            if (state.currentUser.isNotEmpty) {
              return const AllListsView();
            }

            /// User is not logged in
            return const UnauthenticatedAllListsView();
          },
        )
      )
    );
  }
}

///
/// AllListsView
///
/// Show all of the lists that this user has created.
/// Floating Action Button takes the user to the [CreateListScreen]
/// where they can create a new list.
///
class AllListsView extends StatelessWidget {
  const AllListsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Lists',
          style: Theme.of(context).textTheme.displaySmall,
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(getEdgePadding()),
        child: BlocBuilder<AllListsBloc, AllListsState>(
          bloc: context.read<AllListsBloc>(),
          builder: (context, state) {
            if (state is ListsLoaded) {
              /// The user has no lists yet
              if(state.lists.isEmpty) {
                return const Center(
                  child: Text('You don\'t have any lists yet')
                );
              }

              /// The user has at least one list
              return ListView.builder(
                itemCount: state.lists.length,
                itemBuilder: (BuildContext context, int index) {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: context.read<AllListsBloc>()),
                      BlocProvider.value(value: context.read<GamesBloc>()),
                    ],
                    child: ListItem(
                      userList: state.lists[index],
                      gamesInList: context.read<GamesBloc>().
                        getGamesFromID(state.lists[index].games)
                    ),
                  );
                },
              );
            }

            /// Loading
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
      /// Create a new list
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context2) {
                return MultiBlocProvider(
                  providers: [
                    BlocProvider.value(
                      value: context.read<EditListBloc>()
                    ),
                    BlocProvider.value(
                      value: context.read<GamesBloc>(),
                    )
                  ],
                  child: const EditListScreen()
                );
              }
          ));
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      )
    );
  }
}


///
/// UnauthenticatedAllListsView
///
/// Show when the user is not logged in
///
class UnauthenticatedAllListsView extends StatelessWidget {
  const UnauthenticatedAllListsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Lists',
          style: Theme.of(context).textTheme.displaySmall,
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Log in or create an account to view your lists',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20,),
                Padding(
                  padding: EdgeInsets.only(
                      left: constraints.minWidth,
                      right: constraints.minWidth
                  ),
                  child: FilledButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return BlocProvider.value(
                            value: context.read<AppAuthBloc>(),
                            child: const LogInScreen(shouldPopContext: true,)
                          );
                        },
                      ));
                    },
                    child: const Text('Log In')
                  ),
                )
              ]
            ),
          );
        },
      ),
    );
  }
}