class ArtworkModel {
  final String imageId;

  ArtworkModel({required this.imageId});

  ArtworkModel.fromJson(Map<String, dynamic> json) :
        imageId = json['imageId'];

  Map<String, dynamic> toJson() => {
    'imageId': imageId
  };
}