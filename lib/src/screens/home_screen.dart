import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shopri/src/screens/components/home_screen/home.dart';
import 'package:shopri/src/screens/components/home_screen/messages.dart';
import 'package:shopri/src/screens/components/home_screen/notification.dart';
import 'package:shopri/src/screens/components/home_screen/search.dart';
import '../controllers/api_controller.dart';
import 'components/home_screen/home_screen_bottom_nav_bar.dart';
import 'components/home_screen/home_screen_drawer.dart';
import 'components/scroll_to_hide_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.userInfo}) : super(key: key);
  final Map<String, dynamic>? userInfo;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime timeBackPressed = DateTime.now();
  late ScrollController scrollController;
  late int pageToLoad;
  bool isLoading = false;
  String? loadInfo;
  int currentIndex = 0;

  @override
  void initState() {
    print("User: " + widget.userInfo!['username'].toString().capitalize!);
    scrollController = ScrollController();
    scrollController.addListener(() async {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (!isLoading) {
          fetchData(isInit: false);
        }
      }
    });

    //
    // pageToLoad = 1;
    fetchData(isInit: true);
    super.initState();
  }

  Future<void> fetchData({required bool isInit}) async {
    if (isInit) {
      setState(() {
        pageToLoad = 1;
      });
    }
    setState(() {
      isLoading = true;
    });
    loadInfo = await Get.find<ApiController>().getProducts(pageToLoad);
    setState(() {});
    if (loadInfo == 'done') {
      setState(() {
        pageToLoad++;
        isLoading = false;
      });
    } else if (loadInfo == 'fail') {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Something went wrong', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.grey.shade300,
      ));
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    List<Widget> homeScreenComponents = [
      buildHome(fetchData, scrollController, size, context, widget.userInfo, loadInfo, isLoading),
      const BuildSearch(),
      buildNotificaition(),
      const Messages(),
    ];

    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeBackPressed);
        final isExitWarning = difference >= const Duration(seconds: 2);
        timeBackPressed = DateTime.now();
        if (isExitWarning) {
          const message = "Press back again to exit";
          Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT, fontSize: 16.0);
          return false;
        } else {
          Fluttertoast.cancel();
          return true;
        }
      },
      child: Scaffold(
        drawer: const HomeScreenDrawer(),
        body: homeScreenComponents[currentIndex],
        bottomNavigationBar: ScrollToHideWidget(
          controller: scrollController,
          widgetHeight: 60.0,
          child: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BottomNavIcon(
                    ontap: () {
                      setState(() {
                        currentIndex = 0;
                      });
                    },
                    iconData: Icons.home_outlined,
                    currentIndex: currentIndex,
                    index: 0,
                  ),
                  BottomNavIcon(
                    ontap: () {
                      setState(() {
                        currentIndex = 1;
                      });
                    },
                    iconData: Icons.search,
                    currentIndex: currentIndex,
                    index: 1,
                  ),
                  BottomNavIcon(
                    ontap: () {
                      setState(() {
                        currentIndex = 2;
                      });
                    },
                    iconData: Icons.notifications_outlined,
                    currentIndex: currentIndex,
                    index: 2,
                  ),
                  BottomNavIcon(
                    ontap: () {
                      setState(() {
                        currentIndex = 3;
                      });
                    },
                    iconData: Icons.mail_outline,
                    currentIndex: currentIndex,
                    index: 3,
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: currentIndex == 0 ? ScrollToScaleWidget(controller: scrollController, duration: const Duration(milliseconds: 300), child: const BuildFloatingActoinButton()) : null,
      ),
    );
  }
}
