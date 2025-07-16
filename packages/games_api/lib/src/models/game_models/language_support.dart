class LanguageSupportModel {
  final String name;
  final String nativeName;
  final String type;

  LanguageSupportModel({
    required this.name,
    required this.nativeName,
    required this.type,
  });

  LanguageSupportModel.fromJson(Map<String, dynamic> json) :
      name = json['name'] ?? json['language']['name'],
      nativeName = json['nativeName'] ?? json['language']['nativeName'],
      type = json['type'] ?? json['languageSupportType']['type'];
}