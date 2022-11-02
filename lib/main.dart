import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:one_km_app/src/constants/color_constants.dart';
import 'package:one_km_app/src/pages/splash_page.dart';
import 'package:sizer/sizer.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  await init();

  runApp(const MyApp());
}

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GestureDetector(
          onTap: () {
            WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
          },
          child: const CupertinoApp(
            theme: CupertinoThemeData(
                textTheme: CupertinoTextThemeData(
                    textStyle: TextStyle(
              color: ColorConstants.primaryColor,
              fontFamily: "Coderstyle",
              fontSize: 24,
              letterSpacing: 0.3,
              wordSpacing: 0.03,
            ))),
            title: '1 KM',
            debugShowCheckedModeBanner: false,
            home: SplashPage(),
          ),
        );
      },
    );
  }
}
