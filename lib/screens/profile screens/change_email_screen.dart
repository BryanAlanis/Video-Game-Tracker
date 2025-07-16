import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/profile_screen_blocs/update_email_bloc/update_email_cubit.dart';
import '../../bloc/profile_screen_blocs/update_email_bloc/update_email_state.dart';

class UpdateEmailScreen extends StatelessWidget {
  final String currentEmail;
  const UpdateEmailScreen({super.key, required this.currentEmail});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthenticationRepository(),
      child: BlocProvider<UpdateEmailCubit>(
        create: (context) => UpdateEmailCubit(
          repository: context.read<AuthenticationRepository>(),
          initialEmail: currentEmail
        ),
        child: UpdateEmailView(currentEmail: currentEmail,),
      ),
    );
  }
}

class UpdateEmailView extends StatelessWidget {
  final String currentEmail;

  const UpdateEmailView({super.key, required this.currentEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Email'),
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          /// Save button
          BlocBuilder<UpdateEmailCubit, UpdateEmailState>(
            buildWhen: (previous, current) => previous.email != current.email,
            builder: (context, state) {
              return TextButton(
                onPressed: state.email != state.initialEmail ? (){
                  context.read<UpdateEmailCubit>().updateEmail();
                } : null,
                child: Text(
                  'Save',
                  style: Theme.of(context).textTheme.bodyLarge?.merge(
                    TextStyle(
                        color: state.email != state.initialEmail ?
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
        child: Column(
          children: [
            /// Email
            BlocBuilder<UpdateEmailCubit, UpdateEmailState>(
              buildWhen: (previous, current) => previous.status != current.status,
              builder: (context, state) {
                return TextField(
                  onChanged: (email) =>
                      context.read<UpdateEmailCubit>().emailChanged(email),
                  decoration: InputDecoration(
                    labelText: 'New Email',
                    prefixIcon: const Icon(Icons.email),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16))
                    ),
                    errorText: state.status == UpdateEmailStateStatus.error ?
                    '' : null,
                    focusColor: state.status == UpdateEmailStateStatus.success ?
                    Colors.green : null
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            /// Password
            BlocConsumer<UpdateEmailCubit, UpdateEmailState>(
              listenWhen: (previous, current) => previous.status != current.status,
              listener: (BuildContext context, UpdateEmailState state) {
                if(state.status == UpdateEmailStateStatus.success) {
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
                  onChanged: (password) =>
                      context.read<UpdateEmailCubit>().passwordChanged(password),
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.password),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16))
                    ),
                    errorText: state.status == UpdateEmailStateStatus.error ?
                    state.message : null,
                    focusColor: state.status == UpdateEmailStateStatus.success ?
                    Colors.green : null
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}