import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopri/src/controllers/api_controller.dart';
import 'package:shopri/src/utils/profile_image_loader.dart';

class AccountSettingScreen extends StatelessWidget {
  const AccountSettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = Get.find<ApiController>().loggedInUserInfo;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.02),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(50.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: Image(
                        image: NetworkImage(getProfileImageUrl(user!['profile_image'])),
                        fit: BoxFit.fill,
                        height: size.height * 0.1,
                        width: size.height * 0.1,
                      ),
                    ),
                  ),
                  SizedBox(width: size.width * 0.04),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user['username'].toString().capitalize.toString(),
                        style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: size.height * 0.008),
                      Text(
                        user['phoneNumber'].toString().capitalize.toString(),
                        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.02),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(),
            ),
            SizedBox(height: size.height * 0.04),
            buildSettingButton(
              size,
              ontap: () {
                // Get.find<ApiController>().signOutUser(context);
              },
              prefixIconData: Icons.post_add,
              btnText: "My Ads",
            ),
            buildSettingButton(
              size,
              ontap: () {
                Get.find<ApiController>().signOutUser(context);
              },
              prefixIconData: Icons.logout,
              btnText: "Logout",
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSettingButton(Size size, {required IconData prefixIconData, required String btnText, required Function() ontap}) {
    return InkWell(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(prefixIconData, size: 28.0),
                SizedBox(width: size.width * 0.04),
                Text(btnText, style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600)),
              ],
            ),
            const Icon(Icons.arrow_forward_ios, size: 18.0, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
