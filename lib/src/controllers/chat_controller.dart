import 'package:get/get.dart';
import 'package:graphql/client.dart';
import 'package:shopri/src/constants/api_path.dart';
import 'package:shopri/src/controllers/api_controller.dart';
import 'package:shopri/src/controllers/query_controller.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatController extends GetxController {
  late Socket _socket;
  Map<String, dynamic>? _conversations;
  Map<String, dynamic>? get conversations => _conversations;
  Map<String, dynamic>? _messages;
  Map<String, dynamic>? get messages => _messages;
  Map<String, dynamic>? loggedInUser = Get.find<ApiController>().loggedInUserInfo;

  ChatController() {
    connectToServer();
  }

  void connectToServer() {
    print('connecting to socket...');
    try {
      _socket = io(socketPathUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });
      _socket.connect();
      _socket.on('connect', (_) => print('connected to socket with id: ${_socket.id}'));
      _socket.on('receive-message-from-room', onReceiveMessage);
    } catch (e) {
      print('connecting failed.');
      print(e.toString());
    }
  }

  //adds new message received from socket io to the list of messages
  void onReceiveMessage(message) {
    int convId = 1;
    int senderId = 1;
    int messageId = 1;
    // String senderName = loggedInUser!['username'];
    // _messages.add(
    //   Message(conversationId: convId, senderId: senderId, senderName: senderName, messageText: message, timeSent: DateTime.now(), id: messageId),
    // );
    convId = convId + 1;
    senderId = senderId + 1;
    messageId = messageId + 1;
    print('message: $message');
    update();
  }

  Future<bool> getConversations(int userId) async {
    final GraphQLClient? _client = Get.find<ApiController>().client;
    final QueryOptions options = QueryOptions(document: gql(Get.find<QueryController>().getConversations(userId)), variables: <String, dynamic>{});
    final QueryResult result = await _client!.query(options);
    if (result.hasException) {
      print(result.exception.toString());
      return false;
    }
    Map<String, dynamic>? _data = result.data;
    _conversations = _data;
    update();
    return true;
  }

  Future<bool> getMessages(int convId) async {
    final GraphQLClient? _client = Get.find<ApiController>().client;
    final QueryOptions options = QueryOptions(document: gql(Get.find<QueryController>().getMessages(convId)), variables: <String, dynamic>{});
    final QueryResult result = await _client!.query(options);
    if (result.hasException) {
      print(result.exception.toString());
      return false;
    }
    Map<String, dynamic>? _data = result.data;
    _messages = _data;
    update();
    return true;
  }

  // Future<Map<String, dynamic>?> findUserByPhoneNumberAndSignIn(String phoneNumber) async {
  //   final QueryOptions options = QueryOptions(document: gql(Get.find<QueryController>().findUserByPhoneNumber(phoneNumber: phoneNumber)), variables: <String, dynamic>{});
  //   final QueryResult result = await _client!.query(options);
  //   if (result.hasException) print(result.exception.toString());
  //   Map<String, dynamic>? _data = result.data;
  //   return _data;
  // }
  //posts message, finds device token by using receiverId, sends notification using the device token, emits the message to the room with the convId
  // Future<bool> sendMessageToRoom({required String message, required String convId, required String senderId, required String senderName, required String receiverId}) async {
  //   // print('send message called using:\nmessage: $message\nconvId: $convId\nsenderId: $senderId\nsenderName: $senderName\nreceiverId: $receiverId');
  //   try {
  //     bool result = await postMessage(convId: convId, senderId: senderId, receiverId: receiverId, senderName: senderName, messageText: message);
  //     if (result) {
  //       print('***saved message to DB successfully');
  //       print('***updated conversation info successfully');
  //       _socket.emit('send-message-to-room', {"message": message, "roomName": convId});
  //       print('***emmited message successfully');
  //       return true;
  //     }
  //   } catch (e) {
  //     print(e);
  //     return false;
  //   }
  //   return false;
  // }

  //for posting new message
  // Future<bool> postMessage({required String convId, required String senderId, required String senderName, required String messageText, required String receiverId}) async {
  //   String? _token = await _storage.read(key: _tokenKey);
  //   Dio _dio = Dio(BaseOptions(
  //     baseUrl: kbaseUrl,
  //     connectTimeout: 20000,
  //     receiveTimeout: 100000,
  //     headers: {'x-access-token': _token},
  //     responseType: ResponseType.json,
  //   ));
  //   try {
  //     final response = await _dio.post(
  //       '/chat/message',
  //       data: {"conversationId": convId, "senderId": senderId, "receiverId": receiverId, "senderName": senderName, "messageText": messageText, "timeSent": DateTime.now().toString()},
  //     );
  //     if (response.statusCode == 201) {
  //       _messages.add(Message.fromJson(response.data['msg']));
  //       if (response.data['dvt'] != "none") {
  //         bool notificationResult = await Get.find<NotificationController>().sendNotificationUsingDeviceToken(response.data['dvt'], senderName, messageText);
  //         if (notificationResult) {
  //           print("***notification sent successfully");
  //         } else {
  //           print("something went wrong while sending notification");
  //         }
  //       } else {
  //         print('device token empty not sending notification');
  //       }
  //       update();
  //       return true;
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  //   return false;
  // }
}
