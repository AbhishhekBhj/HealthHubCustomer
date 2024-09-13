class FitnessLevel {
  final int id;
  final String levelName;

  FitnessLevel({required this.id, required this.levelName});

  // Factory method to create a FitnessLevel from a map
  factory FitnessLevel.fromMap(Map<String, dynamic> map) {
    return FitnessLevel(
      id: map['id'],
      levelName: map['LevelName'],
    );
  }

  // Convert a FitnessLevel to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'LevelName': levelName,
    };
  }
}
