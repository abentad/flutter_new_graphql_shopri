import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:graphql/client.dart';
import 'package:shopri/src/model/wishlist_model.dart';
import 'package:transition/transition.dart' as transition;
import "package:http/http.dart" as http;
import 'package:http_parser/http_parser.dart';
import 'package:blurhash/blurhash.dart' as blurhash;
import '../screens/home_screen.dart';
import '../constants/api_path.dart';
import '../screens/user_info_sign_up_screen.dart';
import '../screens/phone_auth_sign_up.dart';
import '../screens/auth_choice.dart';

import 'query_controller.dart';

class ApiController extends GetxController {
  Map<String, dynamic>? _loggedInUserInfo;
  Map<String, dynamic>? get loggedInUserInfo => _loggedInUserInfo;
  String? _token;
  GraphQLClient? _client;
  GraphQLClient? get client => _client;
  final List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> get products => _products;
  int? _totalPage;
  String apiTokenStorageKey = "apiToken";
  final storage = const FlutterSecureStorage();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  final List<File?> _productImages = [];
  List<File?> get productImages => _productImages;
  final List<WishList> _wishlists = [];
  List<WishList> get wishlists => _wishlists;
  final List<Product> _productSearchs = [];
  List<Product> get productSearchs => _productSearchs;

  Map<String, dynamic>? _wishlistMap;
  Map<String, dynamic>? get wishlistMap => _wishlistMap;
//
//
//
//
//
//
//
//
//
  //* will set loggedInUserInfo variable to the value passed through this function
  void setLoggedInUserInfo(Map<String, dynamic> userInfo) {
    _loggedInUserInfo = userInfo;
    update();
  }

  void addToProductImages(File? imageFile) {
    _productImages.add(imageFile);
    update();
  }

  void clearProductImages() {
    _productImages.clear();
    update();
  }

  void removeFromProductImages(int index) {
    _productImages.removeAt(index);
    update();
  }

  void setAuthToken(String token) async {
    _token = token;
    await storage.write(key: apiTokenStorageKey, value: _token);
    update();
  }

  //*will check if there is actually a token in secure storage
  Future<bool> checkIfUserIsLoggedIn() async {
    String? apiToken = await storage.read(key: apiTokenStorageKey);
    if (apiToken == null) {
      return false;
    } else {
      _token = apiToken;
      update();
      return true;
    }
  }

  //*will set client of graphql api with the auth token as a header
  void setClient() {
    final _httpLink = HttpLink(kbaseUrl);
    final _authLink = AuthLink(getToken: () async => 'Bearer $_token');
    print("Token: $_token");
    Link _link = _authLink.concat(_httpLink);
    _client = GraphQLClient(cache: GraphQLCache(), link: _link);
  }

  void signUpUser(File file, String deviceToken, username, email, phoneNumber, BuildContext context) async {
    final myFile = await http.MultipartFile.fromPath('profileImage', file.path, contentType: MediaType('image', 'jpeg'));
    final MutationOptions options = MutationOptions(
      document: gql(Get.find<QueryController>().signUpUser()),
      variables: <String, dynamic>{
        'file': myFile,
        'deviceToken': deviceToken,
        'username': username,
        'email': email,
        'phoneNumber': phoneNumber,
        'dateJoined': DateTime.now().toString(),
      },
    );
    final QueryResult result = await _client!.mutate(options);
    if (result.hasException) print(result.exception.toString());
    if (result.data != null) {
      setAuthToken(result.data!['createUser']['token']);
      setLoggedInUserInfo(result.data!['createUser']['user']);
      if (_loggedInUserInfo != null) {
        Navigator.pushReplacement(context, transition.Transition(child: HomeScreen(userInfo: _loggedInUserInfo), transitionEffect: transition.TransitionEffect.FADE, curve: Curves.easeIn));
      }
    } else {
      print("data: $result.data");
    }
    update();
  }

  Future<bool> addProduct(String name, String price, String? category, String description, BuildContext context) async {
    Uint8List _firstImageAsUint8List = _productImages[0]!.readAsBytesSync();
    var _firstImage = await decodeImageFromList(_firstImageAsUint8List);
    var blurHash = await blurhash.BlurHash.encode(_firstImageAsUint8List, 4, 3);

    List<http.MultipartFile> _productMultipartImages = [];
    for (var xfile in _productImages) {
      final myFile = await http.MultipartFile.fromPath('productImage', File(xfile!.path).path, contentType: MediaType('image', 'jpeg'));
      _productMultipartImages.add(myFile);
    }
    final MutationOptions options = MutationOptions(
      document: gql(Get.find<QueryController>().addProduct()),
      variables: <String, dynamic>{
        'files': _productMultipartImages,
        'name': name,
        'price': price,
        'description': description,
        'category': category,
        'height': _firstImage.height,
        'width': _firstImage.width,
        'blurHash': blurHash,
        'datePosted': DateTime.now().toString(),
      },
    );
    final QueryResult result = await _client!.mutate(options);
    if (result.hasException) print(result.exception.toString());
    if (result.data != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result.data!['createProduct']['name'] + " has been successfully added.", style: const TextStyle(color: Colors.black)), backgroundColor: Colors.white));
      update();
      return true;
    } else {
      print("data: $result.data");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Adding $name Failed", style: const TextStyle(color: Colors.black)), backgroundColor: Colors.white));
      return false;
    }
  }

  //
  //*wishlist

  Future<bool> addToWishList(int productId) async {
    final MutationOptions options = MutationOptions(
      document: gql(Get.find<QueryController>().addWishList()),
      variables: <String, dynamic>{
        'productId': productId,
        'userId': loggedInUserInfo!['id'],
      },
    );
    final QueryResult result = await _client!.mutate(options);
    if (result.hasException) {
      print(result.exception.toString());
      return false;
    }
    Map<String, dynamic>? data = result.data;
    _wishlists.add(WishList.fromJson(data!['addWishList']));
    update();
    return true;
  }

  Future<bool> searchProduct(String productName) async {
    final MutationOptions options = MutationOptions(
      document: gql(Get.find<QueryController>().searchProduct()),
      variables: <String, dynamic>{
        'name': productName,
      },
    );
    final QueryResult result = await _client!.mutate(options);
    if (result.hasException) {
      print(result.exception.toString());
      return false;
    }
    Map<String, dynamic>? data = result.data;
    for (var product in data!['findProductsByName']) {
      _productSearchs.add(Product.fromJson(product));
    }
    update();
    return true;
  }

  Future<bool> getWishLists(int userId) async {
    _wishlists.clear();
    final QueryOptions options = QueryOptions(document: gql(Get.find<QueryController>().getWishlists(userId)), variables: <String, dynamic>{});
    final QueryResult result = await _client!.query(options);
    if (result.hasException) {
      print(result.exception.toString());
      return false;
    }
    Map<String, dynamic>? _data = result.data;
    _wishlistMap = _data;
    for (var wishlist in _data!['wishlists']) {
      _wishlists.add(WishList.fromJson(wishlist));
    }
    update();
    return true;
  }

  bool checkFavorite(int id) {
    bool isFavorite = false;
    _wishlists.map((e) {
      if (int.parse(e.id) == id) {
        isFavorite = true;
      }
    });
    return isFavorite;
  }

  //* for verifying phoneNumber using firebase
  void verifyPhone(String phoneNumber, BuildContext context) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      // * this call back gets called when the verification is done automatically
      verificationFailed: (error) => print(error),
      verificationCompleted: (phoneAuthCredential) async {
        Navigator.pop(context);
        UserCredential result = await _auth.signInWithCredential(phoneAuthCredential);
        if (result.user != null) {
          user = result.user;
          print("phoneNumber: " + user!.phoneNumber.toString());
          Map<String, dynamic>? _data = await findUserByPhoneNumberAndSignIn(phoneNumber);
          if (_data == null) {
            Navigator.pushReplacement(context, transition.Transition(child: UserInfoSignUpScreen(phoneNumber: phoneNumber), transitionEffect: transition.TransitionEffect.RIGHT_TO_LEFT));
          } else {
            setAuthToken(_data['userByPhone']['token']);
            setLoggedInUserInfo(_data['userByPhone']['user']);
            if (_loggedInUserInfo != null) {
              Navigator.pushReplacement(context, transition.Transition(child: HomeScreen(userInfo: _loggedInUserInfo), transitionEffect: transition.TransitionEffect.FADE, curve: Curves.easeIn));
            }
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong with sms code')));
        }
      },
      codeSent: (verificationId, forceResendingToken) async {
        Navigator.pop(context);
        showModalBottomSheet(
          context: context,
          builder: (context) => PhoneOtpVerificationScreen(phoneNumber: phoneNumber, verificationId: verificationId, forceResend: forceResendingToken),
          enableDrag: false,
          isDismissible: false,
          isScrollControlled: true,
        );
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
    update();
  }

  //* is called from the PhoneOtpVerificationScreen
  void checkCode(String verificationId, String smsCode, BuildContext context, String phoneNumber) async {
    AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
    UserCredential result = await _auth.signInWithCredential(credential);
    if (result.user != null) {
      user = result.user;
      print("*phoneNumber: " + user!.phoneNumber.toString());
      Map<String, dynamic>? _data = await findUserByPhoneNumberAndSignIn(phoneNumber);
      if (_data == null) {
        Navigator.pushReplacement(context, transition.Transition(child: UserInfoSignUpScreen(phoneNumber: phoneNumber), transitionEffect: transition.TransitionEffect.RIGHT_TO_LEFT));
      } else {
        setAuthToken(_data['userByPhone']['token']);
        setLoggedInUserInfo(_data['userByPhone']['user']);
        if (_loggedInUserInfo != null) {
          Navigator.pushReplacement(context, transition.Transition(child: HomeScreen(userInfo: _loggedInUserInfo), transitionEffect: transition.TransitionEffect.FADE, curve: Curves.easeIn));
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong with sms code')));
    }
    update();
  }

  void signOutUser(BuildContext context) async {
    await storage.write(key: apiTokenStorageKey, value: null);
    Navigator.pushAndRemoveUntil(context, transition.Transition(child: const AuthChoice(), transitionEffect: transition.TransitionEffect.LEFT_TO_RIGHT), (route) => false);
  }

  Future<Map<String, dynamic>?> findUserByPhoneNumberAndSignIn(String phoneNumber) async {
    final QueryOptions options = QueryOptions(document: gql(Get.find<QueryController>().findUserByPhoneNumber(phoneNumber: phoneNumber)), variables: <String, dynamic>{});
    final QueryResult result = await _client!.query(options);
    if (result.hasException) print(result.exception.toString());
    Map<String, dynamic>? _data = result.data;
    return _data;
  }

  //* signs in user using auth token found in _token variable
  Future<bool> signInWithToken(BuildContext context) async {
    final QueryOptions options = QueryOptions(document: gql(Get.find<QueryController>().loginUserByToken), variables: <String, dynamic>{});
    final QueryResult result = await _client!.query(options);
    if (result.hasException) {
      print(result.exception.toString());
      return false;
    }
    setLoggedInUserInfo(result.data!['loginUserByToken']);
    if (_loggedInUserInfo != null) {
      Navigator.pushReplacement(context, transition.Transition(child: HomeScreen(userInfo: _loggedInUserInfo), transitionEffect: transition.TransitionEffect.FADE, curve: Curves.easeIn));
    }
    return true;
  }

  //* fetchs products by using the page passed through it
  Future<String> getProducts(int page) async {
    if (page == 1) {
      _products.clear();
      _totalPage = 0;
      update();
    }
    if (page <= _totalPage! || page == 1) {
      print("page to load " + page.toString());
      final QueryOptions options = QueryOptions(document: gql(Get.find<QueryController>().getProducts(page)), variables: <String, dynamic>{});
      final QueryResult result = await _client!.query(options);
      if (result.hasException) {
        print(result.exception.toString());
        return "fail";
      }
      if (page == 1) {
        _totalPage = result.data!['products']['pages'];
        print("TotalPage: " + _totalPage.toString());
      }
      List productsFromApi = result.data!['products']['products'];
      for (var product in productsFromApi) {
        _products.add(product);
      }
      update();
    } else {
      return "over";
    }
    return "done";
  }
}
