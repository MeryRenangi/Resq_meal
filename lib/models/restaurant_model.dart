class RestaurantModel {
  const RestaurantModel({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.address,
    this.latitude,
    this.longitude,
    this.rating,
  });

  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final String? address;
  final double? latitude;
  final double? longitude;
  final double? rating;

  factory RestaurantModel.fromMap(Map<String, dynamic> map, {required String id}) {
    return RestaurantModel(
      id: id,
      name: map['name'] as String? ?? '',
      description: map['description'] as String?,
      imageUrl: map['imageUrl'] as String?,
      address: map['address'] as String?,
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      rating: (map['rating'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        if (description != null) 'description': description,
        if (imageUrl != null) 'imageUrl': imageUrl,
        if (address != null) 'address': address,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (rating != null) 'rating': rating,
      };
}
