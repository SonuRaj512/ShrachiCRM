class Dealer {
  final int id;
  final String name;
  final String? state;
  final String? distick;
  final String? zone;
  final String? city;

  Dealer({
    required this.id,
    required this.name,
    this.state,
    this.distick,
    this.zone,
    this.city,
  });

  factory Dealer.fromJson(Map<String, dynamic> json) {
    return Dealer(
      id: json['id'],
      name: json['name'],
      state: json['state_code'],
      distick: json['district'],
      zone: json['zone'],
      city: json['city'],
    );
  }
}
