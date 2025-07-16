import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picture_storage_repository/profile_picture_repository.dart';
import 'package:video_game_tracker/bloc/app_wide_blocs/app_auth_bloc/app_auth_event.dart';
import 'package:video_game_tracker/bloc/app_wide_blocs/app_auth_bloc/app_auth_state.dart';
import 'package:video_game_tracker/screens/profile%20screens/about_screen.dart';
import 'package:video_game_tracker/screens/profile%20screens/change_email_screen.dart';
import 'package:video_game_tracker/util/styles.dart';
import '../../bloc/app_wide_blocs/app_auth_bloc/app_auth_bloc.dart';
import '../../bloc/profile_screen_blocs/profile_picture_cubit/profile_picture_cubit.dart';
import '../../widgets/profile_picture.dart';
import 'delete_account_screen.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<PictureStorageRepository>(
      create: (context) => PictureStorageRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ProfilePictureCubit>(
            create: (context) => ProfilePictureCubit(
              repository: context.read<PictureStorageRepository>()
            ),
          ),
          BlocProvider.value(value: context.read<AppAuthBloc>(),),
        ],
        child: const ProfileSettingsView(),
      ),
    );
  }
}

class ProfileSettingsView extends StatelessWidget {
  const ProfileSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    String? userEmail = context.read<AppAuthBloc>().state.currentUser.email;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings'),
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: getEdgePadding()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Profile picture, name, and email
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  /// Profile Picture
                  ProfilePicture(
                    pictureURL: context.read<AppAuthBloc>()
                        .state.currentUser.photo ?? '',
                  ),
                  const Padding(padding: EdgeInsets.only(left: 15)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Name
                      BlocBuilder<AppAuthBloc, AppAuthState>(
                        buildWhen: (previous, current) =>
                          previous.currentUser.name != current.currentUser.name,
                        builder: (context, state) => Text(
                          state.currentUser.name ?? '',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      /// Email
                      BlocBuilder<AppAuthBloc, AppAuthState>(
                        buildWhen: (previous, current) =>
                          previous.currentUser.email != current.currentUser.email,
                        builder: (context, state) => Text(
                          state.currentUser.email ?? '',
                          style: Theme.of(context).textTheme.titleSmall
                        ),
                      )
                    ],
                  )
                ],
              )
            ),
            const SizedBox(height: 50,),
            /// Change Email
            UpdateEmailListTile(userEmail: userEmail ?? ''),
            Divider(height: 1, color: Colors.grey.shade800,),
            /// About
            const AboutListTile(),
            Divider(height: 1, color: Colors.grey.shade800,),
            /// Delete account
            const DeleteAccountListTile(),
            Divider(height: 1, color: Colors.grey.shade800,),
            /// Log out
            const LogOutListTile(),
          ],
        ),
      ),
    );
  }
}

class UpdateEmailListTile extends StatelessWidget {
  final String userEmail;
  const UpdateEmailListTile({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context2) {
            return UpdateEmailScreen(currentEmail: userEmail,);
          },
        ));
      },
      title: const Text('Change Email'),
      leading: const Icon(Icons.email),
      trailing: const Icon(Icons.arrow_forward_ios),
      tileColor: Colors.grey.shade900,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(getBorderRadius()),
              topRight: Radius.circular(getBorderRadius())
          )
      ),
    );
  }
}

class LogOutListTile extends StatelessWidget {
  const LogOutListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        context.read<AppAuthBloc>().add(LogoutEvent());
        Navigator.pop(context);
      },
      title: const Text('Log out'),
      leading: const Icon(Icons.logout),
      tileColor: Colors.grey.shade900,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(getBorderRadius()),
              bottomRight: Radius.circular(getBorderRadius())
          )
      ),
    );
  }
}

class DeleteAccountListTile extends StatelessWidget {
  const DeleteAccountListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context2) => BlocProvider.value(
            value: context.read<AppAuthBloc>(),
            child: const DeleteAccountScreen()
          )
        ));
      },
      title: const Text('Delete account', style: TextStyle(color: Colors.red),),
      leading: const Icon(Icons.delete, color: Colors.red,),
      tileColor: Colors.grey.shade900,
    );
  }
}

class AboutListTile extends StatelessWidget {
  const AboutListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context2) => const AboutScreen()
        ));
      },
      title: const Text('About'),
      leading: const Icon(Icons.info),
      tileColor: Colors.grey.shade900,
    );
  }
}