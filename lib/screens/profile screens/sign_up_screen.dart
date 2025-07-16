import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_game_tracker/bloc/app_wide_blocs/app_auth_bloc/app_auth_bloc.dart';
import 'package:video_game_tracker/bloc/app_wide_blocs/app_auth_bloc/app_auth_state.dart';
import 'package:video_game_tracker/util/styles.dart';
import '../../bloc/profile_screen_blocs/sign_up_cubit/sign_up_cubit.dart';
import '../../bloc/profile_screen_blocs/sign_up_cubit/sign_up_state.dart';

///
/// SingUpScreen
///
/// Displays a form where the user can enter their email and password
/// to sing up. It gets passed an instance of [AppAuthBloc] from the log in screen.
///
/// shouldPopContext tells this screen that an additional screen needs to be
/// popped. User came to this screen through a sing in prompt other than
/// the one found in
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppAuthBloc, AppAuthState>(
      bloc: context.read<AppAuthBloc>(),
      listenWhen: (previous, current) => previous.appStatus != current.appStatus,
      listener: (context, state) {
        /// If sign up is successful and the bloc has emitted AuthenticatedState
        /// pop this screen to show the user their profile
        if (state.appStatus == Status.authenticated) {
          Navigator.pop(context);
        }
      },
      child: RepositoryProvider(
        create: (context) => AuthenticationRepository(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(
                value: context.read<AppAuthBloc>()
            ),
            BlocProvider(
              create: (context) => SignUpCubit(
                  RepositoryProvider.of<AuthenticationRepository>(context)
              ),
            )
          ],
          child: const SignUpView()),
      ),
    );
  }
}

///
/// SignUp
///
/// Widget that contains the text-fields and buttons used by the user
/// SignUpScreen calls this and provides an error message to display if there is one
/// by using BlocBuilder
///
class SignUpView extends StatelessWidget {
  const SignUpView({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: Theme.of(context).textTheme.displaySmall,
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            /// Name text-field
            const Padding(
              padding: EdgeInsets.only(top: 20,),
              child: NameTextField(),
            ),
            /// Email text-field
            const Padding(
              padding: EdgeInsets.only(top: 10,),
              child: EmailTextField()
            ),
            /// Password text-field
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: PasswordTextField(),
            ),
            /// Sign up button
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: BlocProvider.value(
                  value: context.read<AppAuthBloc>(),
                  child: const SignUpButton()
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NameTextField extends StatelessWidget {
  const NameTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
        previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        return TextField(
          onChanged: (name) => context.read<SignUpCubit>().nameChanged(name),
          decoration: InputDecoration(
            labelText: 'Name',
            prefixIcon: const Icon(Icons.person),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))
            ),
            /// Trigger the error border but don't show the error message here
            errorText: state.errorMessage != null ? '' : null
          ),
        );
      },
    );
  }
}

class EmailTextField extends StatelessWidget {
  const EmailTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
        previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        return TextField(
          keyboardType: TextInputType.emailAddress,
          onChanged: (email) => context.read<SignUpCubit>().emailChanged(email),
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: const Icon(Icons.email),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))
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
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
        previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        return TextField(
          obscureText: true,
          obscuringCharacter: '*',
          onChanged: (password) => context.read<SignUpCubit>().passwordChanged(password),
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.password),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(getBorderRadius(factor: 2)))
            ),
            errorText: state.errorMessage
          ),
        );
      },
    );
  }
}

class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key,});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
      (current.email.isEmpty || current.password.isEmpty) ||
          (current.email.isNotEmpty || current.password.isNotEmpty),
      builder: (context, state) {
        return FilledButton(
          onPressed: state.password.isNotEmpty && state.email.isNotEmpty ? () {
            context.read<SignUpCubit>().signUp();
          } : null,
          child: const Text('Sign Up',)
        );
      },
    );
  }
}