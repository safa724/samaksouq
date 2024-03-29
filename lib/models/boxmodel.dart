class Box {
  final int id;
  final String boxName;
  final String boxSize;
  final String price;

  Box({required this.id, required this.boxName, required this.boxSize, required this.price});

  factory Box.fromJson(Map<String, dynamic> json) {
    return Box(
      id: json['id'],
      boxName: json['box_name'],
      boxSize: json['box_size'],
      price: json['price'],
    );
  }
}