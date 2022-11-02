// ignore_for_file: prefer_typing_uninitialized_variables
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_km_app/src/constants/color_constants.dart';
import 'package:one_km_app/src/models/server_settings.dart';
import 'package:one_km_app/src/models/time_info.dart';
import 'package:one_km_app/src/models/user.dart';
import 'package:one_km_app/src/models/user_message.dart';
import 'package:one_km_app/src/pages/rules_and_info.dart';
import 'package:one_km_app/src/services/authentication_service/banned_operations.dart';
import 'package:one_km_app/src/services/authentication_service/spam_operation.dart';
import 'package:one_km_app/src/services/location_service/location_operations.dart';
import 'package:one_km_app/src/services/storage_service/storage_operations.dart';
import 'package:one_km_app/src/utils/badwords.dart';
import 'package:one_km_app/src/utils/functions.dart';
import 'package:one_km_app/src/widgets/alert_widget.dart';
import 'package:one_km_app/src/widgets/alert_with_ask_widget.dart';
import 'package:one_km_app/src/widgets/app_logo.dart';
import 'package:one_km_app/src/widgets/message_text.dart';
import 'package:sizer/sizer.dart';
import 'package:timezone/standalone.dart' as tz;
import 'package:connectivity/connectivity.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  UserModel userModel;
  ServerSettings serverSettings;
  List bannedList;
  List spammedList;
  List spamList;
  HomePage(
      {Key? key,
      required this.userModel,
      required this.serverSettings,
      required this.bannedList,
      required this.spamList,
      required this.spammedList})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  late UserModel _userModel;

  // ignore: unused_field
  String _connectionStatus = 'Unknown';
  bool _connectionBool = true;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  late var date1;
  late var date2;
  late var date3;
  late var detroit;
  late var localizedDt;
  late var dateTime;

  int buttonLimit = 0;
  bool yirmiSaniyeAcikMi = false;
  bool donguTek = true;
  bool adminMuted = false;
  bool firstJoined = true;
  int banlamaSayi = 0;
  bool banlamaAcikMi = false;

  late var _refKmData;
  var t1 = TextEditingController();

  final ScrollController listScrollController = ScrollController();

  FirebaseAuth auth = FirebaseAuth.instance;

  bool joinRoom = false;
  joinRoomMessage() {
    if (joinRoom == true) {
      UserMessage messageModel = UserMessage(
          widget.userModel.userLocLongitude,
          widget.userModel.userLocLatitude,
          "${widget.userModel.userName} joined the room",
          "System ",
          "10",
          10,
          "System ");

      addMessage(messageModel: messageModel);
      joinRoom = false;
      firstJoined = false;
    }
  }

  Future<void> buttonLimitReset() async {
    if (yirmiSaniyeAcikMi == false) {
      Future.delayed(const Duration(milliseconds: 20000), () {
        buttonLimit = 0;
        yirmiSaniyeAcikMi = false;
        donguTek = true;
      });
    }
  }

  void yenileBakem() {
    detroit = tz.getLocation('America/Detroit');
    localizedDt = tz.TZDateTime.from(DateTime.now(), detroit).toString();
    dateTime = DateTime.parse(localizedDt);

    date1 = "${dateTime.day}-${dateTime.month}-${dateTime.year}";
    date2 = "${dateTime.hour}:00-${dateTime.hour + 1}:00";
    date3 =
        // ignore: unnecessary_string_interpolations
        "${dateTime.minute < 30 ? "${dateTime.hour}:00-${dateTime.hour}:30" : "${dateTime.hour}:30-${dateTime.hour + 1}:00"}";

    FirebaseDatabase _refConnect = FirebaseDatabase.instance;

    _refKmData = _refConnect
        .ref()
        .child("1kmdatas")
        .child(date1)
        .child(date2)
        .child(date3);
  }

  @override
  void initState() {
    super.initState();

    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    if (firstJoined == true) {
      joinRoom = true;
      joinRoomMessage();
      firstJoined = false;
    }

    yenileBakem();

    _userModel = widget.userModel;
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();

    listScrollController.dispose();
    t1.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      //uygulamalar arası geçişte
      //yukarıdan saati çekince
      //diger yukarıdan çekilen sürgü ile

    }

    if (state == AppLifecycleState.paused) {
      // altta atıldı
      firstJoined = true;
    }

    if (state == AppLifecycleState.resumed) {
      //alta atıp geri gelince
      if (firstJoined == true) {
        joinRoom = true;
        joinRoomMessage();
      }
    }

    if (state == AppLifecycleState.detached) {}
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: ColorConstants.themeColor,
        child: _connectionBool == true
            ? Column(
                children: [
                  SizedBox(
                    height: 3.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return RulesAndInfo(
                              mdFileName: 'rules_and_info.md',
                            );
                          });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: appLogo(1),
                    ),
                  ),
                  StreamBuilder<dynamic>(
                      stream: _refKmData.onValue,
                      builder: (context, event) {
                        if (event.hasData) {
                          var messageDatas = <UserMessage>[];

                          var gettingMessages = event.data.snapshot.value;

                          if (gettingMessages != null) {
                            gettingMessages.forEach((key, nesne) {
                              var comingMessage =
                                  UserMessage.fromJson(key, nesne);

                              bool kmWho = checkLocationDis(
                                  _userModel.userLocLatitude,
                                  _userModel.userLocLongitude,
                                  comingMessage.userLocLatitude,
                                  comingMessage.userLocLongitude,
                                  comingMessage.userMessageTitle,
                                  widget.serverSettings);

                              if (kmWho) {
                                if (widget.spamList
                                        .contains(comingMessage.userName) ==
                                    false) {
                                  if (widget.spammedList
                                          .contains(comingMessage.userName) ==
                                      false) {
                                    if (comingMessage.userName == "System") {
                                      if (comingMessage.userMessage.startsWith(
                                              widget.userModel.userName) ==
                                          true) {
                                        String bannedFrom = comingMessage
                                            .userMessage
                                            .substring(widget
                                                    .userModel.userName.length +
                                                12);
                                        widget.spamList.add(bannedFrom);
                                      } else {
                                        messageDatas.add(comingMessage);
                                      }
                                    } else if (comingMessage.userMessageTitle ==
                                            "Admin" ||
                                        comingMessage.userMessageTitle ==
                                            "Master") {
                                      if (comingMessage.userMessage.startsWith(
                                                  "-${widget.userModel.userName}") ==
                                              true &&
                                          comingMessage.userMessage
                                                  .endsWith("mute") ==
                                              true) {
                                        ///
                                        ///
                                        messageDatas.add(comingMessage);
                                        messageDatas.sort((b, a) => a
                                            .userMessageTimeToken
                                            .toInt()
                                            .compareTo(b.userMessageTimeToken));
                                        if (messageDatas.first ==
                                            comingMessage) {
                                          adminMuted = true;
                                        }

                                        ////
                                      } else if (comingMessage.userMessage
                                                  .startsWith(
                                                      "-${widget.userModel.userName}") ==
                                              true &&
                                          comingMessage.userMessage
                                                  .endsWith("undo") ==
                                              true) {
                                        ///
                                        ///

                                        messageDatas.add(comingMessage);
                                        messageDatas.sort((b, a) => a
                                            .userMessageTimeToken
                                            .toInt()
                                            .compareTo(b.userMessageTimeToken));
                                        if (messageDatas.first ==
                                            comingMessage) {
                                          adminMuted = false;
                                        }

                                        ////
                                      } else {
                                        messageDatas.add(comingMessage);
                                      }
                                    } else {
                                      messageDatas.add(comingMessage);
                                    }
                                  }
                                }
                              }
                              if (donguTek == true) {
                                if (buttonLimit == 20) {
                                  var errorMes = UserMessage(
                                      1.1,
                                      1.1,
                                      "Flood Error : Wait 1 Minutes",
                                      "Panel: ",
                                      "1",
                                      9999999999999,
                                      "Admin");
                                  messageDatas.add(errorMes);
                                  buttonLimitReset();
                                  yirmiSaniyeAcikMi = true;
                                  donguTek = false;
                                }
                              }

                              messageDatas.sort((b, a) => a.userMessageTimeToken
                                  .toInt()
                                  .compareTo(b.userMessageTimeToken));
                            });
                          }
                          return Flexible(
                            child: ListView.builder(
                                reverse: true,
                                padding: const EdgeInsets.all(8.0),
                                dragStartBehavior:
                                    DragStartBehavior.values.last,
                                keyboardDismissBehavior:
                                    ScrollViewKeyboardDismissBehavior
                                        .values.last,
                                itemCount: messageDatas.length,
                                itemBuilder: (context, indeks) {
                                  var message = messageDatas[indeks];
                                  return GestureDetector(
                                    child: Padding(
                                      padding: EdgeInsets.all(1.h),
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onDoubleTap: () {
                                              if (message.userMessageTitle != "System" &&
                                                  message.userMessageTitle !=
                                                      "Admin" &&
                                                  message.userMessageTitle !=
                                                      "Master" &&
                                                  message.userName !=
                                                      "System ") {
                                                if (message.userName !=
                                                    widget.userModel.userName) {
                                                  showCupertinoDialog(
                                                      useRootNavigator: true,
                                                      barrierDismissible: true,
                                                      context: context,
                                                      builder: (context) =>
                                                          alertWithAsk(
                                                              question:
                                                                  "Do you want Spam and Block ?\n => ${message.userName} <= ",
                                                              context: context,
                                                              answer1: "Yes",
                                                              answer2: "NO",
                                                              targetName:
                                                                  message
                                                                      .userName,
                                                              yesFunc: () {
                                                                spamListAdder(
                                                                  message: message
                                                                      .userMessage,
                                                                  targetName:
                                                                      message
                                                                          .userName,
                                                                  userName: widget
                                                                      .userModel
                                                                      .userName,
                                                                  userUid: widget
                                                                      .userModel
                                                                      .userUid,
                                                                );

                                                                if (widget
                                                                        .spammedList
                                                                        .contains(
                                                                            message.userName) ==
                                                                    true) {
                                                                  widget
                                                                      .spammedList
                                                                      .remove(message
                                                                          .userName);
                                                                } else {
                                                                  widget
                                                                      .spammedList
                                                                      .add(message
                                                                          .userName);

                                                                  UserMessage spamMessage = UserMessage(
                                                                      widget
                                                                          .userModel
                                                                          .userLocLongitude,
                                                                      widget
                                                                          .userModel
                                                                          .userLocLatitude,
                                                                      "${message.userName} block from ${widget.userModel.userName}",
                                                                      "System",
                                                                      " ",
                                                                      10,
                                                                      "Admin");
                                                                  addMessage(
                                                                      messageModel:
                                                                          spamMessage);
                                                                }
                                                              },
                                                              noFunc: () {
                                                                Navigator.pop(
                                                                    context);
                                                              }));
                                                }
                                              } else {}
                                            },
                                            onLongPress: () {
                                              if (message.userMessageTitle != "System" &&
                                                  message.userMessageTitle !=
                                                      "Admin" &&
                                                  message.userMessageTitle !=
                                                      "Master" &&
                                                  message.userName !=
                                                      "System ") {
                                                if (message.userName !=
                                                    widget.userModel.userName) {
                                                  banUser(
                                                      widget.userModel.userUid,
                                                      message.userName,
                                                      message.userMessage);
                                                  if (widget.bannedList
                                                          .contains(message
                                                              .userName) ==
                                                      true) {
                                                    widget.bannedList.remove(
                                                        message.userName);
                                                  } else {
                                                    widget.bannedList
                                                        .add(message.userName);
                                                  }
                                                }
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  child: Card(
                                                    margin: EdgeInsets.zero,
                                                    color: ColorConstants
                                                        .transparentColor,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              1.0),
                                                      child: textWidgetGetter(
                                                          context,
                                                          targetMessage: message
                                                              .userMessage,
                                                          targetName:
                                                              message.userName,
                                                          textBannedList:
                                                              widget.bannedList,
                                                          targetTitle: message
                                                              .userMessageTitle),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          );
                        } else {
                          return const Center(child: Text("Lost Connection"));
                        }
                      }),
                  SizedBox(
                    height: 13.h,
                    width: 100.w,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: CupertinoTextField(
                                  autofocus: true,
                                  style: textStyleGetter(
                                    targetName: widget.userModel.userName,
                                    title: widget.userModel.userTitle,
                                    textBannedList: widget.bannedList,
                                    isName: true,
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 3,
                                  maxLength: 99,
                                  showCursor: true,
                                  padding:
                                      EdgeInsets.fromLTRB(2.w, 1.w, 1.w, 1.w),
                                  cursorColor: CupertinoColors.activeGreen,
                                  cursorHeight: 3.h,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                          color: ColorConstants.primaryColor,
                                          width: 1),
                                    ),
                                  ),
                                  controller: t1,
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: CupertinoButton(
                                    child: SizedBox(
                                        width: 8.w,
                                        height: 8.w,
                                        child: Image.asset(
                                          "assets/images/white_rabbit.png",
                                          color: ColorConstants.primaryColor,
                                        )),
                                    onPressed: () {
                                      if (adminMuted != true) {
                                        if (yirmiSaniyeAcikMi != true) {
                                          badWordsChecker(t1.text)
                                              .then((isBad) {
                                            if (isBad != true) {
                                              var messageModel = UserMessage(
                                                  widget.userModel
                                                      .userLocLongitude,
                                                  widget.userModel
                                                      .userLocLatitude,
                                                  t1.text,
                                                  widget.userModel.userName,
                                                  " ",
                                                  10,
                                                  widget.userModel.userTitle);

                                              addMessage(
                                                  messageModel: messageModel);

                                              var newTimeModel;
                                              dateTimeGetter().then((value) {
                                                newTimeModel = value;
                                                TimeInfo aga = newTimeModel;

                                                if (newTimeModel != null) {
                                                  _refKmData = FirebaseDatabase
                                                      .instance
                                                      .ref()
                                                      .child("1kmdatas")
                                                      .child(aga.dayMounthYear)
                                                      .child(aga.hourToHour)
                                                      .child(aga.halfHour);
                                                }
                                              });
                                              setState(() {
                                                buttonLimit = buttonLimit + 1;
                                                _refKmData = _refKmData;
                                              });

                                              t1.clear();
                                            } else {
                                              t1.clear();
                                              showCupertinoDialog(
                                                  context: context,
                                                  builder: (context) => alertSender(
                                                      hata:
                                                          "You can't use profanity ",
                                                      context: context));
                                            }
                                          });
                                        } else {
                                          t1.clear();
                                        }
                                      } else {
                                        t1.clear();
                                        showCupertinoDialog(
                                            context: context,
                                            builder: (context) => alertSender(
                                                hata: "You Muted",
                                                context: context));
                                      }
                                    },
                                  ))
                            ],
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: ColorConstants.primaryColor, width: 3),
                          borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(50.0))),
                    ),
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Lost Internet Connection"),
                    Padding(
                      padding: EdgeInsets.all(5.h),
                      child: CupertinoActivityIndicator(
                        animating: true,
                        radius: 15.sp,
                      ),
                    ),
                    const Text("Please Wait"),
                  ],
                ),
              ));
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        //  setState(() => _connectionStatus = result.toString());
        if (_connectionBool != true) {
          setState(() {
            _connectionBool = true;
          });
        }

        break;
      case ConnectivityResult.none:
        if (_connectionBool != false) {
          setState(() {
            _connectionBool = false;
          });
        }

        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');

        break;
    }
  }
}
