import 'dart:io';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:picture_storage_repository/profile_picture_repository.dart';
import 'package:video_game_tracker/bloc/profile_screen_blocs/edit_profile_cubit/edit_profile_state.dart';
import '../../../util/styles.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final AuthenticationRepository authenticationRepository;
  final PictureStorageRepository pictureStorageRepository;

  EditProfileCubit({
    required this.authenticationRepository,
    required this.pictureStorageRepository,
    String? initialName,
    //File? initialPicture
  }) : super(EditProfileState(
      initialName: initialName ?? '',
      //initialPicture: initialPicture
  ));

  /// Used to enable the [save] button once the user edits the name
  /// text field.
  void nameChanged(newName) {
    /// Only enable the [save] button if a change has been made.
    if (newName == state.initialName && state.profilePicture == null) {
      emit(state.copyWith(stateStatus: StateStatus.noChangesMade));
    }
    else {
      emit(state.copyWith(
          stateStatus: StateStatus.changesMade, newName: newName));
    }
  }

  /// Used to enable the [save] button once the user edits the profile picture
  Future<void> getImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: image.path,
        cropStyle: CropStyle.circle,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        uiSettings: [
          AndroidUiSettings(
            backgroundColor: getBackgroundColor(),
            statusBarColor: getBackgroundColor(),
            toolbarColor: getBackgroundColor(),
            toolbarWidgetColor: getWhiteColor(),
            hideBottomControls: true,
          )
        ]
      );

      if (croppedImage != null) {
        emit(state.copyWith(
          stateStatus: StateStatus.changesMade,
          profilePicture: XFile(croppedImage.path),
        ));
      }
    }
  }

  void saveChanges () async {
    /// Only update name if changes were made
    if (state.newName != '') {
      await authenticationRepository.updateName(state.newName);
    }

    if (state.profilePicture != null) {
      await pictureStorageRepository.saveImage(
          File(state.profilePicture!.path));
    }
  }
}