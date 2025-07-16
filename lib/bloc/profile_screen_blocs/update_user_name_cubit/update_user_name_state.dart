enum UpdateUsernameStateStatus {initial, success, error}

class UpdateUsernameState {
  final UpdateUsernameStateStatus status;
  final String message, name, initialName;

  const UpdateUsernameState({
    this.status = UpdateUsernameStateStatus.initial,
    this.message = '',
    this.name = '',
    required this.initialName
  });

  UpdateUsernameState copyWith({
    UpdateUsernameStateStatus? status,
    String? message,
    String? name,
    String? initialName
  }) {
    return UpdateUsernameState(
      status: status ?? this.status,
      message: message ?? this.message,
      name: name ?? this.name,
      initialName: initialName ?? this.initialName
    );
  }
}