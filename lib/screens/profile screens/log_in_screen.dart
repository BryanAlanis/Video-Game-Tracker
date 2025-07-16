import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_game_tracker/bloc/app_wide_blocs/app_auth_bloc/app_auth_bloc.dart';
import 'package:video_game_tracker/bloc/app_wide_blocs/app_auth_bloc/app_auth_state.dart';
import 'package:video_game_tracker/bloc/profile_screen_blocs/log_in_cubit/log_in_cubit.dart';
import 'package:video_game_tracker/bloc/profile_screen_blocs/log_in_cubit/log_in_state.dart';
import 'package:video_game_tracker/screens/profile%20screens/sign_up_screen.dart';
import 'package:video_game_tracker/util/styles.dart';


class LogInScreen extends StatelessWidget {
  final bool shouldPopContext;
  const LogInScreen({super.key, required this.shouldPopContext});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppAuthBloc, AppAuthState>(
      bloc: context.read<AppAuthBloc>(),
      listenWhen: (previous, current) => previous.appStatus != current.appStatus,
      listener: (context, state) {
        /// If sign up is successful and the bloc has emitted AuthenticatedState
        /// pop this screen to show the user their profile
        if (shouldPopContext && state.appStatus == Status.authenticated) {
          Navigator.pop(context);
        }
      },
      child: RepositoryProvider(
        create: (context) => AuthenticationRepository(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AppAuthBloc>.value(
              value: context.read<AppAuthBloc>()
            ),
            BlocProvider<LogInCubit>(
              create: (context) => LogInCubit(
                  RepositoryProvider.of<AuthenticationRepository>(context)
              ),
            ),
          ],
          child: const LogInView(),
        ),
      ),
    );
  }
}

///
/// LogInView
///
/// Displays a form where the user can enter their email and password
/// to sing in. Provides option for the user to be taken to a sign up screen
/// if they do not have an account yet.
///
class LogInView extends StatelessWidget {
  const LogInView({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Log In',
          style: Theme.of(context).textTheme.displaySmall,
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            /// Email
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: EmailTextField(),
            ),
            /// Password
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: PasswordTextField(),
            ),
            /// Log in button and Sign up prompt
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: BlocProvider<AppAuthBloc>.value(
                      value: context.read<AppAuthBloc>(),
                      child: const LogInButton()
                    ),
                  ),
                  BlocProvider<AppAuthBloc>.value(
                    value: context.read<AppAuthBloc>(),
                    child: const SignUpPrompt()
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmailTextField extends StatelessWidget {
  const EmailTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogInCubit, LogInState>(
      buildWhen: (previous, current) => 
        previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        return TextField(
          keyboardType: TextInputType.emailAddress,
          onChanged: (email) => context.read<LogInCubit>().emailChanged(email),
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: const Icon(Icons.email),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(getBorderRadius(factor: 2))
              )
            ),
            /// Trigger the error border but don't show the error message here
            errorText: state.errorMessage != null ? '' : null
          ),
        );
      },
    );
  }
}

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogInCubit, LogInState>(
      buildWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        return TextField(
          obscureText: true,
          obscuringCharacter: '*',
          onChanged: (password) => context.read<LogInCubit>().passwordChanged(password),
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.password),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(getBorderRadius(factor: 2))
              )
            ),
            errorText: state.errorMessage
          ),
        );
      },
    );
  }
}

class LogInButton extends StatelessWidget {
  const LogInButton({super.key,});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogInCubit, LogInState>(
      /// Rebuild when user types or deletes something
      buildWhen: (previous, current) =>
      (current.email.isEmpty || current.password.isEmpty) ||
          (current.email.isNotEmpty || current.password.isNotEmpty),
      builder: (context, state) {
        return FilledButton(
          onPressed: state.password.isNotEmpty && state.email.isNotEmpty ?
            () {
              context.read<LogInCubit>().logIn();
            } : null,
          style: const ButtonStyle(
            minimumSize: WidgetStatePropertyAll(Size(double.infinity, 40))
          ),
          child: const Text('Log In')
        );
      }
    );
  }
}

class SignUpPrompt extends StatelessWidget {
  const SignUpPrompt({super.key,});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account?',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        TextButton(
          onPressed: (){
            /// Send user to sign up screen with access to auth bloc
            Navigator.push(context, MaterialPageRoute(
              builder: (context2) {
                return BlocProvider<AppAuthBloc>.value(
                  /// make sure to pass widget context and not navigator context
                  value: context.read<AppAuthBloc>(),
                  child: const SignUpScreen(),
                );
              },
            ));
          },
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge?.merge(
              TextStyle(
                decoration: TextDecoration.underline,
                decorationColor:Theme.of(context).colorScheme.primary
              )
            ),
            foregroundColor: Theme.of(context).colorScheme.primary
          ),
          child: const Text('Sign up',),
        )
      ],
    );
  }
}