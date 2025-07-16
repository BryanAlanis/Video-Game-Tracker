class AlternativeNameModel {
  final String name;

  AlternativeNameModel({required this.name,});

  AlternativeNameModel.fromJson(Map<String, dynamic> json) :
        name = json['name'] ?? 'No alternative name';

  Map<String, dynamic> toJson() => {
    'name': name,
  };
}