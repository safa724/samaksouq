class TodayProduct {
  final int id;
  final String name;
  final String thumbnailImage;
  final bool hasDiscount;
  final String discount;
  final String strokedPrice;
  final String mainPrice;
  final int rating;
  final int sales;
  int quantity;


  TodayProduct({
    required this.id,
    required this.name,
    required this.thumbnailImage,
    required this.hasDiscount,
    required this.discount,
    required this.strokedPrice,
    required this.mainPrice,
    required this.rating,
    required this.sales,
    this.quantity = 1,
  });
double get mainPriceAsDouble {
    final numericPart = mainPrice.replaceAll(RegExp(r'[^0-9.]'), '');
    try {
      return double.parse(numericPart);
    } catch (e) {
      // Handle the exception (e.g., return a default value)
      return 0.0;
    }
  }
  factory TodayProduct.fromJson(Map<String, dynamic> json) {
    return TodayProduct(
      id: json['id'],
      name: json['name'],
      thumbnailImage: json['thumbnail_image'],
      hasDiscount: json['has_discount'],
      discount: json['discount'],
      strokedPrice: json['stroked_price'],
      mainPrice: json['main_price'],
      rating: json['rating'],
      sales: json['sales'],
    );
  }
}