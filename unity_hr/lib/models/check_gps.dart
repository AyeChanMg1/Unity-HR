class CheckGPS {
  double radius;
  bool validity;
  CheckGPS({required this.radius, required this.validity});

  factory CheckGPS.fromJson(Map<String, dynamic> json) {
    return CheckGPS(
      radius: json['radius'] ?? 0.0,
      validity: json['false'] ?? false,
    );
  }
}
