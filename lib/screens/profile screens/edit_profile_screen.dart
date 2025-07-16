import 'dart:io';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:picture_storage_repository/profile_picture_repository.dart';
import 'package:video_game_tracker/bloc/profile_screen_blocs/edit_profile_cubit/edit_profile_state.dart';
import 'package:video_game_tracker/widgets/profile_picture.dart';
import '../../bloc/profile_screen_blocs/edit_profile_cubit/edit_profile_cubit.dart';
import '../../util/styles.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthenticationRepository()
        ),
        RepositoryProvider(
          create: (context) => PictureStorageRepository(),
        )
      ],
      child: BlocProvider(
        create: (context) => EditProfileCubit(
          authenticationRepository: context.read<AuthenticationRepository>(),
          pictureStorageRepository: context.read<PictureStorageRepository>(),
          initialName: context.read<AuthenticationRepository>().currentUser.name,
        ),
        child: EditProfileView(
          initialName: context.read<AuthenticationRepository>().currentUser.name
        )
      ),
    );
  }
}

class EditProfileView extends StatelessWidget {
  final String? initialName;

  const EditProfileView({super.key, this.initialName = ''});

  @override
  Widget build(BuildContext context) {
    double padding = getEdgePadding();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        actions: [
          /// 'Save' button
          BlocBuilder<EditProfileCubit, EditProfileState>(
            buildWhen: (previous, current) {
              return previous.stateStatus != current.stateStatus;
            },
            builder: (context, state) {
              return TextButton(
                onPressed: state.stateStatus == StateStatus.changesMade?
                  (){
                    context.read<EditProfileCubit>().saveChanges();

                    /// Confirmation snack bar
                    const snackBar = SnackBar(
                      content: Text("Changes Saved"),
                      backgroundColor: Colors.green,

                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.pop(context);
                  } : null,
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: state.stateStatus == StateStatus.changesMade ?
                      Theme.of(context).colorScheme.primary : Colors.grey
                  ),
                )
              );
            }
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(
            top: padding,
            left: padding,
            right: padding
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: Column(
                children: [
                  /// Profile Picture
                  BlocProvider.value(
                    value: context.read<EditProfileCubit>(),
                    child: EditProfilePicture(
                      initialPictureUrl: context.read<AuthenticationRepository>().currentUser.photo ?? '',
                    ),
                  ),
                  const SizedBox(height: 50),
                  /// Name
                  BlocProvider.value(
                    value: context.read<EditProfileCubit>(),
                    child: CustomTextField(
                      initialName: initialName,
                    )
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

///
/// Profile Picture
///
/// Shows the user's profile picture with an icon on top of it to show
/// that it can be edited.
///
class EditProfilePicture extends StatelessWidget {
  final String initialPictureUrl;
  const EditProfilePicture({super.key, required this.initialPictureUrl,});

  @override
  Widget build(BuildContext context) {
    double profilePictureRadius = getProfilePictureRadiusBig();

    return BlocBuilder<EditProfileCubit, EditProfileState>(
      buildWhen: (previous, current) {
        return current.stateStatus == StateStatus.changesMade
            && previous.profilePicture != current.profilePicture;
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () async => await context.read<EditProfileCubit>().getImageFromGallery(),
          child: Stack(
            children: [
              /// Check if initial profile picture or changed (new) picture should
              /// be used.
              state.profilePicture == null
                  ? ProfilePicture(pictureURL: initialPictureUrl,)
                  : CircleAvatar(
                      radius: profilePictureRadius,
                      foregroundImage: FileImage(
                        File(state.profilePicture?.path ?? ''),
                      ),
                    ),
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: profilePictureRadius,
                child: Icon(
                  Icons.camera_alt_outlined,
                  size: profilePictureRadius - 5
                ),
              )
            ]
          ),
        );
      }
    );
  }
}

class CustomTextField extends StatefulWidget {
  final String? initialName;

  const CustomTextField({super.key, this.initialName = '',});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.initialName);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      buildWhen: (previous, current) {
        return current.stateStatus == StateStatus.changesMade
            && previous.newName != current.newName
            && current.newName != current.initialName;
      },
      builder: (context,state) {
        return TextField(
          controller: _controller,
          onChanged: (name) => context.read<EditProfileCubit>().nameChanged(name),
          decoration: InputDecoration(
            labelText: 'Name',
            prefixIcon: const Icon(Icons.person),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(getBorderRadius(factor: 2))
                )
            ),
          ),
        );
      }
    );
  }
}