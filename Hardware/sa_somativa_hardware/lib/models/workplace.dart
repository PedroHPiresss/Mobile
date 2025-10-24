class Workplace {
  final String id;
  final String userId;
  final double latitude;
  final double longitude;
  final String name;

  Workplace({
    required this.id,
    required this.userId,
    required this.latitude,
    required this.longitude,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
    };
  }

  factory Workplace.fromMap(Map<String, dynamic> map) {
    return Workplace(
      id: map['id'],
      userId: map['userId'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      name: map['name'],
    );
  }
}
