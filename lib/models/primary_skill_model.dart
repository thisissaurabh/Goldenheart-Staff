class AstroSkill {
  final String name;
  final int id;

  AstroSkill({required this.name, required this.id});

  factory AstroSkill.fromJson(Map<String, dynamic> json) {
    return AstroSkill(
      name: json['name'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
    };
  }
}
