import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelectMedia extends StatefulWidget {
  final String message;
  const SelectMedia({Key? key, required this.message}) : super(key: key);

  @override
  State<SelectMedia> createState() => _SelectMediaState();
}

class _SelectMediaState extends State<SelectMedia> {
  TextEditingController messageController = TextEditingController();
  List<String> imageFiles = [];
  List<String> videoFiles = [];
  List<String> message = [];

  @override
  void initState() {
    super.initState();
    messageController.text = widget.message;
  }

  void selectImages() async {
    ImagePicker imagePicker = ImagePicker();
    var pickedFiles = await imagePicker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      for (var pickedFile in pickedFiles) {
        setState(() {
          imageFiles.add(pickedFile.path);
        });
      }
    }
  }

  void selectVideo() async {
    ImagePicker videoPicker = ImagePicker();
    var pickedFile = await videoPicker.pickVideo(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        videoFiles.add(pickedFile.path);
      });
    }
  }

  void selectVideoFromGallery() async {
    ImagePicker videoPicker = ImagePicker();
    var pickedFile = await videoPicker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        videoFiles.add(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBarWidget = AppBar(
      title: const Text("Select Files"),
    );
    var appHeight = MediaQuery.of(context).size.height -
        appBarWidget.preferredSize.height -
        MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: appBarWidget,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: selectImages,
                icon: const Icon(Icons.image),
                label: const Text("Images"),
              ),
              ElevatedButton.icon(
                onPressed: selectVideo,
                icon: const Icon(Icons.video_call),
                label: const Text("Video Cam"),
              ),
              ElevatedButton.icon(
                onPressed: selectVideoFromGallery,
                icon: const Icon(Icons.video_call),
                label: const Text("Video Gallery"),
              ),
            ],
          ),
          // Text(
          //   "Selected Images",
          //   style: Theme.of(context).textTheme.bodyLarge,
          // ),
          if (imageFiles.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              height: appHeight * 0.25,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imageFiles.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 10,
                      child: Image.file(File(imageFiles[index])),
                    );
                  }),
            ),
          // Text(
          //   "Selected Videos",
          //   style: Theme.of(context).textTheme.bodyLarge,
          // ),
          if (videoFiles.isNotEmpty)
            Expanded(
              child: ListView.builder(
                  itemCount: videoFiles.length,
                  itemBuilder: (context, index) {
                    return Text(videoFiles[index]);
                  }),
            ),

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextField(
                decoration: const InputDecoration(
                  label: Text("message"),
                ),
                controller: messageController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        imageFiles = [];
                        videoFiles = [];
                      });
                    },
                    icon: const Icon(Icons.cancel),
                    label: const Text("Cancel"),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      message.add(messageController.text);
                      Navigator.of(context).pop(
                        {
                          "imageFiles": imageFiles,
                          "videoFiles": videoFiles,
                          "message": message,
                        },
                      );
                    },
                    icon: const Icon(Icons.done),
                    label: const Text("Ok"),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
