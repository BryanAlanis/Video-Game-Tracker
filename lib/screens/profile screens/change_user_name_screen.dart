import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_game_tracker/bloc/profile_screen_blocs/update_user_name_cubit/update_user_name_cubit.dart';
import 'package:video_game_tracker/bloc/profile_screen_blocs/update_user_name_cubit/update_user_name_state.dart';

class UpdateNameScreen extends StatelessWidget {
  final String currentName;
  const UpdateNameScreen({super.key, required this.currentName});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthenticationRepository(),
      child: BlocProvider<UpdateUsernameCubit>(
        create: (context) => UpdateUsernameCubit(
          repository: context.read<AuthenticationRepository>(),
          initialName: currentName,
        ),
        child: UpdateNameView(currentName: currentName,),
      ),
    );
  }
}

class UpdateNameView extends StatefulWidget {
  final String currentName;

  const UpdateNameView({super.key, required this.currentName});

  @override
  State<UpdateNameView> createState() => _UpdateNameViewState();
}

class _UpdateNameViewState extends State<UpdateNameView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.currentName);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Name'),
        leading: BackButton(
        onPressed: () => Navigator.pop(context),
        ),
        actions: [
          BlocBuilder<UpdateUsernameCubit, UpdateUsernameState>(
            buildWhen: (previous, current) => previous.name != current.name,
            builder: (context, state) {
              return TextButton(
                onPressed: state.name != state.initialName ? (){
                  context.read<UpdateUsernameCubit>().updateName(state.name);
                } : null,
                child: Text(
                  'Save',
                  style: Theme.of(context).textTheme.bodyLarge?.merge(
                    TextStyle(
                      color: state.name != state.initialName ?
                        Theme.of(context).colorScheme.primary : Colors.grey
                    )
                  )
                )
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: BlocConsumer<UpdateUsernameCubit, UpdateUsernameState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (BuildContext context, UpdateUsernameState state) {
            if(state.status == UpdateUsernameStateStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message)
                )
              );
            }
          },
          buildWhen: (previous, current) => previous.status != current.status,
          builder: (context, state) {
            return TextField(
              controller: _controller,
              onChanged: (name) => context.read<UpdateUsernameCubit>().nameChanged(name),
              decoration: InputDecoration(
                labelText: 'Name',
                prefixIcon: const Icon(Icons.person),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))
                ),
                errorText: state.status == UpdateUsernameStateStatus.error ?
                    state.message : null,
                focusColor: state.status == UpdateUsernameStateStatus.success ?
                    Colors.green : null
              ),
            );
          },
        ),
      ),
    );
  }
}