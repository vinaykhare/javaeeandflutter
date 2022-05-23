class ChatMessage {
  String content;
  String from;
  ChatMessage({required this.content, required this.from});
  Map toJson() => {'content': content, 'from': from};
  factory ChatMessage.fromJson(dynamic json) {
    return ChatMessage(from: json['from'], content: json['content']);
  }
}
