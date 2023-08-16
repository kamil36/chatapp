
import 'package:app_chat/models/user_model.dart';
import 'package:app_chat/pages/signup_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

   TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void checkValues(){
    String email = emailController.text.trim();
        String password = passwordController.text.trim();
        if(email==""||password=="" ){
          print("Please fill all the fields!");
        }
        else{
          logIn(email , password);
        }
  }
      void logIn(String email, String password)async{
        UserCredential? credential;
        try{
          credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        } on FirebaseAuthException catch(ex){
          print(ex.message.toString());
        }
        if(credential!= null){
          String uid = credential.user!.uid;
          DocumentSnapshot userData = await FirebaseFirestore.instance.collection("users").doc(uid).get();
          UserModel userModel = UserModel.fromMap(userData.data() as Map<String, dynamic>);

          print("Log In Successful!");
        }

      }




  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Chat App",
                  style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: emailController,
                    decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  hintText: "Enter a Email",
                  labelText: "Email Address",
                )),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: passwordController,
                  autofocus: false,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.password_outlined),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    hintText: "Enter a Password",
                    labelText: "Password",
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(200, 60),
                        backgroundColor: Colors.deepPurpleAccent),
                    onPressed: () {
                      checkValues();
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
              ],
            ),
          ),
        ),
      )),
      bottomNavigationBar: Container(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account?",
              style: TextStyle(fontSize: 20),
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SignUpPage();
                  }));
                },
                child: Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 22),
                )),
          ],
        ),
      )),
    );
  }
}
