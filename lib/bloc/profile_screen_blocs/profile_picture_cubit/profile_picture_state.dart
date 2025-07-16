import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

enum StateStatus {error, defaultImage, loadedImage,}

class ProfilePictureState extends Equatable {

  final StateStatus stateStatus;
  final XFile? image;

  const ProfilePictureState({
    this.stateStatus = StateStatus.defaultImage,
    this.image
  });

  ProfilePictureState copyWith({
    StateStatus? stateStatus,
    XFile? image
  }) {
    return ProfilePictureState(
      stateStatus: stateStatus ?? this.stateStatus,
      image: image ?? this.image
    );
  }

  @override
  List<Object?> get props => [stateStatus, image];

}