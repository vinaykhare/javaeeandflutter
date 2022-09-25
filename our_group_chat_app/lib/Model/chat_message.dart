import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

class ChatMessage {
  String content;
  String from;
  List<String> images = [];
  List<String> videos = [];

  ChatMessage({
    required this.content,
    required this.from,
    required this.images,
    required this.videos,
  });
  Map toJson() {
    List<String> imageBytes = images
        .map(
          (e) => base64Encode(
            File(e).readAsBytesSync(),
          ),
        )
        .toList();

    List<String> videoBytes = videos
        .map(
          (e) => base64Encode(
            File(e).readAsBytesSync(),
          ),
        )
        .toList();
    return {
      'content': content,
      'from': from,
      'images': imageBytes,
      'videos': videoBytes,
    };
  }

  void saveReceivedImages() async {}

  factory ChatMessage.fromJson(dynamic json) {
    List<String> imageByteStringList = json["images"] as List<String>;

    List<Uint8List> imageByteList = imageByteStringList
        .map((imageByteString) => base64Decode(imageByteString))
        .toList();

    List<String> imagePaths = imageByteList.map((imageByte) {
      String fileName = "OGCA_${DateTime.now()}.jpg";
      File(fileName).writeAsBytesSync(imageByte);
      File savedFile = File(fileName);
      return savedFile.path;
    }).toList();

    //Read Videos

    List<String> videoByteStringList = json["videos"] as List<String>;

    List<Uint8List> videoByteList = videoByteStringList
        .map((imageByteString) => base64Decode(imageByteString))
        .toList();

    List<String> videoPaths = videoByteList.map((videoByte) {
      String fileName = "OGCA_${DateTime.now()}.mp4";
      File(fileName).writeAsBytesSync(videoByte);
      File savedFile = File(fileName);
      return savedFile.path;
    }).toList();

    return ChatMessage(
      from: json['from'],
      content: json['content'],
      images: imagePaths,
      videos: videoPaths,
    );
  }
}
