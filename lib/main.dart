import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'src/controllers/api_controller.dart';
import 'src/controllers/category_controller.dart';
import 'src/controllers/my_camera_controller.dart';
import 'src/controllers/query_controller.dart';
import 'src/root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.white, statusBarIconBrightness: Brightness.dark));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Get.put<MyCameraController>(MyCameraController());
  Get.put<QueryController>(QueryController());
  Get.put<ApiController>(ApiController());
  Get.put<CategoryController>(CategoryController());
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopri',
      home: Root(),
    );
  }
}
