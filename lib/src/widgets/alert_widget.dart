import 'package:flutter/cupertino.dart';
import 'package:one_km_app/src/constants/color_constants.dart';
import 'package:sizer/sizer.dart';

Widget alertSender({required String hata, required context}) {
  return CupertinoDialogAction(
    onPressed: () {
      Navigator.pop(context);
    },
    child: Text(
      hata,
      maxLines: 3,
      style: TextStyle(
          fontFamily: "Coderstyle",
          fontSize: 18.sp,
          color: ColorConstants.adminColor),
    ),
  );
}
