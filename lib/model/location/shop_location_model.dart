class ShopLocationModel {
  final double latitude;
  final double longitude;
  final double radiusInMeters;

  ShopLocationModel({required this.latitude, required this.longitude, required this.radiusInMeters});

  // Convert to JSON for API calls
  Map<String, dynamic> toJson() {
    return {'latitude': latitude, 'longitude': longitude, 'radius_in_meters': radiusInMeters};
  }

  // Create from JSON
  factory ShopLocationModel.fromJson(Map<String, dynamic> json) {
    return ShopLocationModel(
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      radiusInMeters: json['radius_in_meters']?.toDouble() ?? 50.0,
    );
  }

  // Create a copy with optional field updates
  ShopLocationModel copyWith({double? latitude, double? longitude, double? radiusInMeters}) {
    return ShopLocationModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radiusInMeters: radiusInMeters ?? this.radiusInMeters,
    );
  }

  @override
  String toString() {
    return 'ShopLocationModel(lat: $latitude, lng: $longitude, radius: $radiusInMeters)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShopLocationModel && other.latitude == latitude && other.longitude == longitude && other.radiusInMeters == radiusInMeters;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode ^ radiusInMeters.hashCode;
}
