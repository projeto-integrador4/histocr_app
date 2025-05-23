class Occupation {
  final String id;
  final String name;

  Occupation({required this.id, required this.name});

  factory Occupation.fromJson(Map<String, dynamic> json) {
    return Occupation(id: json['id'], name: json['name']);
  }
}
