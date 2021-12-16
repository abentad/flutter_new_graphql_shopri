import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shopri/src/controllers/api_controller.dart';
import 'package:shopri/src/screens/product_detail_screen.dart';
import 'components/product_card.dart';
import 'package:transition/transition.dart' as transition;

class WishListScreen extends StatelessWidget {
  const WishListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Get.find<ApiController>().wishlists.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(MdiIcons.flaskEmpty, size: 26.0),
                    SizedBox(height: size.height * 0.02),
                    const Text('No item in wishlist'),
                  ],
                ),
              )
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: Container(height: size.height * 0.02)),
                  GetBuilder<ApiController>(
                    builder: (controller) => SliverStaggeredGrid.countBuilder(
                      staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
                      crossAxisCount: 2,
                      mainAxisSpacing: 20.0,
                      crossAxisSpacing: 0.0,
                      itemCount: controller.wishlists.length,
                      itemBuilder: (context, index) {
                        final wishlist = controller.wishlists[index];
                        return Material(
                          color: Colors.transparent,
                          child: ProductCard(
                            ontap: () {
                              // print('product selected: ${controller.wishlistMap!['wishlists'][index]['product']}');
                              Navigator.push(
                                  context,
                                  transition.Transition(
                                      child: ProductDetailScreen(product: controller.wishlistMap!['wishlists'][index]['product']), transitionEffect: transition.TransitionEffect.RIGHT_TO_LEFT));
                            },
                            id: int.parse(wishlist.product.id),
                            name: wishlist.product.name,
                            price: wishlist.product.price,
                            image: wishlist.product.image,
                            imageHeight: wishlist.product.height,
                            imageWidth: wishlist.product.width,
                            blurHash: wishlist.product.blurHash,
                            index: index,
                            size: size,
                            hasShadows: true,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
