import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:chat_diffusion_app/models/message.dart';
import 'package:flutter/material.dart';
import '../../services/gpt.dart';
import '../chat.dart';

class ImageStreamComponent extends StatefulWidget {
  const ImageStreamComponent({super.key, required this.message});
  final Message message;

  @override
  State<ImageStreamComponent> createState() => _ImageStreamComponentState();
}

class _ImageStreamComponentState extends State<ImageStreamComponent> {
  late Message message;
  bool isCompleted = false;
  Uint8List? imageBytes;

  @override
  void initState() {
    message = widget.message;
    isCompleted = false;
    imageBytes = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (message.status != null &&
        message.status == true &&
        message.baseData != "" &&
        message.status != null) {
      try {
        imageBytes = base64Decode(message.baseData.toString());
        isCompleted = true;
      } catch (error) {
        isCompleted = false;
      }
    }
    if (!isCompleted) {
      Future.delayed(
        const Duration(seconds: 2),
        () async {
          try {
            String url =
                "$server/image/stream/${message.image!['output'][0]['path'].toString().replaceAll('/image/tmp/', '').replaceAll('/0', '')}";
            var data = await refreshImageData(url);
            if (data != null) {
              if (data['status'] == "succeeded") {
                var imageData = data['output'][0]['data'].toString().split(",");
                if (imageData.length > 1) {
                  imageBytes = base64Decode(imageData[1]);
                  isIdle = true;
                  isCompleted = true;
                  var index = allMessages.indexOf(message);
                  message.baseData = imageData[1].toString();
                  message.status = true;
                  allMessages[index] = message;
                }
                setState(() {});
              }
            } else {
              isIdle = false;
              setState(() {});
            }
          } catch (error) {}
        },
      );
    }
    int randomNumber = Random().nextInt(1000);
    return Column(
      children: [
        if (!isCompleted)
          Image.network(
            "$server${message.image!['output'][0]['path']}?$randomNumber",
            width: height * 0.5,
            height: width * 0.6,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.network(
                user.profile,
                fit: BoxFit.cover,
                width: height * 0.5,
                height: width * 0.6,
              );
            },
          ),
        if (isCompleted && imageBytes != null)
          Image.memory(
            imageBytes!,
            fit: BoxFit.cover,
            width: height * 0.5,
            height: width * 0.6,
            errorBuilder: (context, error, stackTrace) {
              return Image.network(
                user.profile,
                fit: BoxFit.cover,
                width: height * 0.5,
                height: width * 0.6,
              );
            },
          ),
      ],
    );
  }
}
