import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shopri/src/controllers/api_controller.dart';
import 'package:shopri/src/controllers/chat_controller.dart';
import 'package:shopri/src/utils/profile_image_loader.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.conversationIndex}) : super(key: key);
  final int conversationIndex;
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    Get.find<ChatController>().getMessages(int.parse(Get.find<ChatController>().conversations![widget.conversationIndex].id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          Get.find<ChatController>().resetMessages();
          return false;
        },
        child: SafeArea(
          child: GetBuilder<ChatController>(
            builder: (controller) {
              if (controller.messages == []) {
                return Center(child: Lottie.asset('assets/loading.json', height: size.height * 0.05));
              }
              return Column(
                children: [
                  SizedBox(height: size.height * 0.02),
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.messages.length,
                      itemBuilder: (context, index) {
                        return buildChatBubble(
                            size: size,
                            isSender: controller.messages[index].senderId == Get.find<ApiController>().loggedInUserInfo!['id'] ? true : false,
                            messageTxt: controller.messages[index].messageText,
                            receiverImgUrl: controller.messages[index].senderId == Get.find<ApiController>().loggedInUserInfo!['id']
                                ? controller.messages[index].receiver.profileImage
                                : controller.messages[index].sender.profileImage);
                      },
                    ),
                  ),
                  // const Spacer(),
                  buildInputAndSendBtn(
                    size,
                    onSend: () {
                      controller.sendMessage(
                        message: _messageController.text,
                        convId: Get.find<ChatController>().conversations![widget.conversationIndex].id,
                        senderId: Get.find<ApiController>().loggedInUserInfo!['id'],
                        receiverId: Get.find<ApiController>().loggedInUserInfo!['id'] == Get.find<ChatController>().conversations![widget.conversationIndex].senderId
                            ? Get.find<ChatController>().conversations![widget.conversationIndex].receiverId
                            : Get.find<ChatController>().conversations![widget.conversationIndex].senderId,
                      );
                    },
                    controller: _messageController,
                  ),
                  SizedBox(height: size.height * 0.01),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildInputAndSendBtn(Size size, {required TextEditingController controller, required Function() onSend}) {
    return Row(
      children: [
        SizedBox(width: size.width * 0.02),
        Expanded(
          child: TextField(
            controller: controller,
            textInputAction: TextInputAction.send,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              filled: true,
              fillColor: const Color(0xffF5F7FB),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0), borderSide: const BorderSide(color: Colors.transparent)),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0), borderSide: const BorderSide(color: Colors.transparent)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0), borderSide: const BorderSide(color: Colors.transparent)),
              hintText: "Type a message",
              hintStyle: TextStyle(color: Colors.grey.shade700, fontSize: 14.0),
            ),
            maxLines: null,
          ),
        ),
        SizedBox(width: size.width * 0.02),
        IconButton(
          onPressed: onSend,
          icon: const Icon(Icons.send, color: Colors.purple),
        ),
      ],
    );
  }

  Widget buildChatBubble({
    required Size size,
    required bool isSender,
    required String receiverImgUrl,
    required String messageTxt,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: !isSender
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: Image(
                    image: NetworkImage(getProfileImageUrl(receiverImgUrl)),
                    fit: BoxFit.cover,
                    height: size.height * 0.04,
                    width: size.height * 0.04,
                  ),
                ),
                SizedBox(width: size.width * 0.02),
                Row(
                  children: [
                    Container(
                      width: size.width * 0.7,
                      // width: messageTxt.length.toDouble() * size.width * 0.02,
                      // width: size.width * (0.01 + messageTxt.length.toDouble() / 100),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: const Color(0xffF5F7FB),
                      ),
                      child: Text(messageTxt),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Container(
                      width: size.width * 0.7,
                      // width: size.width * (0.01 + messageTxt.length.toDouble() / 100),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: const Color(0xff4E426D),
                      ),
                      child: Text(messageTxt, style: const TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
