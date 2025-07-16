class ThemeModel {
  final String name;

  ThemeModel({required this.name});

  ThemeModel.fromJson(Map<String, dynamic> json) :
    name = json['name'];

  Map<String, dynamic> toJson() => {
    'name': name,
  };

  @override
  String toString() {
    return name;
  }
}