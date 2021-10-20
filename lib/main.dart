import 'package:chatbot/chatbot/helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'chatbot/chat.dart';
import 'chatbot/services/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatBot Testing',
      theme: myTheme,
      home: const MyHomePage(title: 'ChatBot Testing'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _gcuser = TextEditingController();
  TextEditingController _lcuser = TextEditingController();
  TextEditingController _requisition = TextEditingController();
  TextEditingController _user = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DatabaseMethods databaseMethods = DatabaseMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // ignore: prefer_const_literals_to_create_immutables
          children: <Widget>[
            const Text(
              'Press the Message Icon to start the chat.',
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please Enter the ID";
                        }
                      },
                      // ignore: prefer_const_constructors
                      decoration: InputDecoration(
                        hintText: "GC ID",
                      ),
                      controller: _gcuser,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please Enter the ID";
                        }
                      },
                      // ignore: prefer_const_constructors
                      decoration: InputDecoration(
                        hintText: "Requisition ID",
                      ),
                      controller: _requisition,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please Enter the ID";
                        }
                      },
                      // ignore: prefer_const_constructors
                      decoration: InputDecoration(
                        hintText: "LC ID",
                      ),
                      controller: _lcuser,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please Enter the User";
                        }
                      },
                      // ignore: prefer_const_constructors
                      decoration: InputDecoration(
                        hintText: "User",
                      ),
                      controller: _user,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => Chat(
                        key: Key("${_user.text}"),
                        companyName: "PVR Enterprise",
                        gcuser: _gcuser.text,
                        lcuser: _lcuser.text,
                        requisition: _requisition.text,
                        user: _user.text,
                      )),
            );
          }
        },
        tooltip: 'Chat',
        child: const Icon(Icons.chat),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
