class GameEngineModel {
  String description;
  String name;
  String logo;

  GameEngineModel({
    this.name = '',
    this.description = '',
    required this.logo
  });

  GameEngineModel.fromJson(Map<String, dynamic> json) :
      description = json['description'],
      name = json['name'],
      logo = json['logoImageId']
  ;

  Map<String, dynamic> toJson() => {
    'description': description,
    'name': name,
    'logoImageId': logo
  };
}