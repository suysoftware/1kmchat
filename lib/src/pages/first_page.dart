import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:one_km_app/src/constants/color_constants.dart';
import 'package:one_km_app/src/models/server_settings.dart';
import 'package:one_km_app/src/models/user.dart';
import 'package:one_km_app/src/pages/home_page.dart';
import 'package:one_km_app/src/pages/terms_of_use.dart';
import 'package:one_km_app/src/services/authentication_service/auth_operations.dart';
import 'package:one_km_app/src/utils/badwords.dart';
import 'package:one_km_app/src/widgets/alert_widget.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class FirstPage extends StatefulWidget {
  double locLongitude;
  double locLatitude;
  ServerSettings serverSettings;

  // ignore: use_key_in_widget_constructors
  FirstPage({
    required this.locLongitude,
    required this.locLatitude,
    required this.serverSettings,
  });
  //  const FirstPage({Key? key, required this.locLongitude, required this.locLatitude}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> with TickerProviderStateMixin {
  var t1 = TextEditingController();
  late AnimationController animationController;
  late AnimationController animationController2;
  late Animation<double> alphaAnimationValue;
  late Animation<double> checkBoxOpacity;

  bool checkbox = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  checkBox() {
    if (animationController2.isCompleted) {
      // animationController2.reverse();
      animationController2.reverse();
      checkbox = false;
    } else {
      animationController2.forward();
      checkbox = true;
    }
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1200), vsync: this);
    animationController2 = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);

    alphaAnimationValue =
        Tween(begin: 0.0, end: 1.0).animate(animationController)
          ..addListener(() {
            setState(() {});
          });
    animationController.repeat(reverse: true);
    checkBoxOpacity = Tween(begin: 0.0, end: 1.0).animate(animationController2)
      ..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    animationController2.dispose();
    t1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorConstants.themeColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 2.h,
              ),
              Text(
                "Temet Nosce",
                style: TextStyle(fontFamily: "Noscefont", fontSize: 40.sp),
              ),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                width: 50.w,
                height: 5.h,
                child: CupertinoTextField(
                  style: const TextStyle(color: ColorConstants.primaryColor),
                  keyboardType: TextInputType.name,
                  maxLines: 1,
                  maxLength: 15,
                  textCapitalization: TextCapitalization.words,
                  placeholderStyle: TextStyle(
                      color: ColorConstants.primaryColor,
                      fontFamily: "Noscefont",
                      fontSize: 9.sp),
                  placeholder: "Choose Nickname",
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  cursorColor: ColorConstants.primaryColor,
                  cursorHeight: 20,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: ColorConstants.primaryColor, width: 1),
                    ),
                  ),
                  controller: t1,
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.elliptical(20.0, 0.0),
                      bottom: Radius.circular(50.0)),
                  border:
                      Border.all(color: ColorConstants.primaryColor, width: 2),
                ),
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(10.0),
                child: CupertinoButton(
                  child: Opacity(
                    opacity: alphaAnimationValue.value,
                    child: Text(
                      "Scribo\n Ergo\n Sum",
                      style: TextStyle(
                          fontFamily: "Noscefont",
                          color: ColorConstants.primaryColor,
                          fontSize: 18.sp),
                    ),
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance
                        .signInAnonymously()
                        .then((_user) {
                      if (t1.text.contains(" ")) {
                        t1.clear();
                        showCupertinoDialog(
                            useRootNavigator: true,
                            barrierDismissible: true,
                            context: context,
                            builder: (context) => alertSender(
                                hata: " Dont Use Space !", context: context));
                      } else {
                        if (t1.text.length > 3) {
                          badWordsChecker(t1.text).then((isBad) {
                            if (isBad != true) {
                              checkUserName(t1.text).then((value) async {
                                if (value == false) {
                                  showCupertinoDialog(
                                      useRootNavigator: true,
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (context) => alertSender(
                                          hata: "NAME ALREADY EXIST !!",
                                          context: context));
                                } else {
                                  if (checkbox != false) {
                                    await addUser(t1.text.toLowerCase(),
                                        auth.currentUser!.uid);

                                    UserModel _userModal = UserModel(
                                        widget.locLongitude,
                                        widget.locLatitude,
                                        t1.text.toLowerCase(),
                                        "Junior",
                                        auth.currentUser!.uid);
                                    //  bannedListGetter(auth.currentUser!.uid)
                                    //    .then((value) {
                                    var cleanBannedList = <List>[];
                                    var cleanSpamList = <List>[];
                                    var cleanSpammedList = <List>[];
                                    Navigator.pushReplacement(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) => HomePage(
                                                  userModel: _userModal,
                                                  serverSettings:
                                                      widget.serverSettings,
                                                  bannedList: cleanBannedList,
                                                  spamList: cleanSpamList,
                                                  spammedList: cleanSpammedList,
                                                )));
                                    //    });
                                  } else {
                                    showCupertinoDialog(
                                        useRootNavigator: true,
                                        barrierDismissible: true,
                                        context: context,
                                        builder: (context) => alertSender(
                                            hata: "Please agree our Terms!!",
                                            context: context));
                                  }
                                }
                              });
                            } else {
                              showCupertinoDialog(
                                  useRootNavigator: true,
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (context) => alertSender(
                                      hata: "You Can't Use Profanity!!",
                                      context: context));
                            }
                          });
                        } else {
                          t1.clear();
                          showCupertinoDialog(
                              useRootNavigator: true,
                              barrierDismissible: true,
                              context: context,
                              builder: (context) => alertSender(
                                  hata: "Short Name !", context: context));
                        }
                      }
                    });
                  },
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "I agree Terms & Conditions and Privacy Policy ",
                    style: TextStyle(fontSize: 13.sp),
                  ),
                  GestureDetector(
                    onTap: () {
                      checkBox();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          height: 6.w,
                          width: 6.w,
                          child: Container(
                              child: Opacity(
                                  opacity: checkBoxOpacity.value,
                                  child: const Icon(
                                    CupertinoIcons.check_mark,
                                    color: ColorConstants.primaryColor,
                                  )),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5.0)),
                                  border: Border.all(
                                      color: ColorConstants.primaryColor,
                                      width: 1.0)))),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const TermsOfUse(),
                ],
              ),
            ],
          ),
        ));
  }
}
