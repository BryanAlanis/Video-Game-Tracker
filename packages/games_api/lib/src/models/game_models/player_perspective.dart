class PlayerPerspectiveModel {
  final String name;

  PlayerPerspectiveModel({required this.name});

  PlayerPerspectiveModel.fromJson(Map<String, dynamic> json) :
        name = json['name'];

  Map<String, dynamic> toJson() => {
    'name': name
  };
}