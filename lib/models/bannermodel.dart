class BannerModel {
  final String photo;
  final String url;
  final int position;

  BannerModel({
    required this.photo,
    required this.url,
    required this.position,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      photo: json['photo'],
      url: json['url'],
      position: json['position'],
    );
  }
}
