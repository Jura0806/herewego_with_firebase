import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:herewego/pages/signin_page.dart';
import 'package:herewego/services/auth_service.dart';
import 'package:herewego/services/prefs_service.dart';
import 'package:herewego/services/utils_service.dart';

import 'home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key key}) : super(key: key);
  static String id = "signup_page";

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  bool isLoading = false;

  var fullNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  _doSignUp(){

    String name = fullNameController.text.toString().trim();
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();

    if(name.isEmpty || email.isEmpty || password.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    AuthService.signUpUser(context, name, email, password).then((firebaseUser) => {
      _getFirebaseUser(firebaseUser)
    });
  }

  _getFirebaseUser(FirebaseUser firebaseUser) async{

    setState(() {
      isLoading = false;
    });
    if(firebaseUser != null){
      await Prefs.savUserId(firebaseUser.uid);
      Navigator.pushReplacementNamed(context, HomePage.id);
    }else{
      Utils.fireToast("Check your email or password");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: fullNameController,
                  decoration: InputDecoration(
                    hintText: "FullName",
                  ),
                ),
                SizedBox(height: 20,),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Email",
                  ),
                ),
                SizedBox(height: 20,),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: "Password",
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 10,),
                MaterialButton(
                  elevation: 0,
                  minWidth: double.infinity,
                  color: Colors.deepOrange,
                  onPressed: _doSignUp,
                  child: Text("SignUp", style: TextStyle(color: Colors.white),),
                ),
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Already  have an account?", style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(width: 10,),
                    TextButton(
                      onPressed: (){
                        Navigator.pushReplacementNamed(context, SignInPage.id);
                      },
                      child: Text("Sign In", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
                    )
                  ],
                ),
              ],
            ),
          ),
          isLoading ? Center(
            child: CircularProgressIndicator(),
          ) : SizedBox.shrink()
        ],
      )
    );
  }
}
