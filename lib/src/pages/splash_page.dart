import 'package:flutter/cupertino.dart';
import 'package:one_km_app/src/services/authentication_service/auth_operations.dart';
import 'package:sizer/sizer.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
//  FirebaseAuth auth = FirebaseAuth.instance;
  late AnimationController animationController;
  late Animation<double> alphaAnimationValue;
  late AnimationController animationController2;
  late Animation<double> alphaAnimationValue2;

  @override
  void initState() {
    super.initState();

    authOperation(context).whenComplete(() {
      animationController.dispose();
      animationController2.dispose();
    });

    animationController = AnimationController(
        duration: const Duration(milliseconds: 2500), vsync: this);
    animationController2 = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
    alphaAnimationValue =
        Tween(begin: 0.0, end: 1.0).animate(animationController)
          ..addListener(() {
            setState(() {});
          });
    alphaAnimationValue2 =
        Tween(begin: 1.0, end: 0.2).animate(animationController2)
          ..addListener(() {
            setState(() {});
          });
    animationController2.repeat(reverse: true);
    animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CupertinoColors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 40.h,
              width: 40.w,
              child: Opacity(
                opacity: alphaAnimationValue.value,
                child: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage("assets/images/ilion_green1.png"),
                  )),
                ),
              ),
            ),
            Opacity(
              opacity: alphaAnimationValue2.value,
              child: Text(
                "Location Loading !",
                style: TextStyle(
                    color: CupertinoColors.systemGreen.withGreen(120),
                    fontFamily: "CoderStyle",
                    letterSpacing: 1.0,
                    fontSize: 16.sp),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }
}
