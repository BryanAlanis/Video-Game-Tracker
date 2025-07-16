class AgeRatingModel {
  final String rating;
  final String organization;

  AgeRatingModel({required this.rating, required this.organization});

  AgeRatingModel.fromJson(Map<String, dynamic> json) :
      rating = json['rating'] ?? 'Unrated',
      organization = json['organization'] ?? 'No associated organization';

  Map<String, dynamic> toJson() => {
      'rating': rating,
      'organization': organization
  };
}