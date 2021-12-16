import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transition/transition.dart' as transition;
import './controllers/api_controller.dart';
import './screens/auth_choice.dart';

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RootState();
  }
}

class RootState extends State<Root> {
  @override
  void initState() {
    super.initState();
    checkUserAvailability();
  }

  void checkUserAvailability() async {
    bool isUserLoggedIn = await Get.find<ApiController>().checkIfUserIsLoggedIn();
    Get.find<ApiController>().setClient();
    if (isUserLoggedIn) {
      bool result = await Get.find<ApiController>().signInWithToken(context);
      if (result) await Get.find<ApiController>().getWishLists(int.parse(Get.find<ApiController>().loggedInUserInfo!['id']));
      print("WishLists: ${Get.find<ApiController>().wishlists.length}");
    } else {
      Navigator.pushReplacement(context, transition.Transition(child: const AuthChoice(), transitionEffect: transition.TransitionEffect.FADE));
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildInitLoading(context);
  }

  Widget buildInitLoading(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200.0,
          height: 100.0,
          child: Shimmer.fromColors(
            baseColor: Colors.red,
            highlightColor: Colors.yellow,
            child: Text('Shopri', textAlign: TextAlign.center, style: TextStyle(fontSize: size.height * 0.06, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
