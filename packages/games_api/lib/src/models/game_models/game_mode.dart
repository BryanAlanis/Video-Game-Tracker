class GameModeModel {
  final String name;

  GameModeModel({required this.name});

  GameModeModel.fromJson(Map<String, dynamic> json) :
    name = json['name'];

  Map<String, dynamic> toJson() => {
    'name': name,
  };

  @override
  String toString() {
    return name;
  }
}