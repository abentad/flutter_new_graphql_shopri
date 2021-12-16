// To parse this JSON data, do
//
//     final message = messageFromJson(jsonString);

import 'dart:convert';

Message messageFromJson(String str) => Message.fromJson(json.decode(str));

String messageToJson(Message data) => json.encode(data.toJson());

class Message {
  Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    required this.messageText,
    required this.timeSent,
  });

  int id;
  int conversationId;
  int senderId;
  String senderName;
  String messageText;
  DateTime timeSent;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        conversationId: json["conversationId"],
        senderId: json["senderId"],
        senderName: json["senderName"],
        messageText: json["messageText"],
        timeSent: DateTime.parse(json["timeSent"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "conversationId": conversationId,
        "senderId": senderId,
        "senderName": senderName,
        "messageText": messageText,
        "timeSent": timeSent.toIso8601String(),
      };
}
