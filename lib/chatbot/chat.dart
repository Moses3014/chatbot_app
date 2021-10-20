// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:bubble/bubble.dart';
import 'package:flutter/widgets.dart';
import 'components/component.dart';
import 'helper/theme.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'services/database.dart';
import 'components/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Chat extends StatefulWidget {
  // final String chatRoomId;
  final String? user;
  final String? gcuser;
  final String? lcuser;
  final String? requisition;
  final String? companyName;

  Chat(
      {Key? key,
      this.companyName,
      this.user,
      this.gcuser,
      this.lcuser,
      this.requisition});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  String? user,
      chatRoomId,
      userType,
      project_name,
      activity_name,
      sub_activity_name;
  late int userid;
  Stream<QuerySnapshot>? chats;
  Stream<QuerySnapshot>? premsg;
  Stream<QuerySnapshot>? user_chats;
  String token =
      "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwidXNlcl9pZCI6NjUwNywiaXNfYWN0aXZlIjp0cnVlLCJOYW1lIjoiTW9zZXMgR0MiLCJNb2JpbGUgTm8iOiIxMjM0NTY3ODkwIiwidGVybXNfY29uZGl0aW9uX2FjY2VwdGVkIjp0cnVlLCJ3aGF0c2FwcF9hY2NlcHRlZCI6dHJ1ZSwiRW1haWwiOiJtb3Nlcy5hcmVwZWxsaUBjYXAtdGVjaC5pbiIsIkxhbmd1YWdlIjoiZW4tVVMiLCJwZXJtaXNzaW9uIjpbeyJpZCI6MjMsImlzX2FjdGl2ZSI6dHJ1ZSwibW9kdWxlX25hbWUiOiJnZW5lcmFsX2NvbnRyYWN0b3IiLCJwZXJtaXNzaW9uX25hbWUiOiJ2aWV3X2djX2NvbXBhbnlfcHJvZmlsZSJ9LHsiaWQiOjMzLCJpc19hY3RpdmUiOnRydWUsIm1vZHVsZV9uYW1lIjoicHJvamVjdCIsInBlcm1pc3Npb25fbmFtZSI6InByb2plY3RfbGlzdF92aWV3In0seyJpZCI6MzUsImlzX2FjdGl2ZSI6dHJ1ZSwibW9kdWxlX25hbWUiOiJwcm9qZWN0IiwicGVybWlzc2lvbl9uYW1lIjoiZWRpdF9wcm9qZWN0X3Byb2ZpbGUifSx7ImlkIjozNiwiaXNfYWN0aXZlIjp0cnVlLCJtb2R1bGVfbmFtZSI6InByb2plY3QiLCJwZXJtaXNzaW9uX25hbWUiOiJ2aWV3X3Byb2plY3RfcHJvZmlsZSJ9LHsiaWQiOjM4LCJpc19hY3RpdmUiOnRydWUsIm1vZHVsZV9uYW1lIjoicHJvamVjdCIsInBlcm1pc3Npb25fbmFtZSI6ImZpbHRlcl9zZWFyY2hfcHJvamVjdF9wcm9maWxlIn0seyJpZCI6NDEsImlzX2FjdGl2ZSI6dHJ1ZSwibW9kdWxlX25hbWUiOiJyZXF1aXNpdGlvbiIsInBlcm1pc3Npb25fbmFtZSI6InJlcXVpc2l0aW9uX2xpc3RfdmlldyJ9LHsiaWQiOjQyLCJpc19hY3RpdmUiOnRydWUsIm1vZHVsZV9uYW1lIjoicmVxdWlzaXRpb24iLCJwZXJtaXNzaW9uX25hbWUiOiJhZGRfcmVxdWlzaXRpb24ifSx7ImlkIjo0MywiaXNfYWN0aXZlIjp0cnVlLCJtb2R1bGVfbmFtZSI6InJlcXVpc2l0aW9uIiwicGVybWlzc2lvbl9uYW1lIjoiZWRpdF9yZXF1aXNpdGlvbiJ9LHsiaWQiOjQ0LCJpc19hY3RpdmUiOnRydWUsIm1vZHVsZV9uYW1lIjoicmVxdWlzaXRpb24iLCJwZXJtaXNzaW9uX25hbWUiOiJkZWxldGVfcmVxdWlzaXRpb24ifSx7ImlkIjo0NSwiaXNfYWN0aXZlIjp0cnVlLCJtb2R1bGVfbmFtZSI6InJlcXVpc2l0aW9uIiwicGVybWlzc2lvbl9uYW1lIjoiZmlsdGVyX3NlYXJjaF9yZXF1aXNpdGlvbiJ9LHsiaWQiOjQ2LCJpc19hY3RpdmUiOnRydWUsIm1vZHVsZV9uYW1lIjoicmVxdWlzaXRpb24iLCJwZXJtaXNzaW9uX25hbWUiOiJyZWFjdGl2YXRlX3JlcXVpc2l0aW9uIn0seyJpZCI6NDcsImlzX2FjdGl2ZSI6dHJ1ZSwibW9kdWxlX25hbWUiOiJyZXF1aXNpdGlvbiIsInBlcm1pc3Npb25fbmFtZSI6InNlYXJjaF9yZXF1aXNpdGlvbiJ9LHsiaWQiOjQ4LCJpc19hY3RpdmUiOnRydWUsIm1vZHVsZV9uYW1lIjoicmVxdWlzaXRpb24iLCJwZXJtaXNzaW9uX25hbWUiOiJzaG9ydGxpc3RfcmVxdWlzaXRpb24ifSx7ImlkIjo0OSwiaXNfYWN0aXZlIjp0cnVlLCJtb2R1bGVfbmFtZSI6InJlcXVpc2l0aW9uIiwicGVybWlzc2lvbl9uYW1lIjoiYmxhY2tsaXN0X3JlcXVpc2l0aW9uIn0seyJpZCI6NTEsImlzX2FjdGl2ZSI6dHJ1ZSwibW9kdWxlX25hbWUiOiJzdWJfY29udHJhY3RvciIsInBlcm1pc3Npb25fbmFtZSI6InZpZXdfbGNfY29tcGFueV9wcm9maWxlIn0seyJpZCI6MTYsImlzX2FjdGl2ZSI6dHJ1ZSwibW9kdWxlX25hbWUiOiJtYXN0ZXJzIiwicGVybWlzc2lvbl9uYW1lIjoibWFzdGVyX2NvbmZpZ3VyYXRpb25fbGlzdF92aWV3In0seyJpZCI6MjIsImlzX2FjdGl2ZSI6dHJ1ZSwibW9kdWxlX25hbWUiOiJnZW5lcmFsX2NvbnRyYWN0b3IiLCJwZXJtaXNzaW9uX25hbWUiOiJnY19saXN0X3ZpZXdfcHJvZmlsZXMifSx7ImlkIjozMywiaXNfYWN0aXZlIjp0cnVlLCJtb2R1bGVfbmFtZSI6InByb2plY3QiLCJwZXJtaXNzaW9uX25hbWUiOiJwcm9qZWN0X2xpc3RfdmlldyJ9LHsiaWQiOjcwLCJpc19hY3RpdmUiOnRydWUsIm1vZHVsZV9uYW1lIjoidXNlcnMiLCJwZXJtaXNzaW9uX25hbWUiOiJlZGl0X2RldmljZV9pbmZvIn1dLCJyb2xlIjp7ImlkIjoyLCJpc19hY3RpdmUiOnRydWUsInJvbGVfbmFtZSI6ImdjX3VzZXIifSwiZXhwIjoxNjY1MjQ5MzMwfQ.U7Eshpzuo8eN5e_9LBwycFCZt_G-86AddLHFMP9KDiY";
  List<Map<String, dynamic>> recordMsgs = [];
  // List<String> premsgs = [];
  List<Map<String, dynamic>>? premsgs = [];
  List<Map<String, dynamic>>? temp_chats = [];
  List<Map<String, dynamic>>? user_chat_list = [];

  TextEditingController messageEditingController = TextEditingController();
  DatabaseMethods databaseMethods = DatabaseMethods();
  Connect con = Connect();
  bool state = false;

  late Timer _timer;

  void startTimer() {
    const oneSec = const Duration(seconds: 60);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        getConnection();
      },
    );
  }

  Future onMessageTap({i, msg}) async {
    var count = 1;
    var record;
    print("Records : $recordMsgs");

    Map<String, dynamic> chatMessageMap = {
      "sendBy": user,
      "msg": msg,
      "count": count,
      "time": DateTime.now().millisecondsSinceEpoch,
      "state": "sent",
    };
    print("before if : $recordMsgs");
    // ignore: unnecessary_null_comparison
    if (recordMsgs != null) {
      print("true");
      if (recordMsgs.isNotEmpty) {
        print("true2");
      } else {
        print("Length: ${recordMsgs.length}");
        print("false2");
      }
    } else {
      print("false");
    }
    // ignore: unnecessary_null_comparison
    if (recordMsgs != null && recordMsgs.length > 0) {
      print("Has records");
      print("Showing Records: $recordMsgs");
      /* Manage recordMsgs */

      record = recordMsgs.lastWhere((element) => element["msg"] == msg,
          orElse: () => {"msg": "empty"});
      print("Records local : $record");
      // print("Records local : $record");

      /* Cross Verify Msg */
      if (record["msg"] == msg) {
        /* Count Increment Logic start */
        print(record["msg"]);
        var counttmp = record["count"];
        counttmp++;
        record["count"] = counttmp;
        count = record["count"];
        chatMessageMap = {
          "sendBy": user,
          "msg": msg,
          "count": count,
          'time': DateTime.now().millisecondsSinceEpoch,
          "state": "sent",
        };
        /* Count Increment Logic end */

        /* Msg Restriction based on number of messages sent start */
        if (count <= 3) {
          print("Count is $count");

          /* Msg Restriction based on date and time start */
          DateTime date = DateTime.fromMillisecondsSinceEpoch(record["time"]);
          // DateTime date = DateTime(2021,09,23); // test date
          DateTime plusdate = date.add(Duration(days: 1));
          // DateTime plusdate = DateTime(2021, 09, 23); // test date
          DateTime today = DateTime.now();
          // DateTime today = DateTime(2021,09,23); // test date

          // if (today.isAfter(date) && today.compareTo(plusdate) >= 0) { Old logic has defect!!
          if (today.compareTo(plusdate) >= 0) {
            // if today is = plus one day or greter then the date is above 00:00am in midnight.
            /* Internal Logic for msgs */
            /* Count logic application on this if statement */
            if (count < 3) {
              switch (record["msg"]) {
                case "Not interested":
                  CDialog cd = CDialog(
                      context: context,
                      bt2color: Colors.white,
                      btcolor: Colors.black,
                      btn2: true,
                      bt2text: "Cancel",
                      bt2bgcolor: myTheme.primaryColor,
                      tcolor: Colors.red[900],
                      function: () {
                        print("Disable chat with this chatroom.");
                        print("M4 : $chatMessageMap");
                        FirebaseFirestore.instance
                            .collection("chatRoom")
                            .doc(chatRoomId)
                            .update({"status": "disabled"});

                        recordMsgs.add(chatMessageMap);
                        DatabaseMethods()
                            .addMessage(this.chatRoomId!, chatMessageMap);
                        Navigator.of(context).pop();
                      },
                      function2: () {
                        print("Stay in the chat!");
                      });
                  cd.dialogShow("Warning!",
                      "This requisition will be closed for you.", "OK");
                  break;
                case "I am interested":

                  /* Logic for sending custom msg on msg initiation but is optional so will be doing it later
                        but comment it for the time being. */
                  // bool firsttime = true;
                  // if (firsttime) {
                  chatMessageMap = {
                    "sendBy": user,
                    // "intrested": true,
                    "msg": record["msg"],
                    "count": count,
                    'time': DateTime.now().millisecondsSinceEpoch,
                    "state": "sent",
                  };
                  print("M5 : $chatMessageMap");
                  recordMsgs.add(chatMessageMap);
                  DatabaseMethods()
                      .addMessage(this.chatRoomId!, chatMessageMap);
                  // }
                  break;
                default:
                  print("M6 : $chatMessageMap");
                  recordMsgs.add(chatMessageMap);
                  DatabaseMethods()
                      .addMessage(this.chatRoomId!, chatMessageMap);
              }
            }
          } else {
            Fluttertoast.showToast(
                msg: "Each message can only be sent once per day");
          }
          /* Msg Restriction based on date and time end */
        } else {
          Fluttertoast.showToast(msg: "Each message can only be sent 3 times");
        }
        /* Msg Restriction based on number of messages sent end */
        print("Records 2 : $recordMsgs");
        print("Record local : $record");
      } else {
        switch (msg) {
          case "Not interested":
            CDialog cd = CDialog(
                context: context,
                bt2color: Colors.white,
                btcolor: Colors.black,
                btn2: true,
                bt2text: "Cancel",
                bt2bgcolor: myTheme.primaryColor,
                tcolor: Colors.red[900],
                function: () {
                  print("Disable chat with this chatroom.");
                  print("M7 : $chatMessageMap");
                  FirebaseFirestore.instance
                      .collection("chatRoom")
                      .doc(chatRoomId)
                      .update({"status": "disabled"});
                  recordMsgs.add(chatMessageMap);
                  DatabaseMethods()
                      .addMessage(this.chatRoomId!, chatMessageMap);
                  Navigator.of(context).pop();
                },
                function2: () {
                  print("Stay in the chat!");
                });
            cd.dialogShow(
                "Warning!", "This requisition will be closed for you.", "OK");
            break;
          case "I am interested":

            /* Logic for sending custom msg on msg initiation but is optional so will be doing it later
                        but comment it for the time being. */
            // bool firsttime = true;
            // if (firsttime) {
            chatMessageMap = {
              "sendBy": user,
              // "intrested": true,
              "msg": msg,
              "count": count,
              'time': DateTime.now().millisecondsSinceEpoch,
              "state": "sent",
            };
            print("M8 : $chatMessageMap");
            recordMsgs.add(chatMessageMap);
            DatabaseMethods().addMessage(this.chatRoomId!, chatMessageMap);
            // setState(() {
            //   premsgs.remove(record["msg"]);
            // });
            // }
            break;
          default:
            print("M9 : $chatMessageMap");
            recordMsgs.add(chatMessageMap);
            DatabaseMethods().addMessage(this.chatRoomId!, chatMessageMap);
          // setState(() {
          //   recordMsgs!.remove(record["msg"]);
          // });
        }
        print("Does not have records of same msg adding the first one");
        // DatabaseMethods().addMessage(this.chatRoomId!!, chatMessageMap);
      }
      // }
    } else {
      switch (msg) {
        case "Not interested":
          CDialog cd = CDialog(
              context: context,
              bt2color: Colors.white,
              btcolor: Colors.black,
              btn2: true,
              bt2text: "Cancel",
              bt2bgcolor: myTheme.primaryColor,
              tcolor: Colors.red[900],
              function: () {
                print("Disable chat with this chatroom.");
                print("M10 : $chatMessageMap");
                FirebaseFirestore.instance
                    .collection("chatRoom")
                    .doc(chatRoomId)
                    .update({"status": "disabled"});
                recordMsgs.add(chatMessageMap);
                DatabaseMethods().addMessage(this.chatRoomId!, chatMessageMap);
                setState(() {
                  // premsgs
                  Navigator.of(context).pop(); //.remove(record["msg"]);
                });
              },
              function2: () {
                print("Stay in the chat!");
              });
          cd.dialogShow(
              "Warning!", "This requisition will be closed for you.", "OK");
          break;
        case "I am interested":

          /* Logic for sending custom msg on msg initiation but is optional so will be doing it later
                      but comment it for the time being. */
          // bool firsttime = true;
          // if (firsttime) {
          chatMessageMap = {
            "sendBy": this.user,
            // "intrested": true,
            "msg": msg,
            "count": count,
            'time': DateTime.now().millisecondsSinceEpoch,
            "state": "sent",
          };
          print("M11 : $chatMessageMap");
          recordMsgs.add(chatMessageMap);
          DatabaseMethods().addMessage(this.chatRoomId!, chatMessageMap);
          // setState(() {
          //   premsgs.remove(msg);
          // });
          // }
          break;
        default:
          print("M12 : $chatMessageMap");
          recordMsgs.add(chatMessageMap);
          DatabaseMethods().addMessage(this.chatRoomId!, chatMessageMap);
        // setState(() {
        //   recordMsgs!.remove(msg);
        // });
      }

      print("Does not have records");
      // DatabaseMethods().addMessage(this.chatRoomId!!, chatMessageMap);
    }
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                // itemCount: snapshot.data!!.documents.length,
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  checkState().then((value) {
                    if (snapshot.data!.docs[index].get("state") == "sent") {
                      if (this.user == widget.gcuser) {
                        // Send Notification to LC
                        sendNotification(snapshot.data!.docs[index].get("msg"));
                      } else if (this.user == widget.lcuser) {
                        // Send Notification to GC
                        sendNotification(snapshot.data!.docs[index].get("msg"));
                      }
                    }
                  });

                  DateTime date = DateTime.fromMillisecondsSinceEpoch(
                      snapshot.data!.docs[index].get("time"));
                  var format = DateFormat("h:mm a");
                  var timeString = format.format(date);
                  // ignore: unused_local_variable
                  var msg, count, sendByMe, state;
                  msg = snapshot.data!.docs[index].get("msg");
                  count = snapshot.data!.docs[index].get("count");
                  state = snapshot.data!.docs[index].get("state");

                  sendByMe =
                      this.user == snapshot.data!.docs[index].get("sendBy")
                          ? 0
                          : 1;

                  // Map<String, dynamic> tmp = {
                  //   "msg": msg,
                  //   "sendBy": sendByMe,
                  //   "time": snapshot.data!.docs[index].get("time"),
                  //   "count": count,
                  //   "state": state,
                  // };
                  // recordMsgs.add(tmp);
                  return Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: sendByMe == 0
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0,
                          ),
                          child: Bubble(
                            radius: Radius.circular(5.0),
                            nip: sendByMe == 0
                                ? BubbleNip.rightBottom
                                : BubbleNip.leftBottom,
                            color: sendByMe == 0
                                // ? Colors.grey[200]
                                // : Colors.amber[700],
                                ? Color(0xff373737)
                                : Color(0xff818182),
                            nipRadius: 0,
                            elevation: 0.0,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 5.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Flexible(
                                    child: Container(
                                      constraints:
                                          BoxConstraints(maxWidth: 200),
                                      child: Column(
                                        children: [
                                          Container(
                                            alignment: sendByMe == 0
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                            child: Text(
                                              "$msg",
                                              style: TextStyle(
                                                color: sendByMe == 0
                                                    ? Color(0xffe0e0e0)
                                                    : Colors.white,
                                                // fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            alignment: sendByMe == 0
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                            child: Row(
                                              mainAxisAlignment: sendByMe == 0
                                                  ? MainAxisAlignment.end
                                                  : MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  timeString,
                                                  style: TextStyle(
                                                    color: sendByMe == 0
                                                        ? Color(0xffe0e0e0)
                                                        : Colors.white,
                                                    fontSize: 8.0,
                                                  ),
                                                ),
                                                sendByMe == 0
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Icon(
                                                          Icons.done_all,
                                                          size: 10,
                                                          color: state == "sent"
                                                              ? Colors.grey
                                                              : Colors.green,
                                                        ),
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                })
            : Container();
      },
    );
  }

  Widget manageStream() {
    print("Started fn");
    if (userType != null) {
      if (userType!.isNotEmpty) {
        return StreamBuilder(
          stream: premsg,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            print("Inside Stream");
            if (snapshot.hasData &&
                // ignore: unnecessary_null_comparison
                snapshot.data!.docs != null &&
                snapshot.data!.docs.isNotEmpty) {
              snapshot.data!.docs.forEach((e) {
                print("Length of PreMsgs : ${premsgs!.length}");
                // print("Premsgs : $premsgs");
              });
              return SingleChildScrollView(
                child: Wrap(
                  spacing: 10.0,
                  children: premsgs!
                      .map((e) {
                        return FittedBox(
                          child: ElevatedButton(
                            onPressed: () {
                              print("Message : ${e["msg"]}");
                              if (e["clicked"] &&
                                  e["msg"] != "Not interested") {
                                Fluttertoast.showToast(
                                    msg: "This Message is disabled");
                              } else {
                                onMessageTap(
                                  i: premsgs!.indexOf(e),
                                  msg: e["msg"],
                                ).then((value) {
                                  print(
                                      "Length of PreMsgs : ${premsgs!.length}");
                                  print("in then");
                                  print(
                                      "Data : ${e["clicked"]} && ${e["msg"]}");
                                  setState(() {
                                    /**Commented For testing purpose */
                                    if (e["clicked"] == false &&
                                        e["msg"] != "Not interested")
                                      premsgs!.remove(
                                          premsgs![premsgs!.indexOf(e)]);
                                  });
                                });
                              }
                            },
                            child: Container(
                              child: Text(
                                "${e["msg"]}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10.0),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0)),
                            ),
                          ),
                          // child: Container(
                          //   margin: EdgeInsets.symmetric(
                          //       vertical: 8.0, horizontal: 10.0),
                          //   padding: EdgeInsets.symmetric(
                          //       horizontal: 10.0, vertical: 8.0),
                          //   constraints: BoxConstraints(minWidth: 100.0),
                          //   decoration: BoxDecoration(
                          //     color: e["clicked"]
                          //         ? Colors.grey[800]
                          //         : myTheme.primaryColor,
                          //     borderRadius: BorderRadius.circular(50),
                          //   ),
                          //   child: Center(
                          //     child: Text(
                          //       // recordMsgs![i]["msg"],
                          //       // premsgs[i],
                          //       e["msg"],
                          //       style: TextStyle(
                          //         color: Colors.white,
                          //         fontSize: 10.0,
                          //       ),
                          //       textAlign: TextAlign.center,
                          //     ),
                          //   ),
                          // ),
                        );
                      })
                      .toList()
                      .cast<Widget>(),
                ),
              );
            } else {
              return Container();
            }
          },
        );
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  Future startChat(
      String user, String gcuser, String lcuser, String requisition) async {
    List<String> users = [gcuser, requisition, lcuser];
    String chatRoomId = getChatRoomId(gcuser, lcuser, requisition);
    setState(() {
      this.chatRoomId = chatRoomId;
    });
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .get()
        .then((docSnapshot) {
      if (!docSnapshot.exists) {
        Map<String, dynamic> chatRoom = {
          "users": users,
          "chatRoomId": chatRoomId,
          "status": "enabled",
        };
        databaseMethods.addChatRoom(chatRoom, chatRoomId);
      }
    });
  }

  getChatRoomId(String a, String b, String c) {
    var tmpa = a.substring(0, 1);
    print("Temp A : $tmpa");
    var tmpb = b.substring(0, 1);
    print("Temp B : $tmpb");

    var tmpua = a.substring(0, 1).codeUnitAt(0);
    print("Temp A : $tmpua");
    var tmpub = b.substring(0, 1).codeUnitAt(0);
    print("Temp B : $tmpub");

    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      print("$b\_$c\_$a");
      return "$b\_$c\_$a";
    } else {
      print("$a\_$c\_$b");
      return "$a\_$c\_$b";
    }
  }

  Future checkState() async {
    await DatabaseMethods().getChats(chatRoomId!).then((val) async {
      user_chats = val;
      await user_chats!.listen((event) async {
        event.docs.forEach((e) async {
          Map<String, dynamic> temp = {
            "msg": "${e.get("msg")}",
            "count": e.get("count"),
            "time": e.get("time"),
            "sendBy": "${e.get("sendBy")}",
            "state": "seen",
            // "uid": "${e.id}",
          };
          if (e.get("state") == "sent" &&
              e.get("sendBy") != user &&
              (e.get("sendBy") == widget.gcuser ||
                  e.get("sendBy") == widget.lcuser)) {
            if (e.exists) {
              await FirebaseFirestore.instance
                  .collection("chatRoom")
                  .doc(chatRoomId)
                  .collection("chats")
                  .doc(e.id)
                  .update(temp)
                  .onError((error, stackTrace) {
                print("Update Error: $error");
                print("Update StackTrace : $stackTrace");
              });
              print("Document Exists and is updated");
            }
            print("Temp Print : $temp");
            print("Receivers Chat");
          } else {
            print("Senders Chat");
          }
        });
      });
    });
  }

  Future initFn() async {
    getRequisition();
    if (this.user == widget.gcuser) {
      // Call LC API
      userType = "gc";
      getLC(widget.lcuser);
    } else if (this.user == widget.lcuser) {
      // Call GC API
      userType = "lc";
      getGC(widget.gcuser);
    }
    startChat(widget.user!, widget.gcuser!, widget.lcuser!, widget.requisition!)
        .then((value) async {
      await DatabaseMethods().getChats(this.chatRoomId!).then((val) async {
        print("Got Value Chat : $val");
        // setState(() {
        chats = val;
        await chats!.listen((event) {
          event.docs.forEach((e) {
            Map<String, dynamic> temp = {
              "msg": "${e.get("msg")}",
              "count": e.get("count"),
              "time": e.get("time"),
              "sendBy": "${e.get("sendBy")}",
              "state": "${e.get("state")}",
            };
            if (temp_chats!.contains(temp)) {
              print("Already has data");
            } else {
              print("Does not have data so adding");
              if (this.mounted)
                setState(() {
                  temp_chats!.add(temp);
                });
            }
            print("Length of Temp Chats : ${temp_chats!.length}");
            print("Temp Chats : $temp_chats");
          });
        });
        // });
        // print("Chats List : $temp_chats");
        await DatabaseMethods().getPreMsgs().then((val) async {
          // setState(() {
          premsg = val;
          await premsg!.listen((event) {
            event.docs.forEach((e) {
              Map<String, dynamic> temp = {
                "msg": "${e.get("msg")}",
                "userType": "${e.get("userType")}",
                "clicked": false,
              };
              if (premsgs!.contains(temp)) {
                print("Already has data");
              } else {
                print("Does not have data so adding");
                if (userType == e.get("userType")) {
                  if (this.mounted)
                    setState(() {
                      premsgs!.add(temp);
                    });
                }
              }
              print("Length of PreMsgs : ${premsgs!.length}");
              print("Premsgs : $premsgs");
            });
          });
          // });
          // print("Premsg List : $premsgs");
        });
      });
    });
    await checkState();
    // await DatabaseMethods().getChats(chatRoomId!).then((val) async {
    //   user_chats = val;
    //   await user_chats!.listen((event) async {
    //     event.docs.forEach((e) async {
    //       Map<String, dynamic> temp = {
    //         "msg": "${e.get("msg")}",
    //         "count": e.get("count"),
    //         "time": e.get("time"),
    //         "sendBy": "${e.get("sendBy")}",
    //         "state": "seen",
    //         // "uid": "${e.id}",
    //       };
    //       if (e.get("state") == "sent" &&
    //           e.get("sendBy") != user &&
    //           (e.get("sendBy") == widget.gcuser ||
    //               e.get("sendBy") == widget.lcuser)) {
    //         if (e.exists) {
    //           await FirebaseFirestore.instance
    //               .collection("chatRoom")
    //               .doc(chatRoomId)
    //               .collection("chats")
    //               .doc(e.id)
    //               .update(temp)
    //               .onError((error, stackTrace) {
    //             print("Update Error: $error");
    //             print("Update StackTrace : $stackTrace");
    //           });
    //           print("Document Exists and is updated");
    //         }
    //         print("Temp Print : $temp");
    //         print("Receivers Chat");
    //       } else {
    //         print("Senders Chat");
    //       }
    //     });
    //   });
    // });

    /* Conditions to be loaded in 2 seconds to remove unwanted premessages --start-- */
    /*Commenting this section for testing */
    Future.delayed(Duration(seconds: 2)).then((value) {
      print("Chats List : $temp_chats");
      print("Premsg List : $premsgs");
      List templist = [];
      temp_chats!.forEach((element) {
        Map<String, dynamic> tmp = {
          "msg": element["msg"],
          "sendBy": element["sendBy"],
          "time": element["time"],
          "count": element["count"],
          "state": element["state"],
        };
        if (element["sendBy"] == user) {
          if (this.mounted)
            setState(() {
              recordMsgs.add(tmp);
            });
        }
        premsgs!.forEach((e) {
          if (element["msg"] == e["msg"]) {
            int time = element["time"];
            DateTime date =
                DateTime.fromMillisecondsSinceEpoch(time, isUtc: true);
            DateTime plusdate = date.add(Duration(days: 1));
            DateTime today = DateTime.now();
            print(
                "Compare Value is : ${today.compareTo(plusdate)} Epoch is : ${element["time"]}");
            if (today.isBefore(plusdate) && today.compareTo(plusdate) <= 0) {
              print(
                  "Today is before msg time + 1day and less than equal to plus one day");
              if (element["sendBy"] == this.user) {
                templist.add(e);
              }
            }
          }
        });
      });
      print("Temp Removal List : $templist");
      templist.forEach((e) {
        if (premsgs!.contains(e)) {
          setState(() {
            premsgs!.remove(e);
          });
        }
      });
    });
    /* Conditions to be loaded in 2 seconds to remove unwanted premessages --end-- */

    /* Handle State if chatRoom is marked disabled --start-- */
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .get()
        .then((value) {
      if (value.exists) {
        if (value.get("status") == "disabled") {
          CDialog cd = CDialog(
              context: context,
              tcolor: Colors.red,
              function: () {
                Navigator.of(context).pop();
              });
          cd.dialogShow("Sorry", "This Conversation has been closed!", "OK");
          Future.delayed(Duration(seconds: 5)).then((value) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        }
      }
    });
    /* Handle State if chatRoom is marked disabled --end-- */
  }

  Future getConnection() async {
    if (await con.check() == true) {
      // print("true in appbar");
      if (mounted)
        setState(() {
          state = true;
        });
    } else {
      // print("false in appbar");
      if (mounted)
        setState(() {
          state = false;
        });
    }
  }

  Future<void> getGC(gcuser) async {
    final response = await http.get(
        Uri.parse(
            "http://43.241.39.78:4808/general-contractor/get-gc/?id=$gcuser&is_active=True"),
        headers: {
          "Accept": "*/*",
          "Authorization": token,
        });
    var data = json.decode(response.body);
    print("GC Data: $data");
    var result = data["data"]["results"][0];
    setState(() {
      userid = result["user"][0]["id"];
      print("ID is $userid");
    });
  }

  Future<void> getLC(lcuser) async {
    final response = await http.get(
      Uri.parse(
          "http://43.241.39.78:4808/sub_contractor/get/?id=$lcuser&is_active=True"),
      headers: {
        "Accept": "*/*",
        "Authorization": token,
      },
    );
    var data = json.decode(response.body);
    print("LC Data: $data");
    var result = data["data"]["results"][0];
    setState(() {
      userid = result["owner"]["id"];
      print("ID is $userid");
    });
  }

  Future<void> sendNotification(body) async {
    print("before send");
    String suser =
        (widget.user == widget.gcuser ? widget.lcuser : widget.gcuser)!;
    final response = await http.post(
      Uri.parse(
          "http://43.241.39.78:5508/app-notification/post-push-notification/"),
      headers: {
        "Accept": "*/*",
        "Authorization": token,
      },
      body: {
        "user_id": userid.toString(),
        "title": "You've got a chat!",
        "body": "$body",
        "app_path":
            '{"module": "chatbot", "companyName": "${widget.companyName}", "gcuser":"${widget.gcuser}","lcuser":"${widget.lcuser}","user":"$suser","requisition":"${widget.requisition}"}',
        "push_notification_template_id": "1",
      },
    );
    print("after send");
    var data = json.decode(response.body);
    print("Notification Data: $data");
  }

  Future<void> getRequisition() async {
    final response = await http.get(
        Uri.parse(
            "http://43.241.39.78:4808/requisition/get/?id=${widget.requisition}"),
        headers: {
          "Accept": "*/*",
          "Authorization": token,
        });
    var data = json.decode(response.body);
    print("GC Data: $data");
    var result = data["data"]["results"][0];
    setState(() {
      project_name = result["project"]["project_name"];
      activity_name = result["activity"]["activity_name"];
      sub_activity_name = result["sub_activity"]["sub_activity_name"];
      print(
          "Required Details = projectName: $project_name activityName: $activity_name subActivityName: $sub_activity_name");
    });
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    _timer.cancel();
    recordMsgs.clear();
    premsgs!.clear();
    temp_chats!.clear();
    user_chat_list!.clear();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      user = widget.user;
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await initFn();
    });
    getConnection();
    Future.delayed(Duration(seconds: 1)).then((value) => startTimer());
  }

  @override
  Widget build(BuildContext context) {
    var title;
    if (userType == "gc") {
      setState(() {
        title = widget.companyName;
      });
    } else if (userType == "lc" && project_name != null) {
      setState(() {
        title = project_name;
      });
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: appBarMain(
          context: context,
          title: title,
          state: state,
          activity_name: activity_name,
          sub_activity_name: sub_activity_name,
        ),
      ),

      // appBarMain(context),
      body: Theme(
        data: myTheme,
        child: Container(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(
                    top: 25.0,
                    bottom: MediaQuery.of(context).size.height * 0.07),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/bg-chat.png"),
                  ),
                ),
                alignment: Alignment.topCenter,
                // width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Container(
                  child: chatMessages(),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  // height: 200.0,
                  // height: MediaQuery.of(context).size.height * 0.30,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 10.0, bottom: 5.0),
                  decoration: BoxDecoration(
                    // color: Color(0xff181919),
                    color: Colors.grey[200],
                    borderRadius: BorderRadiusDirectional.only(
                      topEnd: const Radius.circular(20.0),
                      topStart: const Radius.circular(20.0),
                    ),
                  ),
                  // child: preDefinedMessages(),
                  child: manageStream(),
                ),
              ),
              Positioned(
                top: 10.0,
                left: (MediaQuery.of(context).size.width / 2) * 0.75,
                child: Container(
                  alignment: Alignment.center,
                  height: 20.0,
                  constraints: BoxConstraints(maxWidth: 100),
                  decoration: BoxDecoration(
                    color: Color(0xffafbcbf),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Today, ${DateFormat("Hm").format(DateTime.now())}",
                    style: TextStyle(fontSize: 8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
