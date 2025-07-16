import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_game_tracker/bloc/app_wide_blocs/app_auth_bloc/app_auth_bloc.dart';
import 'package:video_game_tracker/bloc/app_wide_blocs/app_auth_bloc/app_auth_state.dart';
import 'package:video_game_tracker/bloc/profile_screen_blocs/delete_account_cubit/delete_account_cubit.dart';
import 'package:video_game_tracker/bloc/profile_screen_blocs/delete_account_cubit/delete_account_state.dart';
import 'package:video_game_tracker/util/styles.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// If delete account is successful and the bloc has emitted
    /// UnAuthenticatedState pop this screen to show the user the
    /// log in screen
    return BlocListener<AppAuthBloc, AppAuthState>(
      bloc: context.read<AppAuthBloc>(),
      listenWhen: (previous, current) => current.appStatus == Status.unauthenticated,
      listener: (context, state) => Navigator.pop(context),
      child: BlocProvider.value(
        value: context.read<AppAuthBloc>(),
        child: RepositoryProvider<AuthenticationRepository>(
          create: (context) => AuthenticationRepository(),
          child: BlocProvider<DeleteAccountCubit>(
            create: (context) => DeleteAccountCubit(
              repository: RepositoryProvider.of<AuthenticationRepository>(context)),
            child: const DeleteAccountView()
          ),
        ),
      ),
    );
  }
}


class DeleteAccountView extends StatelessWidget {
  const DeleteAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Account'),
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
      ),
      /// Show a snack bar on successful account deletion
      body: BlocListener<DeleteAccountCubit, DeleteAccountState>(
        bloc: context.read<DeleteAccountCubit>(),
        listenWhen: (previous, current) => current.status == DeleteAccountStateStatus.success,
        listener: (context, state) {
          if (state.status == DeleteAccountStateStatus.success) {
            const snackBar = SnackBar(content: Text('Account Deleted.'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: Padding(
          padding:EdgeInsets.all(getEdgePadding()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*** Disclaimer ***/
              Text(
                'All of your data will be deleted and cannot be recovered.',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Padding(padding: EdgeInsets.only(top: 50)),
              Text(
                'Sign in to continue',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              /*** Password Text-field ***/
              BlocBuilder<DeleteAccountCubit, DeleteAccountState>(
                builder: (context, state) {
                  return TextField(
                    onChanged: (password) =>
                      context.read<DeleteAccountCubit>().passwordChanged(password),
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.password),
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(getBorderRadius(factor: 2))
                        )
                      ),
                      errorText: state.status == DeleteAccountStateStatus.error ?
                      state.message : null,
                    )
                  );
                }
              ),
              const SizedBox(height: 20,),
              /*** Delete Button ***/
              Center(
                child: BlocBuilder<DeleteAccountCubit, DeleteAccountState>(
                  buildWhen: (previous, current) =>
                    current.password.isEmpty || current.password.isNotEmpty,
                  builder: (context, state) {
                    return FilledButton(
                      onPressed: state.password.isNotEmpty ? (){
                        context.read<DeleteAccountCubit>().deleteAccount();
                      } : null,
                      child: const Text('Delete Account')
                    );
                  }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
