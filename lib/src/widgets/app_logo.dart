import 'package:flutter/cupertino.dart';
import 'package:one_km_app/src/constants/color_constants.dart';
import 'package:sizer/sizer.dart';

// ignore: non_constant_identifier_names
Widget appLogo(double Sizex) {
  return Container(
      margin: EdgeInsets.all(8.0 * Sizex),
      padding: EdgeInsets.all(15.0 * Sizex),
      child: Text(
        "1KM",
        style: TextStyle(
            backgroundColor: ColorConstants.transparentColor,
            color: ColorConstants.primaryColor,
            fontSize: 40.sp * Sizex,
            wordSpacing: 1.7,
            letterSpacing: 1.6),
      ),
      decoration: BoxDecoration(
          border: Border.all(
              color: ColorConstants.primaryColor, width: 2 * Sizex)));
}
