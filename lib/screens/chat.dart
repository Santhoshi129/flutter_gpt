import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:chat_diffusion_app/models/message.dart';
import 'package:chat_diffusion_app/models/user.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:nb_utils/nb_utils.dart';

import '../services/gpt.dart';
import 'components/image.dart';

bool isIdle = true;
String currentModel = "Text";
List<String> allModels = ['Text', "Image"];
List<Message> allMessages = [];
List<int> allNumbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
String currentStreamId = "";
User user = User(
  profile:
      "https://64.media.tumblr.com/8b0a2591ed06055a19fad6c0368b8673/tumblr_p71pwuYZWp1sn3ne4o2_500.jpg",
  userId: "abhioshekpaul189",
  userName: "Abhishek Paul",
);

bool isSpeaking = false;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ScrollController scrollController = ScrollController();
  TextEditingController controller = TextEditingController();
  FlutterTts tts = FlutterTts();

  @override
  void initState() {
    isIdle = true;
    isSpeaking = false;
    allMessages.add(
      Message(
        timestamp: DateTime.now(),
        message:
            "Hello My Name Is Mr.Diffusion,I'm A.I Powered GPT & Diffusion Model How Can I Assist You...",
        type: "message",
        userId: "mrdiffusion",
        userName: "Mr.Diffusion",
        profile:
            "https://images.nightcafe.studio/jobs/UwrQulFZ3SRSsflDNpfQ/UwrQulFZ3SRSsflDNpfQ--1--xg50i.jpg?tr=w-1600,c-at_max",
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    TextStyle chatTextStyle() {
      return GoogleFonts.poppins(
        color: context.theme.secondaryHeaderColor,
      );
    }

    void scrollBottom() {
      scrollController.jumpToBottom();
    }

    TextStyle dateTimeStyle() {
      return GoogleFonts.poppins(
        color: context.theme.secondaryHeaderColor.withOpacity(0.4),
        fontSize: height * 0.021,
      );
    }

    Widget animatedMessageReplyWidget(Message message) {
      return SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: height * 0.03,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: width * 0.02,
                ),
                ClipRRect(
                  borderRadius: radius(height * 0.1),
                  child: Image.network(
                    message.profile ?? "",
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset("profile.png");
                    },
                    width: width * 0.052,
                    height: height * 0.06,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: width * 0.01,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Container(
                      constraints: BoxConstraints(
                        minWidth: 0,
                        maxWidth: width * 0.55,
                      ),
                      decoration: BoxDecoration(
                        color: context.theme.highlightColor,
                        borderRadius: BorderRadius.only(
                          topLeft: radiusCircular(height * 0.005),
                          topRight: radiusCircular(height * 0.03),
                          bottomLeft: radiusCircular(height * 0.03),
                          bottomRight: radiusCircular(height * 0.03),
                        ),
                      ),
                      child: IntrinsicWidth(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: height * 0.015,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: width * 0.015,
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                    minWidth: 0,
                                    maxWidth: width * 0.5,
                                  ),
                                  child: AnimatedTextKit(
                                    onNext: (index, status) {
                                      scrollController.jumpToBottom();
                                      setState(() {});
                                    },
                                    onNextBeforePause: (index, status) {
                                      scrollController.jumpToBottom();
                                      setState(() {});
                                    },
                                    totalRepeatCount: 1,
                                    animatedTexts: [
                                      TypewriterAnimatedText(
                                        message.message,
                                        textStyle: chatTextStyle(),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.01,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.04,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  SizedBox(
                                    child: InkWell(
                                      onTap: () async {
                                        Message newMessage = Message(
                                          timestamp: DateTime.now(),
                                          type: message.type,
                                          userId: user.userId,
                                          userName: user.userName,
                                          message: message.message,
                                          profile: user.profile,
                                        );
                                        var reply =
                                            await getMessage(newMessage);
                                        if (message.type == "message") {
                                          isIdle = true;
                                        }
                                        if (reply != null) {
                                          setState(() {
                                            allMessages.add(reply);
                                          });
                                        }
                                      },
                                      child: Tooltip(
                                        message: "Continue",
                                        child: Icon(
                                          Icons.play_circle_fill_outlined,
                                          size: height * 0.03,
                                          color: context
                                              .theme.secondaryHeaderColor
                                              .withOpacity(0.4),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  SizedBox(
                                    child: InkWell(
                                      onTap: () async {
                                        await Clipboard.setData(ClipboardData(
                                            text: message.message));
                                      },
                                      child: Tooltip(
                                        message: "Copy",
                                        child: Icon(
                                          Icons.copy_outlined,
                                          size: height * 0.025,
                                          color: context
                                              .theme.secondaryHeaderColor
                                              .withOpacity(0.4),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  SizedBox(
                                    child: InkWell(
                                      onTap: () async {
                                        try {
                                          if (!isSpeaking) {
                                            isSpeaking = true;
                                            tts.speak(message.message);
                                          } else {
                                            await tts.stop();
                                          }
                                        } catch (error) {}
                                      },
                                      child: Tooltip(
                                        message: "Speak",
                                        child: Icon(
                                          HeroIcons.speaker_wave,
                                          size: height * 0.025,
                                          color: context
                                              .theme.secondaryHeaderColor
                                              .withOpacity(0.4),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.015,
                                  ),
                                  Text(
                                    "${allNumbers.contains(message.timestamp.hour) ? '0${message.timestamp.hour}' : message.timestamp.hour}:${allNumbers.contains(message.timestamp.minute) ? '0${message.timestamp.minute}' : message.timestamp.minute}",
                                    style: dateTimeStyle(),
                                  ),
                                  SizedBox(
                                    width: width * 0.022,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height * 0.015,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: height * 0.02,
            ),
          ],
        ),
      );
    }

    Widget messageReplyCompoent(Message message) {
      return SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: height * 0.03,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: width * 0.02,
                ),
                ClipRRect(
                  borderRadius: radius(height * 0.1),
                  child: Image.network(
                    message.profile ?? "",
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset("profile.png");
                    },
                    width: width * 0.052,
                    height: height * 0.06,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: width * 0.01,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Container(
                      constraints: BoxConstraints(
                        minWidth: 0,
                        maxWidth: width * 0.55,
                      ),
                      decoration: BoxDecoration(
                        color: context.theme.highlightColor,
                        borderRadius: BorderRadius.only(
                          topLeft: radiusCircular(height * 0.005),
                          topRight: radiusCircular(height * 0.03),
                          bottomLeft: radiusCircular(height * 0.03),
                          bottomRight: radiusCircular(height * 0.03),
                        ),
                      ),
                      child: IntrinsicWidth(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: height * 0.015,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: width * 0.015,
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                    minWidth: 0,
                                    maxWidth: width * 0.5,
                                  ),
                                  child: Text(
                                    message.message,
                                    style: chatTextStyle(),
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.01,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.04,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  SizedBox(
                                    child: Icon(
                                      HeroIcons.speaker_wave,
                                      size: height * 0.03,
                                      color: context.theme.secondaryHeaderColor
                                          .withOpacity(0.4),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.015,
                                  ),
                                  Text(
                                    "${allNumbers.contains(message.timestamp.hour) ? '0${message.timestamp.hour}' : message.timestamp.hour}:${allNumbers.contains(message.timestamp.minute) ? '0${message.timestamp.minute}' : message.timestamp.minute}",
                                    style: dateTimeStyle(),
                                  ),
                                  SizedBox(
                                    width: width * 0.022,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height * 0.015,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: height * 0.02,
            ),
          ],
        ),
      );
    }

    Widget imageReplyCompoent(Message message) {
      return SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: height * 0.03,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: width * 0.02,
                ),
                ClipRRect(
                  borderRadius: radius(height * 0.1),
                  child: Image.network(
                    message.profile ?? "",
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset("profile.png");
                    },
                    width: width * 0.052,
                    height: height * 0.06,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: width * 0.01,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.03,
                    ),
                    ClipRRect(
                      borderRadius: radius(height * 0.03),
                      child: ImageStreamComponent(
                        message: message,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: height * 0.02,
            ),
          ],
        ),
      );
    }

    Widget sendMessageCompoent(Message message) {
      return SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: height * 0.03,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Container(
                      constraints: BoxConstraints(
                        minWidth: 0,
                        maxWidth: width * 0.55,
                      ),
                      decoration: BoxDecoration(
                        color: context.theme.highlightColor,
                        borderRadius: BorderRadius.only(
                          topLeft: radiusCircular(height * 0.005),
                          topRight: radiusCircular(height * 0.03),
                          bottomLeft: radiusCircular(height * 0.03),
                          bottomRight: radiusCircular(height * 0.03),
                        ),
                      ),
                      child: IntrinsicWidth(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: height * 0.015,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: width * 0.015,
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                    minWidth: 0,
                                    maxWidth: width * 0.5,
                                  ),
                                  child: Text(
                                    message.message,
                                    style: chatTextStyle(),
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.01,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.04,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  SizedBox(
                                    child: Icon(
                                      HeroIcons.speaker_wave,
                                      size: height * 0.03,
                                      color: context.theme.secondaryHeaderColor
                                          .withOpacity(0.4),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.015,
                                  ),
                                  Text(
                                    "${allNumbers.contains(message.timestamp.hour) ? '0${message.timestamp.hour}' : message.timestamp.hour}:${allNumbers.contains(message.timestamp.minute) ? '0${message.timestamp.minute}' : message.timestamp.minute}",
                                    style: dateTimeStyle(),
                                  ),
                                  SizedBox(
                                    width: width * 0.022,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height * 0.015,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: width * 0.02,
                ),
                ClipRRect(
                  borderRadius: radius(height * 0.1),
                  child: Image.network(
                    message.profile ?? "",
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset("profile.png");
                    },
                    width: width * 0.052,
                    height: height * 0.06,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: width * 0.01,
                ),
              ],
            ),
            SizedBox(
              height: height * 0.02,
            ),
          ],
        ),
      );
    }

    void showWarn(dynamic message) {
      CherryToast.warning(
        backgroundColor: context.theme.primaryColor,
        title: Text(
          "",
          style: chatTextStyle(),
        ),
        displayTitle: false,
        description: Text(
          message.toString(),
          overflow: TextOverflow.ellipsis,
          maxLines: 5,
          style: chatTextStyle(),
        ),
      ).show(context);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => scrollBottom());
    return Scaffold(
      body: Container(
        color: context.primaryColor,
        width: width,
        height: height,
        child: Column(
          children: [
            Container(
              color: context.primaryColor,
              width: width,
              height: height * 0.855,
              child: ListView.builder(
                controller: scrollController,
                itemCount: allMessages.length,
                reverse: false,
                itemBuilder: (context, index) {
                  if (allMessages[index].userId != user.userId) {
                    if (allMessages[index].type == "message") {
                      if (allMessages.length == index + 1 ||
                          allMessages.length == index) {
                        return animatedMessageReplyWidget(allMessages[index]);
                      } else {
                        return messageReplyCompoent(allMessages[index]);
                      }
                    } else if (allMessages[index].type == "image") {
                      return imageReplyCompoent(allMessages[index]);
                    }
                  } else {
                    return sendMessageCompoent(allMessages[index]);
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              width: width,
              height: height * 0.13,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: width * 0.9,
                    height: height * 0.12,
                    decoration: BoxDecoration(
                      color: context.theme.highlightColor,
                      borderRadius: radius(
                        height * 0.03,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: width * 0.65,
                          height: height * 0.08,
                          color: context.theme.highlightColor,
                          child: AppTextField(
                            controller: controller,
                            textFieldType: TextFieldType.MULTILINE,
                            cursorColor: context.cardColor,
                            textStyle: chatTextStyle(),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter Message...",
                              hintStyle: chatTextStyle(),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.01,
                        ),
                        SizedBox(
                          width: width * 0.12,
                          height: height * 0.07,
                          child: AnimatedToggleSwitch.rolling(
                            current: currentModel,
                            values: allModels,
                            onChanged: (model) {
                              currentModel = model.toString();
                              setState(() {});
                            },
                            iconBuilder: (value, size, foreground) {
                              if (value == "Text") {
                                return Icon(
                                  IonIcons.document_text,
                                  color: context.theme.secondaryHeaderColor,
                                );
                              } else {
                                return Icon(
                                  IonIcons.image,
                                  color: context.theme.secondaryHeaderColor,
                                );
                              }
                            },
                            borderColor: context.primaryColor,
                            innerColor: context.theme.primaryColor,
                            indicatorColor: context.cardColor,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.01,
                        ),
                        Container(
                          width: width * 0.07,
                          height: height * 0.07,
                          decoration: BoxDecoration(
                            color: context.cardColor,
                            borderRadius: radius(
                              height * 0.025,
                            ),
                          ),
                          child: AppButton(
                            child: InkWell(
                              onTap: () async {
                                if (isIdle) {
                                  if (controller.text != "") {
                                    isIdle = false;
                                    String type = "message";
                                    if (currentModel == "Text") {
                                      type = "message";
                                    } else if (currentModel == "Image") {
                                      type = "image";
                                    }
                                    Message message = Message(
                                      timestamp: DateTime.now(),
                                      type: type,
                                      userId: user.userId,
                                      userName: user.userName,
                                      message: controller.text,
                                      profile: user.profile,
                                    );
                                    allMessages.add(message);
                                    controller.text = "";
                                    setState(() {});
                                    var reply = await getMessage(message);
                                    if (message.type == "message") {
                                      isIdle = true;
                                    }
                                    if (reply != null) {
                                      allMessages.add(reply);
                                      setState(() {});
                                    }
                                  } else {
                                    showWarn("Please Enter Text...!");
                                  }
                                } else {
                                  showWarn(
                                      "Please Wait Until Task Completed...!");
                                }
                              },
                              child: Icon(
                                IonIcons.send,
                                color: white,
                                size: height * 0.04,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
