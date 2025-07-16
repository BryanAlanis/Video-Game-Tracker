import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

enum StateStatus {noChangesMade, changesMade}

class EditProfileState extends Equatable {
  final StateStatus stateStatus;
  final String initialName;
  final String newName;
  final XFile? profilePicture;

  const EditProfileState ({
    this.stateStatus = StateStatus.noChangesMade,
    required this.initialName,
    this.newName = '',
    this.profilePicture
  });

  EditProfileState copyWith ({
    StateStatus? stateStatus,
    String? initialName,
    String? newName,
    XFile? profilePicture
  }) {
    return EditProfileState (
      stateStatus: stateStatus ?? this.stateStatus,
      initialName: initialName ?? this.initialName,
      newName: newName ?? this.newName,
      profilePicture: profilePicture ?? this.profilePicture
    );
  }

  @override
  List<Object?> get props => [stateStatus, newName, profilePicture];
}