import 'dart:collection';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:one_km_app/src/models/server_settings.dart';
import 'package:one_km_app/src/models/user.dart';
import 'package:one_km_app/src/pages/first_page.dart';
import 'package:one_km_app/src/pages/home_page.dart';
import 'package:one_km_app/src/services/authentication_service/banned_operations.dart';
import 'package:one_km_app/src/services/authentication_service/spam_operation.dart';
import 'package:one_km_app/src/services/location_service/location_operations.dart';

///ADD USER
//
//
//
Future<void> addUser(String name, String uid) async {
  var ref1Km = FirebaseDatabase.instance.ref().child("1kmusers").child(uid);
  var refAllUser =
      FirebaseDatabase.instance.ref().child("allusers").child(name);

  var userInfo = HashMap<String, dynamic>();

  userInfo["user_name"] = name;
  userInfo["user_uid"] = uid;
  userInfo["user_title"] = "Junior";

  var alluser = HashMap<String, dynamic>();
  alluser["exist"] = "yes";

  ref1Km.set(userInfo);
  refAllUser.set(alluser);
}
//
//
///

///CHECK USERNAME (exist or no)
//
//
Future<bool> checkUserName(String name) async {
  // ignore: prefer_typing_uninitialized_variables
  var a;
  bool sonuc = false;

  var refAllUser = FirebaseDatabase.instance.ref().child("allusers/$name");

  await refAllUser.once().then((value) {
    a = value.snapshot.value;

    if (a != null) {
      sonuc = false;
    } else {
      sonuc = true;
    }
  });

  return sonuc;
}
//
//
///

Future<ServerSettings> settingsGetter() async {
  var refSetting = FirebaseDatabase.instance.ref().child("ServerSettings");

  dynamic comingValue;
  await refSetting.once().then((value) => comingValue = value.snapshot.value);
  var serverSettings = ServerSettings(
      comingValue["junior_distance"], comingValue["master_distance"]);

  return serverSettings;
}

///AUTH OPERATIONS
//
//

/*
{
 "rules": {
 ".read": "auth != null",
 ".write": "auth != null"
 }
}
*/
//

Future<void> authOperation(context) async {
  late UserModel konumInfo;
  late ServerSettings serverSetting;

  await getLocation(name: "d", uid: "").then((value) => konumInfo = value);
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    await settingsGetter().then((value) => serverSetting = value);

    var ref1KmUser =
        FirebaseDatabase.instance.ref().child("1kmusers").child(user.uid);

    try {
      await ref1KmUser.once().then((value) {
        dynamic glnVeri = value.snapshot.value;
        if (glnVeri != null) {
          UserModel infoUserGenel = UserModel(
              konumInfo.userLocLongitude,
              konumInfo.userLocLatitude,
              glnVeri["user_name"],
              glnVeri["user_title"],
              glnVeri["user_uid"]);
          bannedListGetter(infoUserGenel.userUid).then((bannedValue) {
            spamListGetter(infoUserGenel.userName).then((spamValue) {
              spammedListGetter(infoUserGenel.userUid).then((spammedValue) {
                Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => HomePage(
                              userModel: infoUserGenel,
                              serverSettings: serverSetting,
                              bannedList: bannedValue,
                              spamList: spamValue,
                              spammedList: spammedValue,
                            )));
              });
            });
          });
        } else {
          settingsGetter().then((value) => serverSetting = value);
          Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                  builder: (context) => FirstPage(
                        locLongitude: konumInfo.userLocLongitude,
                        locLatitude: konumInfo.userLocLatitude,
                        serverSettings: serverSetting,
                      )));
        }
      });
    } catch (e) {
      settingsGetter().then((value) => serverSetting = value);
      Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
              builder: (context) => FirstPage(
                    locLongitude: konumInfo.userLocLongitude,
                    locLatitude: konumInfo.userLocLatitude,
                    serverSettings: serverSetting,
                  )));
    }
  } else {
    await settingsGetter().then((value) => serverSetting = value);
    Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
            builder: (context) => FirstPage(
                  locLongitude: konumInfo.userLocLongitude,
                  locLatitude: konumInfo.userLocLatitude,
                  serverSettings: serverSetting,
                )));
  }
}
//
//
///