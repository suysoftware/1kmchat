import 'dart:collection';
import 'package:firebase_database/firebase_database.dart';

///
//
//
Future<void> banUser(
    String userUid, String targetName, String targetMessage) async {
  await checkBannedUser(userUid, targetName).then((value) {
    if (value == false) {
      var targetRef = FirebaseDatabase.instance
          .ref()
          .child("1kmusers")
          .child(userUid)
          .child("banned_user")
          .child(targetName);

      var bannedUser = HashMap<String, dynamic>();
      bannedUser["banned"] = targetMessage;
      targetRef.set(bannedUser);
    } else {
      var targetRef = FirebaseDatabase.instance
          .ref()
          .child("1kmusers")
          .child(userUid)
          .child("banned_user")
          .child(targetName);
      targetRef.once().then((value) {
        dynamic glnVeri = value.snapshot.value;
        if (glnVeri != null) {
          if (glnVeri["banned"] != null) {
            targetRef.child("banned").remove();
          }
        }
      });
    }
  });
}

//
//
///

///
//
//
Future<bool> checkBannedUser(String userUid, String targetName) async {
  // ignore: prefer_typing_uninitialized_variables
  var a;
  bool sonuc = false;

  var banCheckRef = FirebaseDatabase.instance
      .ref()
      .child("1kmusers")
      .child(userUid)
      .child("banned_user")
      .child(targetName)
      .child("banned");

  await banCheckRef.once().then((value) {
    a = value.snapshot.value;

    if (a != null) {
      sonuc = true;
    } else {
      sonuc = false;
    }
  });

  //true donerse kisi banli
  //false donerse kisi serbest

  return sonuc;
}

//
//
///

Future<List> bannedListGetter(
  String userUid,
) async {
  List bannedList = <String>[];

  var refBannedList = FirebaseDatabase.instance
      .ref()
      .child("1kmusers")
      .child(userUid)
      .child("banned_user");

  await refBannedList.once().then((bannedValue) {
    // ignore: avoid_function_literals_in_foreach_calls
    bannedValue.snapshot.children.forEach((element) {
      bannedList.add(element.key);
    });
  });

  return bannedList;
}
