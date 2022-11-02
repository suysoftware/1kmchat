import 'package:flutter/cupertino.dart';
import 'package:one_km_app/src/utils/functions.dart';

Widget textWidgetGetter(BuildContext context,{required String targetMessage,required String targetName,required,required List textBannedList,required String targetTitle }) {
      return RichText(
        text: TextSpan(
     
          children: [
            TextSpan(
                text: "$targetName: ",
            style: textStyleGetter(title: targetTitle, targetName: targetName, textBannedList: textBannedList, isName: true)),
            TextSpan(
              text: targetMessage,
              style: textStyleGetter(title: targetTitle, targetName: targetName, textBannedList: textBannedList, isName: false)
            ),
         
          ]
        )
      );
    }
