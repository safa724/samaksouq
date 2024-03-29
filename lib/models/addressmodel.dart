class Address {
  final int id;
  final String? address;
  final String phone;

  Address({
    required this.id,
    this.address,
    required this.phone,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      address: json['address'] ?? '',
      phone: json['phone'],
    );
  }
}