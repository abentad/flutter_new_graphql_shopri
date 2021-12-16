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
    required this.lastMessage,
    required this.lastMessageTimeSent,
    required this.lastMessageSenderId,
    required this.lastMessageSender,
    required this.sender,
    required this.receiver,
  });

  String id;
  String senderId;
  String receiverId;
  String lastMessage;
  DateTime lastMessageTimeSent;
  String lastMessageSenderId;
  LastMessageSender lastMessageSender;
  LastMessageSender sender;
  LastMessageSender receiver;

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        id: json["id"],
        senderId: json["senderId"],
        receiverId: json["receiverId"],
        lastMessage: json["lastMessage"],
        lastMessageTimeSent: DateTime.parse(json["lastMessageTimeSent"]),
        lastMessageSenderId: json["lastMessageSenderId"],
        lastMessageSender: LastMessageSender.fromJson(json["lastMessageSender"]),
        sender: LastMessageSender.fromJson(json["sender"]),
        receiver: LastMessageSender.fromJson(json["receiver"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "senderId": senderId,
        "receiverId": receiverId,
        "lastMessage": lastMessage,
        "lastMessageTimeSent": lastMessageTimeSent.toIso8601String(),
        "lastMessageSenderId": lastMessageSenderId,
        "lastMessageSender": lastMessageSender.toJson(),
        "sender": sender.toJson(),
        "receiver": receiver.toJson(),
      };
}

class LastMessageSender {
  LastMessageSender({
    required this.username,
    required this.profileImage,
  });

  String username;
  String profileImage;

  factory LastMessageSender.fromJson(Map<String, dynamic> json) => LastMessageSender(
        username: json["username"],
        profileImage: json["profile_image"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "profile_image": profileImage,
      };
}
