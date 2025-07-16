class ReleaseDateModel {
  final int year;
  final int platformId;
  final String date;

  ReleaseDateModel({
    required this.year,
    required this.platformId,
    required this.date
  });

  ReleaseDateModel.fromJson(Map<String, dynamic> json) :
    year = json['year'],
    platformId = json['platformId'],
    date = json['date']
  ;

  Map<String, dynamic> toJson() => {
    'year': year,
    'platformId': platformId,
    'date': date
  };
}