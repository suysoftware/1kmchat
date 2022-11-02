import 'dart:collection';
import 'package:firebase_database/firebase_database.dart';
import 'package:one_km_app/src/models/time_info.dart';
import 'package:one_km_app/src/models/user_message.dart';
import 'package:one_km_app/src/utils/functions.dart';

///ADD MESSAGE
//
//
Future<void> addMessage({required UserMessage messageModel}) async {
  dateTimeGetter().then((value) {
    TimeInfo timeModalNesnesi = value;

    var ref1KmData = FirebaseDatabase.instance.
        ref()
        .child("1kmdatas")
        .child(timeModalNesnesi.dayMounthYear)
        .child(timeModalNesnesi.hourToHour)
        .child(timeModalNesnesi.halfHour);

      

    var messageInfo = HashMap<String, dynamic>();
    messageInfo["user_loc_boylam"] = messageModel.userLocLongitude;
    messageInfo["user_loc_enlem"] = messageModel.userLocLatitude;
    messageInfo["user_message"] = messageModel.userMessage;
    messageInfo["user_name"] = messageModel.userName;
    messageInfo["user_message_time"] = timeModalNesnesi.allTime;
    messageInfo["user_message_timetoken"] = timeModalNesnesi.mTimeToken;
    messageInfo["user_message_title"] = messageModel.userMessageTitle;

    ref1KmData.push().set(messageInfo);
  });
}
//
//
///