class InvolvedCompanyModel {
  final String name, description, logo;
  final bool developer, porting, publisher, supporting;


  InvolvedCompanyModel({
    required this.name,
    required this.description,
    required this.logo,
    required this.developer,
    required this.porting,
    required this.publisher,
    required this.supporting
  });

  InvolvedCompanyModel.fromJson(Map<String, dynamic> json) :
        name = json['name'] ?? json['company']['name'],
        /// Json format from FireStore and Postgres are different for this model.
        /// Check both if one comes back null.
        description = json['description'] ?? json['company']['description'],
        logo = json['logoImageId'] ?? json['company']['logoImageId'],
        developer = json['developer'],
        porting = json['porting'],
        publisher = json['publisher'],
        supporting = json['supporting']
  ;

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'logoImageID': logo,
    'developer': developer,
    'porting': porting,
    'publisher': publisher,
    'supporting': supporting
  };
}