class LeadStatus {
  final int id;
  final String name;

  LeadStatus({required this.id, required this.name});

  factory LeadStatus.fromJson(Map json) =>
      LeadStatus(id: json['id'], name: json['name']);
}
