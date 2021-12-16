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
    required this.receiverId,
    required this.messageText,
    required this.timeSent,
    required this.sender,
    required this.receiver,
  });

  String id;
  String conversationId;
  String senderId;
  String receiverId;
  String messageText;
  DateTime timeSent;
  Receiver sender;
  Receiver receiver;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        conversationId: json["conversationId"],
        senderId: json["senderId"],
        receiverId: json["receiverId"],
        messageText: json["messageText"],
        timeSent: DateTime.parse(json["timeSent"]),
        sender: Receiver.fromJson(json["sender"]),
        receiver: Receiver.fromJson(json["receiver"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "conversationId": conversationId,
        "senderId": senderId,
        "receiverId": receiverId,
        "messageText": messageText,
        "timeSent": timeSent.toIso8601String(),
        "sender": sender.toJson(),
        "receiver": receiver.toJson(),
      };
}

class Receiver {
  Receiver({
    required this.username,
    required this.profileImage,
  });

  String username;
  String profileImage;

  factory Receiver.fromJson(Map<String, dynamic> json) => Receiver(
        username: json["username"],
        profileImage: json["profile_image"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "profile_image": profileImage,
      };
}
