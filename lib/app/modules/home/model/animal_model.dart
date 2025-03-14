class Animal {
  final String id;
  final String name;
  final String species;
  final int age;
  final String habitat;
  final String habitatUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Animal({
    required this.id,
    required this.name,
    required this.species,
    required this.age,
    required this.habitat,
    required this.habitatUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create an Animal instance from JSON
  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      species: json['species'] ?? '',
      age: json['age'] ?? 0,
      habitat: json['habitat'] ?? '',
      habitatUrl: json['habitatUrl'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? ''),
      updatedAt: DateTime.parse(json['updatedAt'] ?? ''),
    );
  }

  // Convert an Animal instance to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'species': species,
      'age': age,
      'habitat': habitat,
      'habitatUrl': habitatUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
