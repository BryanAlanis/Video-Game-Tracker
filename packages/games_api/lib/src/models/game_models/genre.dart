class GenreModel {
  final String name;

  GenreModel({required this.name});

  GenreModel.fromJson(Map<String, dynamic> json) :
    name = json['name'];

  Map<String, dynamic> toJson() => {
    'name': name,
  };

  @override
  String toString() {
    return name;
  }
}