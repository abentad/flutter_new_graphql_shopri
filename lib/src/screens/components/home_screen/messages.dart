import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shopri/src/controllers/api_controller.dart';
import 'package:shopri/src/controllers/chat_controller.dart';
import 'package:shopri/src/screens/chat_screen.dart';
import 'package:shopri/src/utils/profile_image_loader.dart';
import 'package:transition/transition.dart' as transition;

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  void initState() {
    Get.find<ChatController>().getConversations(int.parse(Get.find<ApiController>().loggedInUserInfo!['id']));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: GetBuilder<ChatController>(builder: (controller) {
        if (controller.conversations == null) {
          return Center(child: Lottie.asset('assets/loading.json', height: size.height * 0.05));
        }
        return Container(
          decoration: const BoxDecoration(color: Colors.white),
          // padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.02),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text('Messages', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0)),
              ),
              SizedBox(height: size.height * 0.04),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.conversations!['conversations'].length,
                  itemBuilder: (context, index) {
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                              transition.Transition(child: ChatScreen(convId: controller.conversations!['conversations'][index]['id']), transitionEffect: transition.TransitionEffect.RIGHT_TO_LEFT));
                        },
                        child: buildContactButton(
                          size,
                          imgUrl: controller.conversations!['conversations'][index]['receiver']['profile_image'],
                          lastText: controller.conversations!['conversations'][index]['lastMessage'],
                          lastTextTimeSent: controller.conversations!['conversations'][index]['lastMessageTimeSent'],
                          name: controller.conversations!['conversations'][index]['receiver']['username'],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  Widget buildContactButton(Size size, {required String imgUrl, required String name, required String lastText, required String lastTextTimeSent}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        height: size.height * 0.1,
        width: size.width,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Image(
                image: NetworkImage(getProfileImageUrl(imgUrl)),
                fit: BoxFit.cover,
                height: size.height * 0.075,
                width: size.height * 0.075,
              ),
            ),
            SizedBox(width: size.width * 0.04),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name.toString().capitalize.toString(),
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0),
                      ),
                      Text(
                        DateFormat('jm').format(DateTime.parse(lastTextTimeSent)),
                        style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12.0, color: Colors.teal),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          lastText,
                          style: TextStyle(color: Colors.grey.shade800, fontSize: 12.0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
