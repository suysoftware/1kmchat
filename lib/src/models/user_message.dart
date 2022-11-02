class UserMessage {
  late double userLocLongitude;
  late double userLocLatitude;
  late String userMessage;
  late String userName;
  late String userMessageTime;
  late int userMessageTimeToken;
  late String userMessageTitle;
 

  UserMessage(
      this.userLocLongitude,
      this.userLocLatitude,
      this.userMessage,
      this.userName,
      this.userMessageTime,
      this.userMessageTimeToken,
      this.userMessageTitle);

  factory UserMessage.fromJson(String key, Map<dynamic, dynamic> json) {
    return UserMessage(
        json["user_loc_boylam"] as double,
        json["user_loc_enlem"] as double,
        json["user_message"] as String,
        json["user_name"] as String,
        json["user_message_time"] as String,
        json["user_message_timetoken"] as int,
        json["user_message_title"] as String);
  }
}
