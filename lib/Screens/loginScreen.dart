import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptoboost/Screens/homeScreen.dart';
import 'package:cryptoboost/Screens/registrationScreen.dart';
import 'package:cryptoboost/Utils/snackBar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailCtrl = TextEditingController();
  var passwordCtrl = TextEditingController();

  var _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String errorMsg = "";

  void login() async {
    setState(() {
      isLoading = true;
    });
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailCtrl.text, password: passwordCtrl.text);
      var id = userCredential.user!.uid;
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection("users").doc(id).get();
      var userDetails = {
        "user_id": doc["user_id"],
        "Username": doc["Username"],
        "Email": doc["Email"]
      };
      var route = MaterialPageRoute(
          builder: (context) => HomeScreen(user: userDetails));
      Navigator.push(context, route);
    } catch (e) {
      setState(() {
        errorMsg = e.toString();
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  int count = 0;
  goBack() {
    if (count >= 2) {
      SystemNavigator.pop();
    } else {
      count++;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        goBack();
        showSnackBar(context, "Double Tap to Exit");
        return await false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 80, left: 30, right: 30),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                      height: size.height / 3,
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(45),
                          image: DecorationImage(
                              image: AssetImage("assets/images/crypto.jpg"),
                              fit: BoxFit.cover))),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        label: Text("E-mail"),
                        hintText: "Enter Your E-mail Address",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.email)),
                    validator: (value) {
                      var emailValid = EmailValidator.validate(value!);
                      if (!emailValid) {
                        return "Invalid E-mail Address";
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: passwordCtrl,
                    decoration: InputDecoration(
                        label: Text("Password"),
                        hintText: "Enter Your Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.lock)),
                    validator: (value) {
                      if (value!.length < 6) {
                        return "Password too short";
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    child: CircularProgressIndicator(),
                    visible: isLoading,
                  ),
                  Text(
                    errorMsg,
                    style: TextStyle(color: Colors.red),
                  ),
                  MaterialButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        login();
                      }
                    },
                    child: Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    color: Colors.blue,
                    shape: StadiumBorder(),
                    minWidth: 200,
                    height: 50,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Do Not Have An Account ?",
                        style: TextStyle(fontSize: 17, color: Colors.black),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          var route = MaterialPageRoute(
                              builder: (context) => RegistrationScreen());
                          Navigator.push(context, route);
                        },
                        child: Text("Register",
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
