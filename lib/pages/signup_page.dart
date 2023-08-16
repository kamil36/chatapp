
import 'package:app_chat/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpasswordController = TextEditingController();

   void checkValues(){
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cpassword = cpasswordController.text.trim();
    
    if(email == "" || password== ""|| cpassword=="" ){
      print("Please fill all the fields!");
    }else if(password!=cpassword){
      print("Password do not match!");
    }else {
     signUp(email, password);

    }
  }

  void signUp(String email, String password)async{

    UserCredential? credential;

    try {
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch(ex){
        print(ex.code.toString());
    }

    if(credential!=null){
      String uid = credential.user!.uid;
      UserModel newUser = UserModel(
        uid: uid,
        email: email,
        fullname: "",
        profilepic: "",
      );
      await FirebaseFirestore.instance.collection("users").doc(uid).set(newUser.topMap()).then((value) {
        print("New user created!");
      });
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
                  "SignUp Page",
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
                  height: 20,
                ),
                TextField(
                controller: cpasswordController,
                  autofocus: false,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.password_outlined),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    hintText: "Enter a Password",
                    labelText: "Confirm Password",
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
                      "SingUp",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ))
              ],
            ),
          ),
        ),
      )),
      bottomNavigationBar: Container(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Text(
              "Already have an account?",
              style: TextStyle(fontSize: 20),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 22),
                )),
          ],
        ),
      )),
    );
  }
}
