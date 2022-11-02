import 'dart:collection';
import 'package:firebase_database/firebase_database.dart';

Future<void> spamListAdder(
    {required String userUid,
    required String userName,
    required String targetName,
    required String message}) async {
  var refSpamList = FirebaseDatabase.instance
      .ref()
      .child("1kmspamlist")
      .child("$targetName/$userName");
  var refBaseSpamTarget = FirebaseDatabase.instance
      .ref()
      .child("1kmusers")
      .child(userUid)
      .child("spammed_user")
      .child(targetName);

  var spamInfo = HashMap<String, dynamic>();
  spamInfo[userUid] = message;
  var spamBase = HashMap<String, dynamic>();
  spamBase["spammed"] = message;

  refSpamList.set(spamInfo);
  refBaseSpamTarget.set(spamBase);
}

Future<List> spamListGetter(
  String userName,
) async {
  List spamList = <String>[];

  var refBannedList =
      FirebaseDatabase.instance.ref().child("1kmspamlist").child(userName);

  await refBannedList.once().then((spamValue) {
    // ignore: avoid_function_literals_in_foreach_calls
    spamValue.snapshot.children.forEach((element) {
      spamList.add(element.key);
    });
  });

  return spamList;
}

///
//
//
Future<bool> checkSpammedUser(String userUid, String targetName) async {
  // ignore: prefer_typing_uninitialized_variables
  var a;
  bool sonuc = false;

  var banCheckRef = FirebaseDatabase.instance
      .ref()
      .child("1kmusers")
      .child(userUid)
      .child("spammed_user")
      .child(targetName)
      .child("spammed");

  await banCheckRef.once().then((value) {
    a = value.snapshot.value;

    if (a != null) {
      sonuc = true;
    } else {
      sonuc = false;
    }
  });

  //true donerse kisi spamli
  //false donerse kisi serbest

  return sonuc;
}

//
//
///

Future<List> spammedListGetter(
  String userUid,
) async {
  List spammedList = <String>[];

  var refBannedList = FirebaseDatabase.instance
      .ref()
      .child("1kmusers")
      .child(userUid)
      .child("spammed_user");

  await refBannedList.once().then((bannedValue) {
    // ignore: avoid_function_literals_in_foreach_calls
    bannedValue.snapshot.children.forEach((element) {
      spammedList.add(element.key);
    });
  });

  return spammedList;
}
