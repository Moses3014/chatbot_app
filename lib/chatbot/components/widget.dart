// import 'package:chatbot/business/auth_service.dart';
// import 'package:chatbot/views/login.dart';
import '../helper/theme.dart';
import 'package:flutter/material.dart';

PreferredSize appBarMain(
    {BuildContext? context,
    String? title,
    bool? state,
    String? activity_name,
    String? sub_activity_name}) {
  // Connect con = Connect();
  // bool state;
  // if (con.check() == true) {
  //   print("true in appbar");
  //   state = true;
  // } else {
  //   print("false in appbar");
  //   state = false;
  // }

  return PreferredSize(
    preferredSize: const Size.fromHeight(60.0),
    child: Theme(
      data: myTheme,
      child: AppBar(
        title: Column(
          children: [
            Text(
              '$title',
              style: TextStyle(fontSize: 15.0, color: Colors.white),
            ),
            Text(
              '${activity_name != null ? activity_name : ""} / ${sub_activity_name != null ? sub_activity_name : ""}',
              style: TextStyle(fontSize: 9.0, color: Colors.white),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(8.0),
              child: Container(
                height: 5,
                width: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: state! ? Colors.green : Colors.red,
                ),
              ),
            ),
          ],
        ),
        elevation: 0.0,
        centerTitle: false,
        actions: [
          Image.asset(
            "assets/images/logo-chat.png",
            height: 40,
          ),
        ],
      ),
    ),
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white54),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)));
}

TextStyle simpleTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 16);
}

TextStyle biggerTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 17);
}
