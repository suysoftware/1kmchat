class ServerSettings {
  late double juniorDistance;
  late double masterDistance;

  ServerSettings(this.juniorDistance, this.masterDistance);

  factory ServerSettings.fromJson(String key, Map<dynamic, dynamic> json) {
    return ServerSettings(
        json["junior_distance"] as double, json["master_distance"] as double);
  }
}
