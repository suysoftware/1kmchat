import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one_km_app/src/constants/color_constants.dart';
import 'package:one_km_app/src/models/time_info.dart';
import 'package:sizer/sizer.dart';
import 'package:timezone/standalone.dart' as tz;

/// TIME MODEL GETTER
//
//
Future<TimeInfo> dateTimeGetter() async {
  final detroit = tz.getLocation('America/Detroit');
  final localizedDt = tz.TZDateTime.from(DateTime.now(), detroit).toString();

  var dateTime = DateTime.parse(localizedDt);
  var date0 =
      "${dateTime.day}-${dateTime.month}-${dateTime.year}||${dateTime.hour}:${dateTime.minute}:${dateTime.second}";
  var date1 = "${dateTime.day}-${dateTime.month}-${dateTime.year}";
  var date2 = "${dateTime.hour}:00-${dateTime.hour + 1}:00";
  var date3 =
      // ignore: unnecessary_string_interpolations
      "${dateTime.minute < 30 ? "${dateTime.hour}:00-${dateTime.hour}:30" : "${dateTime.hour}:30-${dateTime.hour + 1}:00"}";
  var date4 = (dateTime.millisecond) +
      (dateTime.second * 1000) +
      (dateTime.minute * 60000);

  var timeModalNesne = TimeInfo(date0, date1, date2, date3, date4);

  return timeModalNesne;
}

//
//
///

/// TEXTSTYLE GETTER
//
//

TextStyle textStyleGetter({
  required String title,
  required String targetName,
  required List textBannedList,
  required bool isName,
}) {
  if (targetName == "System" || targetName == "System ") {
    return TextStyle(
        color: ColorConstants.systemColor,
        fontFamily: "CoderStyle",
        fontSize: 14.sp,
        letterSpacing: 0.5,
        wordSpacing: 0.05,
        height: 0.8,
        fontWeight: FontWeight.normal);
  } else if (title == "Admin") {
    return TextStyle(
        color: ColorConstants.adminColor,
        fontFamily: "CoderStyle",
        fontSize: 19.sp,
        letterSpacing: 0.5,
        wordSpacing: 0.05,
        height: 0.8,
        fontWeight: FontWeight.bold);
  } else {
    if (isName == true) {
      if (title == "Master") {
        return TextStyle(
            color: ColorConstants.masterColor,
            fontFamily: "CoderStyle",
            fontSize: 17.sp,
            letterSpacing: 0.5,
            wordSpacing: 0.05,
            height: 0.8,
            fontWeight: FontWeight.bold);
      } else {
        return TextStyle(
            color: ColorConstants.juniorColor.withRed(40),
            fontFamily: "CoderStyle",
            fontSize: 17.sp,
            letterSpacing: 0.5,
            wordSpacing: 0.05,
            height: 0.8,
            fontWeight: FontWeight.bold);
      }
    } else {
      if (textBannedList.contains(targetName) == true) {
        return TextStyle(
          color: ColorConstants.juniorColor.withRed(40),
          fontFamily: "MatrixCodeMix",
          fontSize: 12.sp,
          letterSpacing: 0.5,
          wordSpacing: 0.03,
        );
      } else {
        return TextStyle(
            color: ColorConstants.juniorColor.withRed(40),
            fontFamily: "CoderStyle",
            fontSize: 18.sp,
            letterSpacing: 0.5,
            wordSpacing: 0.05,
            height: 0.8);
      }
    }
  }
}
//
//
///


