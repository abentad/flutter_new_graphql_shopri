import 'package:get/get.dart';

class QueryController extends GetxController {
  String getProducts(int page) {
    return """
        query{
          products(page: 1, limit: 15){
            count
            pages
            products{
              id
              views
              name
              price
              description
              category
              image
              datePosted
              height
              width
              blurHash
              images{
                image_id
                url
              }
              poster{
                id
                deviceToken 
                username
                email
                phoneNumber
                profile_image
                dateJoined
              }
            }
          }
        }
    """;
  }

  String getConversations(int userId) {
    return """
        {
          conversations(userId: $userId){
            id
            senderId
            receiverId
            lastMessage
            lastMessageTimeSent
            lastMessageSenderId
            lastMessageSender{
              username
              profile_image
            }
            sender{
              username
              profile_image
            }
            receiver{
              username
              profile_image
            }
          }
        }
    """;
  }

  String getMessages(int convId) {
    return """
        {
          messages(conversationId: $convId){
            id
            conversationId
            senderId
            receiverId
            messageText
            timeSent
            sender{
              username
              profile_image
            }
            receiver{
              username
              profile_image
            }
          }
        }
    """;
  }

  String addMessage() {
    return r"""
      mutation($convId: ID!, $senderId: ID!, $receiverId: ID!, $messageTxt: String!, $timeSent: String!){
        addMessage(data: {
          conversationId: $convId,
          senderId: $senderId,
          receiverId: $receiverId,
          messageText: $messageTxt,
          timeSent: $timeSent
        }){
          id
          conversationId
          senderId
          receiverId
          messageText
          timeSent
          sender{
            username
            profile_image
          }
          receiver{
            username
            profile_image
          }
        }
      }
    """;
  }

  String addWishList() {
    return r"""
        mutation ($productId: ID!, $userId: ID!){
          addWishList(data: {
            productId: $productId,
            userId: $userId
          }) {
            id
            productId
            userId
            product {
              id
              isPending
              views
              name
              price
              description
              category
              image
              datePosted
              posterId
              images {
                image_id
                id
                url
              }
              height
              width
              blurHash
            }
          }
        }
    """;
  }

  String getWishlists(int userId) {
    return """
        {
          wishlists(userId: $userId){
            id
            productId
            userId
            product {
              id
              isPending
              views
              name
              price
              description
              category
              image
              datePosted
              posterId
              images {
                image_id
                id
                url
              }
              poster{
                id
                deviceToken
                username
                profile_image
                dateJoined
                phoneNumber
              }
              height
              width
              blurHash
            }    
          }
        }
    """;
  }

  String searchProduct() {
    return r"""
        mutation ($name: String!){
          findProductsByName(name: $name){
            id
            isPending
            views
            name
            price
            description
            category
            image
            datePosted
            posterId
            poster{
              id
              deviceToken
              username
              email
              phoneNumber
              profile_image
              dateJoined 
            }
            images{
              image_id
              id
              url
            }
            height
            width
            blurHash
          }
        }
    """;
  }

  String addProduct() {
    return r"""
      mutation ($files: [Upload!]!, $name: String!, $price: String!, $description: String!, $height: Int!, $width: Int!, $blurHash: String!, $category: String!, $datePosted: String!) {
        createProduct(
          data: {isPending: "false", views: 0, name: $name, price: $price, height: $height, width: $width, blurHash: $blurHash, description: $description, category: $category, datePosted: $datePosted}
          files: $files
        ) {
          id
          isPending
          views
          name
          price
          description
          category
          image
          datePosted
          height
          width
          blurHash
          poster {
            id
            deviceToken
            username
          }
        }
      }
    """;
  }

  final String loginUserByToken = """
      mutation{
        loginUserByToken{
          id
          username
          email
          profile_image
          phoneNumber
          dateJoined
        }
      }
  """;

  String loginUserByEmailandPass({required String email, required String password}) {
    return """
        mutation{
          loginUser(data: {email: "$email", password: "$password"}){
            token
            user{
              id
              deviceToken
              username
              email
              phoneNumber
              profile_image
              dateJoined 
            }
          }
        }
    """;
  }

  String signUpUser() {
    return r"""
        mutation ($file: Upload!, $deviceToken: String!, $username: String!, $email: String!, $phoneNumber: String!, $dateJoined: String!) {
            createUser(
              data: {deviceToken: $deviceToken, username: $username, email: $email, phoneNumber: $phoneNumber, dateJoined: $dateJoined}
              file: $file
            ) {
              token
              user {
                id
                deviceToken
                username
                email
                phoneNumber
                profile_image
                dateJoined
              }
            }
          }
    """;
  }

  String findUserByPhoneNumber({required String phoneNumber}) {
    return """
        {
          userByPhone(phoneNumber: "$phoneNumber"){
            token
            user{
              id
              deviceToken
              username
              email
              phoneNumber
              profile_image
              dateJoined
            }
          }
        }
    """;
  }
}
