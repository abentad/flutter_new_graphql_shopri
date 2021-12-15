import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopri/src/controllers/api_controller.dart';
import 'package:shopri/src/controllers/my_camera_controller.dart';
import 'package:transition/transition.dart' as transition;
import '../product_add_screen.dart';
import 'custom_material_button.dart';

Widget buildCameraOptions(Size size, BuildContext context) {
  return Dialog(
    backgroundColor: Colors.grey.shade200,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: size.height * 0.02),
          CustomMaterialButton(
            onPressed: () async {
              Navigator.pop(context);
              XFile? imageFile = await Get.find<MyCameraController>().pickImageFromCamera();
              if (imageFile != null) {
                File croppedImage = await Get.find<MyCameraController>().cropImage(File(imageFile.path));
                Get.find<ApiController>().addToProductImages(croppedImage);
                Navigator.pushReplacement(context, transition.Transition(child: const ProductAddScreen()));
              }
            },
            btnLabel: "Camera",
          ),
          SizedBox(height: size.height * 0.02),
          CustomMaterialButton(
            onPressed: () async {
              XFile? imageFile = await Get.find<MyCameraController>().pickImageFromGallery();
              File croppedImage = await Get.find<MyCameraController>().cropImage(File(imageFile!.path));
              Get.find<ApiController>().addToProductImages(croppedImage);
              Navigator.pop(context);
              Navigator.push(context, transition.Transition(child: const ProductAddScreen()));
            },
            btnLabel: "Gallery",
          ),
          SizedBox(height: size.height * 0.02),
        ],
      ),
    ),
  );
}
