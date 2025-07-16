class PlatformModel {
  final int id;
  final String name;
  final String abbreviation;
  final String logo;


  PlatformModel({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.logo,
  });

  PlatformModel.fromJson(Map<String, dynamic> json) :
      id = json['id'],
      name = json['name'],
      abbreviation = json['abbreviation'],
      logo = json['logoImageId'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'abbreviation': abbreviation,
    'logoImageId': logo
  };

  @override
  String toString() {
    return name;
  }
}