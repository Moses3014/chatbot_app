// import 'package:chatbot/business/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseMethods {
  late var uid = FirebaseAuth.instance.currentUser!.uid;
  // Future<void> addUserInfo(userData) async {
  //   if(AuthService().checkLogin()){
  //     FirebaseFirestore.instance.collection("users").add(userData).catchError((e) {
  //       // ignore: avoid_print
  //       print(e.toString());
  //     });
  //   }
  // }

  getUserInfo(String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: email)
        .get()
        // .getDocuments()
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserInfoWithNumber(String Phone) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("userPhone", isEqualTo: Phone)
        .where("uid", isEqualTo: uid)
        .get()
        // .getDocuments()
        .catchError((e) {
      print(e.toString());
    });
  }

  searchByName(String searchField) {
    return FirebaseFirestore.instance
        .collection("users")
        .where('userName', isEqualTo: searchField)
        .get();
    // .getDocuments();
  }

  Future<bool>? addChatRoom(chatRoom, chatRoomId) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  getChats(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  getPreMsgs() async {
    return FirebaseFirestore.instance
        .collection("premsgs")
        .orderBy("msg")
        .snapshots();
  }

  Future<void>? addMessage(String chatRoomId, chatMessageData) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserChats(String itIsMyName) async {
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }
}
