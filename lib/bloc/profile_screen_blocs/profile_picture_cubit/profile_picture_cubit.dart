import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_game_tracker/bloc/profile_screen_blocs/profile_picture_cubit/profile_picture_state.dart';
import 'package:picture_storage_repository/profile_picture_repository.dart';

class ProfilePictureCubit extends Cubit<ProfilePictureState> {
  final PictureStorageRepository repository;
  ProfilePictureCubit({required this.repository}) : super(const ProfilePictureState());

  void saveImage() async {
    if (state.image != null) {
      await repository.saveImage(File(state.image!.path));
    }
  }

  void getImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: image.path,
        cropStyle: CropStyle.circle,
        // uiSettings: [
        //   AndroidUiSettings(
        //
        //   )
        // ]
      );
      if (croppedImage != null) {
        emit(state.copyWith(image: XFile(croppedImage.path), stateStatus: StateStatus.loadedImage));
      }
    }
    emit(state.copyWith(stateStatus: StateStatus.defaultImage));
  }
}