import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shopri/src/controllers/api_controller.dart';
import 'package:shopri/src/utils/profile_image_loader.dart';
import 'package:transition/transition.dart' as transition;

import '../../account_setting_screen.dart';
import '../../product_detail_screen.dart';
import '../../wishlist_screen.dart';
import '../product_card.dart';
import '../refresh_widget.dart';
import '../widgets.dart';

Widget buildHome(Function fetchData, ScrollController scrollController, Size size, BuildContext context, Map<String, dynamic>? userInfo, String? loadInfo, bool isLoading) {
  return SafeArea(
    child: Stack(
      children: [
        NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowIndicator();
            return false;
          },
          child: RefreshWidget(
            onrefresh: () => fetchData(isInit: true),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverPersistentHeader(
                  floating: true,
                  delegate: SliverAppBarDelegate(
                    minHeight: size.height * 0.07,
                    maxHeight: size.height * 0.07,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.07,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey.shade200, offset: const Offset(2, 2), blurRadius: 10.0)]),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(context, transition.Transition(child: const WishListScreen(), transitionEffect: transition.TransitionEffect.LEFT_TO_RIGHT));
                                    },
                                    child: const Icon(Icons.star_outline),
                                  ),
                                  const FlutterLogo(),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(context, transition.Transition(child: const AccountSettingScreen(), transitionEffect: transition.TransitionEffect.RIGHT_TO_LEFT));
                                    },
                                    borderRadius: BorderRadius.circular(50.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50.0),
                                      child: Image(
                                        image: NetworkImage(getProfileImageUrl(userInfo!['profile_image'])),
                                        fit: BoxFit.fill,
                                        height: size.height * 0.038,
                                        width: size.height * 0.038,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: Container(height: size.height * 0.02)),
                GetBuilder<ApiController>(
                  builder: (controller) => SliverStaggeredGrid.countBuilder(
                    staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
                    crossAxisCount: 2,
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 0.0,
                    itemCount: controller.products.length,
                    itemBuilder: (context, index) {
                      final product = controller.products[index];
                      // print("FirstImageHeight: ${product['height']}");
                      // print("FirstImageWidth: ${product['width']}");
                      // print("FirstImageblurHash: ${product['blurHash']}");
                      // print("deviceHeight: ${size.height}");
                      // print("deviceWidth: ${size.width}");
                      // print("calculatedHeight: ${double.parse(product['height'].toString()) / size.height * 100}");
                      // print("calculatedWidth: ${double.parse(product['width'].toString()) / size.width * 100}");
                      return Material(
                        color: Colors.transparent,
                        child: ProductCard(
                          ontap: () {
                            Navigator.push(context, transition.Transition(child: ProductDetailScreen(product: product), transitionEffect: transition.TransitionEffect.RIGHT_TO_LEFT));
                          },
                          name: product['name'],
                          price: product['price'],
                          image: product['image'],
                          imageHeight: product['height'],
                          imageWidth: product['width'],
                          blurHash: product['blurHash'],
                          index: index,
                          size: size,
                          hasShadows: true,
                        ),
                      );
                    },
                  ),
                ),
                loadInfo != "over"
                    ? isLoading
                        ? SliverToBoxAdapter(child: SizedBox(child: Center(child: Lottie.asset('assets/loading.json', height: size.height * 0.1, width: size.width * 0.1))))
                        // : const SliverToBoxAdapter(child: SizedBox.shrink())
                        // : SliverToBoxAdapter(child: SizedBox(child: Center(child: Lottie.asset('assets/loading.json', height: size.height * 0.1, width: size.width * 0.1))))
                        : const SliverToBoxAdapter(child: SizedBox.shrink())
                    : const SliverToBoxAdapter(child: Center(child: Text("No more data")))
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
