import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:our_group_chat_app/our_group_chat_app.dart';
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
  bool isLogOut = false;
  final TextEditingController _controller = TextEditingController();

  //Save these three to retain the session
  //WebSocketChannel? _channel = GetStorage().read("channel");
  //String? _username = GetStorage().read("username");
  late WebSocketChannel _channel;
  String? _username;
  List<ChatMessage> messages = [];

  List<File> pickedImages = [];
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
    //messages = widget.loginData.messages;
    super.initState();
  }

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
      _channel.sink.add(jsonEncode(msg));
    }
    _controller.clear();
  }

  void logout() {
    _channel.sink.close();
    _controller.dispose();
    widget.loginData.username = '';
    widget.loginData.url = '';
    setState(() {
      isLogOut = true;
    });
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    widget.loginData.username = '';
    widget.loginData.url = '';
    super.dispose();
  }

  AppBar buildHeader() {
    return AppBar(
      title: const Text("Group Chat App!"),
      actions: [
        IconButton(
          onPressed: logout,
          icon: const Icon(Icons.logout),
        ),
      ],
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
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).colorScheme.outline),
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
              stream: _channel.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  messages.insert(
                    0,
                    ChatMessage.fromJson(
                      jsonDecode(
                        snapshot.data.toString(),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  //shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 10, bottom: 50),
                  //physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return buildMessage(context, index);
                  },
                );
              },
            )));
  }

  Widget buildBottomForm(BuildContext context) {
    return Row(
      children: <Widget>[
        FittedBox(
          child: IconButton(
            icon: const Icon(
              Icons.image,
              color: Colors.brown,
              size: 30,
            ),
            onPressed: () {
              Platform.isAndroid ? _getImage() : _getImageWithFilePicker();
            },
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: TextField(
            controller: _controller,
            autofocus: true,
            autocorrect: true,
            onSubmitted: (value) {
              _sendMessage();
            },
            decoration: const InputDecoration(
              hintText: "Write message...",
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        FloatingActionButton(
          onPressed: _sendMessage,
          child: const Icon(
            Icons.send,
            size: 18,
          ),
          elevation: 0,
        ),
      ],
    );
  }

  Align buildBottomBar(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
        height: pickedWebImages.isEmpty ? 60 : 160,
        width: double.infinity,
        color: Theme.of(context).bottomAppBarColor,
        child: buildBottomForm(context),
      ),
    );
  }

  Widget buildImageBar() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: pickedImages.length,
      itemBuilder: (context, index) {
        return Container(
          width: 100.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: FileImage(pickedImages[index]),
              fit: BoxFit.fill,
            ),
            border: Border.all(),
          ),
        );
      },
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
    List<Widget> chatBody = [
      buildMessageList(),
      if (pickedImages.isNotEmpty || pickedWebImages.isNotEmpty)
        Expanded(
            child: Stack(
          children: [
            Platform.isAndroid ? buildImageBar() : buildWebImageBar(),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    pickedImages.clear();
                    pickedWebImages.clear();
                  });
                },
                icon: const Icon(Icons.close),
              ),
            ),
          ],
        )),
      buildBottomBar(context),
    ];
    return isLogOut
        ? const OurGroupChatApp()
        : Scaffold(
            appBar: buildHeader(),
            body: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
              ),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: chatBody,
              ),
            ),
            //bottomNavigationBar: BottomAppBar(child: buildBottomInputForm()),
          );
  }
}
