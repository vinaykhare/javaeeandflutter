import 'package:flutter/material.dart';
import 'package:our_group_chat_app/Model/server_connection.dart';
import 'package:our_group_chat_app/Pages/select_media.dart';
import 'package:provider/provider.dart';

class SendMessage extends StatelessWidget {
  final TextEditingController _messageController = TextEditingController();

  SendMessage({Key? key}) : super(key: key);

  void sendMessageToServer(BuildContext context,
      [Map<String, List<String>>? selectedFiles]) {
    if (_messageController.text.isNotEmpty || selectedFiles != null) {
      Provider.of<ServerConnection>(context, listen: false).sendMessage(
        _messageController.text,
        selectedFiles?["imageFiles"] ?? [],
        selectedFiles?["videoFiles"] ?? [],
      );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            Map<String, List<String>>? selectedFiles =
                await Navigator.of(context).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (_) {
                  return SelectMedia(
                    message: _messageController.text,
                  );
                },
              ),
            );

            _messageController.text = selectedFiles?["message"]![0] ?? "";
            sendMessageToServer(context, selectedFiles);
          },
          icon: const Icon(Icons.photo),
          color: Theme.of(context).primaryColor,
          disabledColor: Theme.of(context).disabledColor,
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(10),
            child: TextField(
              onSubmitted: (_) {
                sendMessageToServer(context);
              },
              controller: _messageController,
              decoration: const InputDecoration(
                label: Text("Insert text here..."),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            sendMessageToServer(context);
          },
          icon: const Icon(Icons.send),
          color: Theme.of(context).primaryColor,
          disabledColor: Theme.of(context).disabledColor,
        ),
      ],
    );
  }
}
