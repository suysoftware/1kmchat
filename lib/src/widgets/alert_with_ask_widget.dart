import 'package:flutter/cupertino.dart';
import 'package:one_km_app/src/constants/color_constants.dart';
import 'package:sizer/sizer.dart';

Widget alertWithAsk(
    {required String question,
    required context,
    required String answer1,
    required String answer2,
    required String targetName,
    required Function() yesFunc,
    required Function() noFunc}) {
  return CupertinoAlertDialog(
    content: Text(
      question,
      style: TextStyle(
          color: ColorConstants.themeColor,
          fontFamily: "CoderStyle",
          fontSize: 17.sp),
    ),
    actions: [
      CupertinoButton(
          child: Text(
            answer1,
            style: const TextStyle(color: ColorConstants.adminColor),
          ),
          onPressed: () async {
            yesFunc();
            Navigator.pop(context);
          }),
      CupertinoButton(
          child: Text(
            answer2,
            style: const TextStyle(color: ColorConstants.themeColor),
          ),
          onPressed: noFunc)
    ],
  );
}
