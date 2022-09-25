import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message, username, imageUrl;
  final bool isMe;
  const MessageBubble({
    Key? key,
    required this.message,
    required this.isMe,
    required this.username,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
          width: MediaQuery.of(context).size.width * 2 / 3,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: const Radius.circular(20),
              bottomRight:
                  isMe ? const Radius.circular(0) : const Radius.circular(20),
              topLeft:
                  isMe ? const Radius.circular(20) : const Radius.circular(0),
              topRight: const Radius.circular(20),
            ),
            color: isMe
                ? Theme.of(context).highlightColor
                : Theme.of(context).backgroundColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        //backgroundImage: FileImage(File(imageUrl)),
                        backgroundColor: isMe ? Colors.amber : Colors.green,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        username,
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                message,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          )),
    );
  }
}
