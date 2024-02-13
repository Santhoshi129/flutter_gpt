import 'dart:convert';

import 'package:chat_diffusion_app/models/message.dart';
import 'package:requests/requests.dart';
import 'package:html/parser.dart';

String authentication = "";
String server = "http://localhost:9000";

Future<String> getAuthentication() async {
  var response = await Requests.get("https://textsynth.com/playground.html");
  var document = parse(response.body);
  var script = document.querySelector("script");
  if (script != null) {
    var strings = script.innerHtml.split('"');
    if (strings.length > 1) {
      return strings[1];
    }
  }
  return "";
}

Future<Message?> getMessage(Message message) async {
  try {
    if (authentication == "") {
      authentication = await getAuthentication();
    }
    if (authentication != "") {
      if (message.type == "message") {
        var response = await Requests.post(
          "https://api.textsynth.com/v1/engines/gptj_6B/completions",
          json: {
            "prompt": message.message,
            "temperature": 1,
            "top_k": 40,
            "top_p": 0.9,
            "max_tokens": 200,
            "stream": false,
            "stop": null
          },
          headers: {"Authorization": "Bearer $authentication"},
          timeoutSeconds: 600,
        );
        "Jntuk@student";
        var data = jsonDecode(response.body);
        if (data['text'] != null && data['text'] != "") {
          var reply = Message(
            timestamp: DateTime.now(),
            message: data['text'].toString(),
            type: "message",
            userId: "mrdiffusion",
            userName: "Mr.Diffusion",
            profile:
                "https://images.nightcafe.studio/jobs/UwrQulFZ3SRSsflDNpfQ/UwrQulFZ3SRSsflDNpfQ--1--xg50i.jpg?tr=w-1600,c-at_max",
          );

          return reply;
        }
      } else if (message.type == "image") {
        var response = await Requests.post(
          "$server/render",
          json: {
            "prompt": message.message,
            "seed": 1124534,
            "used_random_seed": true,
            "negative_prompt": "",
            "num_outputs": 1,
            "num_inference_steps": 25,
            "guidance_scale": 7.5,
            "width": 512,
            "height": 512,
            "vram_usage_level": "low",
            "use_stable_diffusion_model": "dreamshaper_331BakedVae",
            "use_vae_model": "vae-ft-mse-840000-ema-pruned",
            "stream_progress_updates": true,
            "stream_image_progress": true,
            "show_only_filtered_image": true,
            "block_nsfw": false,
            "output_format": "jpeg",
            "output_quality": 75,
            "metadata_output_format": "none",
            "original_prompt": "one boy is alone at beach with his dog",
            "active_tags": [],
            "inactive_tags": [],
            "sampler_name": "euler_a",
            "save_to_disk_path": "/home/abhi/Stable Diffusion UI",
            "use_face_correction": "GFPGANv1.3",
            "session_id": "1679035184492",
          },
          timeoutSeconds: 600,
        );
        var data = jsonDecode(response.body);
        var imageData = await getImageStreamPath("$server${data['stream']}");
        return Message(
          timestamp: DateTime.now(),
          message: message.message,
          image: imageData,
          type: "image",
          userId: "mrdiffusion",
          userName: "Mr.Diffusion",
          profile:
              "https://images.nightcafe.studio/jobs/UwrQulFZ3SRSsflDNpfQ/UwrQulFZ3SRSsflDNpfQ--1--xg50i.jpg?tr=w-1600,c-at_max",
        );
      }
    }
  } catch (error) {
    print(error);
  }
  return null;
}

Future<Map<String, dynamic>> getImageStreamPath(String url) async {
  try {
    await Future.delayed(const Duration(seconds: 2));
    var response = await Requests.get(url);
    Map<String, dynamic> data = {};
    if (response.body != "") {
      try {
        data = jsonDecode(response.body);
      } catch (error) {}

      if (data['output'] != null) {
        var outputs = data['output'] as List;
        if (outputs.isNotEmpty) {
          if (outputs[0]['path'] != null) {
            return data;
          } else {
            return await getImageStreamPath(url);
          }
        } else {
          return await getImageStreamPath(url);
        }
      } else {
        return await getImageStreamPath(url);
      }
    } else {
      return await getImageStreamPath(url);
    }
  } catch (error) {
    return {};
  }
}

Future<Map<String, dynamic>?> refreshImageData(String url) async {
  try {
    var response = await Requests.get(url);
    Map<String, dynamic> data = {};
    if (response.body != "") {
      try {
        data = jsonDecode(response.body);
      } catch (error) {}

      if (data['status'] != null && data['status'] == "succeeded") {
        var outputs = data['output'] as List;
        if (outputs.isNotEmpty) {
          if (outputs[0]['data'] != null) {
            return data;
          }
        }
      }
    }
  } catch (error) {}
  return null;
}
