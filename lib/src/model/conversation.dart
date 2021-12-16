// To parse this JSON data, do
//
//     final conversation = conversationFromJson(jsonString);

import 'dart:convert';

Conversation conversationFromJson(String str) => Conversation.fromJson(json.decode(str));

String conversationToJson(Conversation data) => json.encode(data.toJson());

class Conversation {
  Conversation({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.senderName,
    required this.receiverName,
    required this.senderProfileUrl,
    required this.receiverProfileUrl,
    required this.lastMessage,
    required this.lastMessageTimeSent,
    required this.lastMessageSenderId,
  });

  int id;
  int senderId;
  int receiverId;
  String senderName;
  String receiverName;
  String senderProfileUrl;
  String receiverProfileUrl;
  String lastMessage;
  String lastMessageTimeSent;
  int lastMessageSenderId;

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        id: json["id"],
        senderId: json["senderId"],
        receiverId: json["receiverId"],
        senderName: json["senderName"],
        receiverName: json["receiverName"],
        senderProfileUrl: json["senderProfileUrl"],
        receiverProfileUrl: json["receiverProfileUrl"],
        lastMessage: json["lastMessage"],
        lastMessageTimeSent: json["lastMessageTimeSent"],
        lastMessageSenderId: json["lastMessageSenderId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "senderId": senderId,
        "receiverId": receiverId,
        "senderName": senderName,
        "receiverName": receiverName,
        "senderProfileUrl": senderProfileUrl,
        "receiverProfileUrl": receiverProfileUrl,
        "lastMessage": lastMessage,
        "lastMessageTimeSent": lastMessageTimeSent,
        "lastMessageSenderId": lastMessageSenderId,
      };
}
