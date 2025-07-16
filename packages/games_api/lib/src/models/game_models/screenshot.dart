class ScreenshotModel {
  final String imageId;

  ScreenshotModel({required this.imageId});

  ScreenshotModel.fromJson(Map<String, dynamic> json) :
    imageId = json['imageId'];

  Map<String, dynamic> toJson() => {
    'imageId': imageId,
  };
}