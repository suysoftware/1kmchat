class UserModel {
  late double userLocLongitude;
  late double userLocLatitude;
  late String userName;
  late String userTitle;
  late String userUid;

  UserModel(this.userLocLongitude, this.userLocLatitude, this.userName,
      this.userTitle, this.userUid);

  factory UserModel.fromJson(String key, Map<dynamic, dynamic> json) {
    return UserModel(
        json["user_loc_boylam"] as double,
        json["user_loc_enlem"] as double,
        json["user_name"] as String,
        json["user_title"] as String,
        json["user_uid"] as String);
  }
}
