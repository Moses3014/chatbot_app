import 'package:chatbot/chatbot/helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart'; //  connectivity: ^0.4.2
// import 'package:flutter/services.dart'; // To detect Platform in barcode
// import 'package:image_picker/image_picker.dart'; //  image_picker: ^0.5.0+6
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared_preferences/shared_preferences.dart'; // shared_preferences: ^0.5.1+2
import 'package:intl/intl.dart'; //  intl: ^0.15.8

// import 'package:barcode_scan/barcode_scan.dart'; //   barcode_scan: ^0.0.4
// import 'package:flutter/services.dart'; // For PlatformException in barcode_scan
/*
Note:-
  Remember To await Future return type functions.
*/
class CDialog {
  final BuildContext? context;
  final Color? bt2bgcolor;
  final Color? tcolor;
  final Color? bcolor;
  final Color? btcolor, bt2color;
  final bool? btn2;
  final Function? function;
  final Function? function2;
  String? title, body, bttext, bt2text;
  CDialog({
    this.context,
    this.tcolor,
    this.bcolor,
    this.btcolor,
    this.function,
    this.btn2,
    this.function2,
    this.bt2text,
    this.bt2color,
    this.bt2bgcolor,
  });
  void dialogShow(String title, String body, String btnText) {
    // flutter defined function
    this.title = title;
    this.body = body;
    bttext = btnText;

    // Old Dialog
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     // return object of type Dialog
    //     return AlertDialog(
    //       title: Text(
    //         title,
    //         style: TextStyle(color: tcolor),
    //       ),
    //       content: Text(
    //         body,
    //         style: TextStyle(color: bcolor),
    //       ),
    //       // actionsAlignment: btn2 != null ? MainAxisAlignment.spaceAround : MainAxisAlignment.center,
    //       actions: <Widget>[
    //         // usually buttons at the bottom of the dialog
    //         TextButton(
    //           child: Text(
    //             btnText,
    //             style: TextStyle(color: btcolor),
    //           ),
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //             function();
    //           },
    //         ),
    //         btn2 != null
    //             ? ElevatedButton(
    //                 style: ElevatedButton.styleFrom(
    //                   primary: bt2bgcolor,
    //                 ),
    //                 onPressed: () {
    //                   Navigator.of(context).pop();
    //                   function2();
    //                 },
    //                 child: Text(
    //                   bt2text,
    //                   style: TextStyle(color: bt2color),
    //                 ),
    //               )
    //             : Container(),
    //       ],
    //     );
    //   },
    // );

    // New Dialog
    showDialog(
        context: context!,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ), //this right here
            child: Container(
              height: 250,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        title,
                        style: TextStyle(color: tcolor),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                        child: Center(child: Text(body)),
                      ),
                    ),
                    ButtonBar(
                      alignment: btn2 != null && btn2 == true
                          ? MainAxisAlignment.spaceEvenly
                          : MainAxisAlignment.center,
                      children: [
                        // usually buttons at the bottom of the dialog
                        TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: myTheme.primaryColor, width: 2),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          child: Text(
                            btnText,
                            style: TextStyle(color: btcolor),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            function!();
                          },
                        ),
                        btn2 != null
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: bt2bgcolor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  function2!();
                                },
                                child: Text(
                                  bt2text!,
                                  style: TextStyle(color: bt2color),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  String getTitle() {
    return title!;
  }

  String getBody() {
    return body!;
  }

  String getBText() {
    return bttext!;
  }
}

class Connect {
  var ret;
  Connect() {
    ret = check();
  }
  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      ret = true;
      return ret;
    } else {
      ret = false;
      return ret;
    }
  }
}

// class Camera{

//   Future<File> getImage() async{
//     // var image = await ImagePicker.pickImage(source: ImageSource.camera);
//     var image = await ImagePicker().pickImage(source:   ImageSource.camera);
//     return image;
//   }

//   Future<File> getGallery() async{
//     var image = await ImagePicker().pickImage(source: ImageSource.gallery);
//     return image;
//   }
// }

class Shared {
  String? str;
  int? numint;
  double? numdouble;
  bool? boolval;
  setShared(String skey, String name) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(skey, name);
  }

  setSharedInt(String skey, int name) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt(skey, name);
  }

  setSharedDouble(String skey, double name) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setDouble(skey, name);
  }

  setSharedBool(String skey, bool name) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(skey, name);
  }

  getShared(val) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    str = pref.getString(val);
    return str;
  }

  getSharedInt(val) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    numint = pref.getInt(val);
    return numint;
  }

  getSharedDouble(val) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    numdouble = pref.getDouble(val);
    return numdouble;
  }

  getSharedBool(val) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    boolval = pref.getBool(val);
    return boolval;
  }

  remove(val) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(val);
  }

  check(val) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool check = pref.containsKey(val);
    return check;
  }

  clear() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}

class DateTimePicker {
  String dformat(date) {
    date = DateTime.parse(date);
    return DateFormat('dd-MM-yyyy').format(date);
  }

  Function? functiond;
  Function? functiont;
  DateTimePicker({this.functiond, this.functiont});
  DateTime selectedDate = DateTime.now();
  DateTime? picked_d;

  Future<Null> selectDate(BuildContext context) async {
    this.picked_d = (await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1947, 1),
      lastDate: DateTime(2101),
    ))!;
    checkd();
  }

  checkd() {
    if (picked_d != null && picked_d != selectedDate) {
      selectedDate = picked_d!;
    }
  }

  String getDate() {
    String currentDate = DateFormat('dd-MM-yyyy').format(selectedDate);
    return currentDate;
  }

  String tformat(date) {
    date = DateTime.parse(date);
    return DateFormat('dd-MM-yyyy').format(date);
  }

  TimeOfDay time =
      TimeOfDay.fromDateTime(DateTime.parse('2018-10-20 16:30:04Z')); // 4:30pm
  TimeOfDay? picked_t;
  BuildContext? contextt;

  Future<Null> selectTime(contextt) async {
    this.picked_t = (await showTimePicker(
      context: contextt,
      initialTime: time,
    ))!;
    checkt();
    functiont!();
  }

  checkt() {
    if (picked_t != null && picked_t != time) {
      time = picked_t!;
    }
  }

  String getTime() {
    String formatedTime = time.format(contextt!);
    return formatedTime;
  }
}

// class QR{
//     Future _scanQR() async {
//     try {
//       String qrResult = await BarcodeScanner.scan().toString();
//         return qrResult;
//         print(qrResult);
//     } on PlatformException catch (ex) {
//       if (ex.code == BarcodeScanner.cameraAccessDenied) {
//           return "Camera permission was rejected";
//       } else {
//           return "Unknown Error $ex";
//       }
//     } on FormatException {
//         return "You pressed the back button before scanning anything";
//     } catch (ex) {
//         return "Unknown Error $ex";
//     }
//   }

// }

Widget buildTextField(
    String label, TextEditingController controller, bool isPassword) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
    ),
    obscureText: isPassword,
  );
}
