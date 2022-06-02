import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'chat_message.dart';
import 'dart:convert';

class GroupChatOld extends StatefulWidget {
  const GroupChatOld({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<GroupChatOld> createState() => _GroupChatOldState();
}

class _GroupChatOldState extends State<GroupChatOld> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollcontroller = ScrollController();

  late WebSocketChannel _channel;
  String _username = "";

  List<ChatMessage> messages = [];

  void _sendMessage() {
    if (messages.isEmpty) {
      _connectSocket(_controller.text);
    } else if (_controller.text.isNotEmpty) {
      /* ChatMessage msg = ChatMessage(content: _controller.text, from: "username");
      setState(() {
        messages.add(msg);
      }); */
      ChatMessage msg = ChatMessage(content: _controller.text, from: _username);
      //_channel.sink.add(_username + ":" + _controller.text);
      //_controller.text = jsonEncode(msg);
      _channel.sink.add(jsonEncode(msg));
    }
    if (_scrollcontroller.hasClients) {
      _scrollcontroller.jumpTo(_scrollcontroller.position.maxScrollExtent);
    }
    /* _scrollcontroller.animateTo(_scrollcontroller.position.maxScrollExtent,
        duration: const Duration(seconds: 2), curve: Curves.fastOutSlowIn);*/
    _controller.clear();
  }

  void _connectSocket(String username) {
    _channel = WebSocketChannel.connect(
        Uri.parse('ws://localhost:8080/socket/websocketserver/' +
            username) //192.168.1.250:8080 //122.175.208.221:8080 //localhost:8080/socket/sayhello //
        );
    setState(() {
      _username = _controller.text;
    });
    _controller.clear();
  }

  void logout() {
    setState(() {
      _username = "";
      messages = [];
    });
    _channel.sink.close();
  }

  @override
  void dispose() {
    logout();
    _controller.dispose();
    super.dispose();
  }

  AppBar buildHeader() {
    return AppBar(
      title: _username != ""
          ? Text("Chat App (" + _username + ")")
          : const Text("Chat App!"),
      //elevation: 0,
      //automaticallyImplyLeading: false,
      //backgroundColor: Colors.black,
      //leading: const Icon(Icons.logout),
      actions: <Widget>[
        IconButton(onPressed: logout, icon: const Icon(Icons.logout))
      ],
    );
  }

  Align buildBottomBar() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
        height: 60,
        width: double.infinity,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.attach_file),
              onPressed: () {
                _sendMessage();
              },
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
                  decoration: (_username != "")
                      ? const InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none)
                      : const InputDecoration(
                          hintText: "Write username...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none)),
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
        ),
      ),
    );
  }

  Container buildUserInputForm() {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/logo.jpg'), fit: BoxFit.cover)),
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

  Container buildMessageList() {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: StreamBuilder(
          stream: _channel.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              /*
                final receivedMessage = snapshot.data.toString();
                final splittedMessage = receivedMessage.split(":");
                final rcvFrom = splittedMessage[0];
                final msg = splittedMessage[1];
                messages.add(ChatMessage(content: msg, from: rcvFrom));
              */

              messages.add(
                  ChatMessage.fromJson(jsonDecode(snapshot.data.toString())));
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
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildHeader(),
      body: Stack(
        children: <Widget>[
          (_username != "") ? buildMessageList() : buildUserInputForm(),
          buildBottomBar()
          //buildBottomInputForm()
        ],
      ),
      //bottomNavigationBar: BottomAppBar(child: buildBottomInputForm()),
    );
  }
}
