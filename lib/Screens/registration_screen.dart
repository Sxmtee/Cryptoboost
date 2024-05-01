// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptoboost/Screens/home_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  var emailCtrl = TextEditingController();
  var usernameCtrl = TextEditingController();
  var passwordCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();
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
        builder: (context) => HomeScreen(user: userDetails),
      );
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
  void dispose() {
    super.dispose();
    emailCtrl.dispose();
    usernameCtrl.dispose();
    passwordCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 50, left: 30, right: 30),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  height: size.height / 3,
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(45),
                    image: const DecorationImage(
                      image: AssetImage("assets/images/crypto.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    label: const Text("E-mail"),
                    hintText: "Enter Your E-mail Address",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.email),
                  ),
                  validator: (value) {
                    var emailValid = EmailValidator.validate(value!);
                    if (!emailValid) {
                      return "Invalid E-mail Address";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: usernameCtrl,
                  decoration: InputDecoration(
                    label: const Text("Username"),
                    hintText: "Enter Your Username",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Fill This Field";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: passwordCtrl,
                  decoration: InputDecoration(
                    label: const Text("Password"),
                    hintText: "Enter Your Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value!.length < 6) {
                      return "Password weak";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: isLoading,
                  child: const CircularProgressIndicator(),
                ),
                Text(
                  errorMsg,
                  style: const TextStyle(color: Colors.red),
                ),
                MaterialButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      register();
                    }
                  },
                  color: Colors.blue,
                  shape: const StadiumBorder(),
                  minWidth: 200,
                  height: 50,
                  child: const Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already Have An Account ?",
                      style: TextStyle(fontSize: 17, color: Colors.black),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
