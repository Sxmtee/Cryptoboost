import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptoboost/Screens/homeScreen.dart';
import 'package:cryptoboost/Screens/loginScreen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  var emailCtrl = TextEditingController();
  var usernameCtrl = TextEditingController();
  var passwordCtrl = TextEditingController();

  var _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String errorMsg = "";

  void register() async {
    setState(() {
      isLoading = true;
    });
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailCtrl.text, password: passwordCtrl.text);
      var id = userCredential.user!.uid;
      var userDetails = {
        "user_id": id,
        "Username": usernameCtrl.text,
        "Email": emailCtrl.text,
        "Password": passwordCtrl.text
      };
      FirebaseFirestore.instance.collection("users").doc(id).set(userDetails);
      var route = MaterialPageRoute(
          builder: (context) => HomeScreen(user: userDetails));
      Navigator.push(context, route);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMsg = e.toString();
      });
      // print(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50, left: 30, right: 30),
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
                  controller: usernameCtrl,
                  decoration: InputDecoration(
                      label: Text("Username"),
                      hintText: "Enter Your Username",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.person)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Fill This Field";
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
                      return "Password weak";
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
                      register();
                    }
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
                      "Already Have An Account ?",
                      style: TextStyle(fontSize: 17, color: Colors.black),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        var route = MaterialPageRoute(
                            builder: (context) => LoginScreen());
                        Navigator.push(context, route);
                      },
                      child: Text("Login",
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
    );
  }
}
