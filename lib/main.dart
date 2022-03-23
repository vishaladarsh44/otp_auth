import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otpauth/otpauth/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Task());
}

class Task extends StatefulWidget {
  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text("Task"),
          ),
          body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        "https://images.unsplash.com/photo-1593642533144-3d62aa4783ec?ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1469&q=80"),
                    fit: BoxFit.cover)
                    ),
            child: Center(
              child: Column(
                children: [
                  Text(
                  count.toString(),
                  style: TextStyle(fontSize: 40),
                  ),
                  FloatingActionButton(
                  onPressed: () {
                    setState(() {
                  count = count + 2;
                    });
                  },
                  child: Icon(Icons.add),
                  ),
                  Login(),
                ],
              ),
            ),
          )), 
    );
  }
}
