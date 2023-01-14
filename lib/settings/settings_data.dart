class SettingsData {
  const SettingsData({
    this.sleepDetectionTimeMs,
    this.accelerometerDifference,
  });

  final int? sleepDetectionTimeMs;
  final int? accelerometerDifference;

  Map<String, dynamic> toJson() => <String, dynamic>{
    "sleepDetectionTimeMs": sleepDetectionTimeMs,
    "accelerometerDifference": accelerometerDifference,
  };

  factory SettingsData.fromJson(Map<String, dynamic> json) =>
      SettingsData(
        sleepDetectionTimeMs: json["sleepDetectionTimeMs"],
        accelerometerDifference: json["accelerometerDifference"],
      );
}
