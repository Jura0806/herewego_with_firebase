import 'package:flutter/material.dart';
import 'package:herewego/services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);
  static String id = "home_page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text("Home"),
      ),
      body: Center(
        child: MaterialButton(
          elevation: 0,
          color: Colors.deepOrange,
          onPressed: (){
          AuthService.signOutUser(context);
          },
          child: Text("Logout", style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}
