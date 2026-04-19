class CommunityNeed {
  final String id;
  final String ngoId;
  final String category;
  final String location;
  final double latitude;
  final double longitude;
  final String description;
  final String urgency;
  final String status;
  final bool isPredicted;
  final DateTime createdAt;

  CommunityNeed({
    required this.id,
    required this.ngoId,
    required this.category,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.urgency,
    this.status = 'open',
    this.isPredicted = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ngoId': ngoId,
      'category': category,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'urgency': urgency,
      'status': status,
      'isPredicted': isPredicted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CommunityNeed.fromMap(Map<String, dynamic> map) {
    return CommunityNeed(
      id: map['id'],
      ngoId: map['ngoId'],
      category: map['category'],
      location: map['location'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      description: map['description'],
      urgency: map['urgency'],
      status: map['status'] ?? 'open',
      isPredicted: map['isPredicted'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

class Volunteer {
  final String id;
  final String name;
  final String email;
  final List<String> skills;
  final String location;
  final double latitude;
  final double longitude;
  final String availability;

  Volunteer({
    required this.id,
    required this.name,
    required this.email,
    required this.skills,
    required this.location,
    required this.latitude,
    required this.longitude,
    this.availability = 'available',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'skills': skills,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'availability': availability,
    };
  }

  factory Volunteer.fromMap(Map<String, dynamic> map) {
    return Volunteer(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      skills: List<String>.from(map['skills']),
      location: map['location'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      availability: map['availability'] ?? 'available',
    );
  }
}