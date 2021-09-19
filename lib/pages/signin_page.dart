import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:herewego/pages/home_page.dart';
import 'package:herewego/pages/signup_page.dart';
import 'package:herewego/services/auth_service.dart';
import 'package:herewego/services/prefs_service.dart';
import 'package:herewego/services/utils_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key key}) : super(key: key);
  static String id = "signin_page";

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  bool isLoading = false;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  _doSignIn(){

    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();

    if(email.isEmpty || password.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    AuthService.signInUser(context, email, password).then((firebaseUser) => {
      _getFirebaseUser(firebaseUser),
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
                  onPressed: _doSignIn,
                  child: Text("SignIn", style: TextStyle(color: Colors.white),),
                ),
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Don't  have an account?", style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(width: 10,),
                    TextButton(
                      onPressed: (){
                        Navigator.pushReplacementNamed(context, SignUpPage.id);
                      },
                      child: Text("Sign Up", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
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
