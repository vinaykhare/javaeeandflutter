import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:our_group_chat_app/login/login_data.dart';

import 'chat_message.dart';
import 'dart:convert';
import 'dart:io';

class GroupChat extends StatefulWidget {
  final LoginData loginData;
  const GroupChat({Key? key, required this.loginData}) : super(key: key);
  @override
  State<GroupChat> createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollcontroller = ScrollController();

  //Save these three to retain the session
  //WebSocketChannel? _channel = GetStorage().read("channel");
  //String? _username = GetStorage().read("username");
  WebSocketChannel? _channel;
  String? _username;
  List<ChatMessage> messages = [];

  List<File>? pickedImages;
  List<Uint8List> pickedWebImages = [];
  String defaultImage = "images/logo.jpg";
  final picker = ImagePicker();

  @override
  void initState() {
    _username = widget.loginData.username;
    //_channel = widget.loginData.channel;
    _channel = WebSocketChannel.connect(Uri.parse('ws://' +
            widget.loginData.url +
            '/socket/websocketserver/' +
            widget.loginData
                .username) //192.168.1.250:8080 //122.175.208.221:8080 //localhost:8080/socket/sayhello //
        );
    messages = widget.loginData.messages;
    super.initState();
  }

/*
  Future _getImage() async {
    final pickedFiles = await picker.pickMultiImage();
    //final pickedFiles = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (pickedFiles != null) {
      setState(() {
        pickedImages = pickedFiles.map((e) => File(e.path)).toList();
        //pickedImages = pickedFiles.paths.map((path) => File(path!)).toList();
      });
    }
  }
*/
  Future _getImageWithFilePicker() async {
    final pickedFiles =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (pickedFiles != null) {
      setState(() {
        //pickedWebImages.add(pickedFiles.files.first.bytes!);
        pickedWebImages = pickedFiles.files.map((e) => e.bytes!).toList();
      });
    }
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      ChatMessage msg =
          ChatMessage(content: _controller.text, from: _username ?? "");

      //_channel.sink.add(_username + ":" + _controller.text);
      //_controller.text = jsonEncode(msg);
      _channel?.sink.add(jsonEncode(msg));
    }
    if (_scrollcontroller.hasClients) {
      _scrollcontroller.jumpTo(_scrollcontroller.position.maxScrollExtent);
    }
    /* _scrollcontroller.animateTo(_scrollcontroller.position.maxScrollExtent,
        duration: const Duration(seconds: 2), curve: Curves.fastOutSlowIn);*/
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  AppBar buildHeader() {
    return AppBar(
      title: const Text("Group Chat App!"),
    );
  }

  Container buildMessage(BuildContext context, int index) {
    return Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Align(
            alignment: messages[index].from != _username
                ? Alignment.topLeft
                : Alignment.topRight,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: (messages[index].from != _username
                      ? Colors.grey.shade200
                      : Colors.blue[200]),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  Text(
                    messages[index].from,
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 10),
                  ),
                  Text(
                    messages[index].content,
                    style: const TextStyle(fontSize: 15),
                  )
                ]))));
  }

  Widget buildMessageList() {
    return Expanded(
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: StreamBuilder(
              stream: _channel?.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  messages.add(ChatMessage.fromJson(
                      jsonDecode(snapshot.data.toString())));
                }
                return ListView.builder(
                  controller: _scrollcontroller,
                  itemCount: messages.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 10, bottom: 50),
                  //physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return buildMessage(context, index);
                  },
                );
              },
            )));
  }

  Widget buildBottomForm() {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.attach_file),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    color: Colors.red[100],
                    height: 250,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            ElevatedButton(
                                onPressed: () {
                                  _getImageWithFilePicker();
                                  Navigator.pop(context);
                                },
                                child: const Icon(Icons.image)),
                            const Icon(Icons.video_stable),
                            const Icon(Icons.file_present),
                          ],
                        ),
                      ],
                    ),
                  );
                });
          },
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: ListView(children: [
            TextField(
                controller: _controller,
                autofocus: true,
                autocorrect: true,
                onSubmitted: (value) {
                  _sendMessage();
                },
                decoration: const InputDecoration(
                    hintText: "Write message...",
                    hintStyle: TextStyle(color: Colors.black54),
                    border: InputBorder.none)),
            buildWebImageBar()
          ]),
        ),
        const SizedBox(
          width: 15,
        ),
        FloatingActionButton(
          onPressed: _sendMessage,
          child: const Icon(
            Icons.send,
            color: Colors.white,
            size: 18,
          ),
          backgroundColor: Colors.black,
          elevation: 0,
        ),
      ],
    );
  }

  Align buildBottomBar() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
        height: pickedWebImages.isEmpty ? 60 : 160,
        width: double.infinity,
        color: Colors.white,
        child: buildBottomForm(),
      ),
    );
  }

  Widget buildImageBar() {
    return SizedBox(
      height: 100.0,
      width: 500.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: pickedImages!.length,
        itemBuilder: (context, index) {
          return Container(
            height: 100.0,
            width: 100.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: FileImage(pickedImages![index]), fit: BoxFit.fill),
                border: Border.all()),
          );
        },
      ),
    );
  }

  Widget buildWebImageBar() {
    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        height: 100.0,
        width: 500.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: pickedWebImages.length,
          itemBuilder: (context, index) {
            return SizedBox(
                height: 100.0,
                width: 100.0,
                child: Image.memory(pickedWebImages[index]));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> chatBody = [buildMessageList(), buildBottomBar()];
    return Scaffold(
        appBar: buildHeader(),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(defaultImage), fit: BoxFit.fill)),
          child: Column(
            children: chatBody,
          ),
        )

        //bottomNavigationBar: BottomAppBar(child: buildBottomInputForm()),
        );
  }
}
