import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopri/src/controllers/api_controller.dart';
import 'package:shopri/src/utils/profile_image_loader.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.02),
            Expanded(
              child: ListView.builder(
                itemCount: 2,
                itemBuilder: (context, index) {
                  return buildChatBubble(size: size, isSender: true);
                },
              ),
            ),
            const Spacer(),
            buildInputAndSendBtn(
              size,
              onSend: () {},
              controller: _messageController,
            ),
            SizedBox(height: size.height * 0.01),
          ],
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

  Widget buildChatBubble({required Size size, required bool isSender}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: !isSender
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: Image(
                    image: NetworkImage(getProfileImageUrl(Get.find<ApiController>().loggedInUserInfo!['profile_image'])),
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
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: const Color(0xffF5F7FB),
                      ),
                      child: const Text('Waiting for your reply as i have to back soon. I have to travel a long distance tomorrow.'),
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
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: const Color(0xff4E426D),
                      ),
                      child: const Text(
                        'Waiting for your reply as i have to back soon. I have to travel a long distance tomorrow.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: size.width * 0.02),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: Image(
                    image: NetworkImage(getProfileImageUrl(Get.find<ApiController>().loggedInUserInfo!['profile_image'])),
                    fit: BoxFit.cover,
                    height: size.height * 0.04,
                    width: size.height * 0.04,
                  ),
                ),
              ],
            ),
    );
  }
}
