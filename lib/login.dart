import 'dart:developer' as dev;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uber/home.dart';
import 'package:uber/main.dart';
import 'package:uber/register.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 45),
            const Image(
              image: AssetImage("assets/images/logo.png"),
              width: 390,
              height: 350,
              alignment: Alignment.center,
            ),
            const SizedBox(height: 1),
            const Text(
              "Login as a Rider",
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Brand Bold',
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 1),
                  TextFormField(
                    controller: txtEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(
                        fontSize: 14,
                      ),
                      hintText: "someone@example.com",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 1),
                  TextFormField(
                    controller: txtPass,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(
                        fontSize: 14,
                      ),
                      hintText: "********",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  RaisedButton(
                    color: Colors.yellow,
                    textColor: Colors.white,
                    onPressed: () {
                      validation(context);
                    },
                    child: const SizedBox(
                      height: 50,
                      child: Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Brand Bold',
                          ),
                        ),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ],
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const Register(),
                  ),
                );
              },
              child: const Text(
                'Do not have an Account? Register here.',
              ),
            ),
          ],
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void login(_) async {
    try {
      UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(
        email: txtEmail.text,
        password: txtPass.text,
      );

      if (user != null) {
        dev.log(user.user.toString(), name: '# LOGIN USER');
        usersRef.child(user.user!.uid).once().then(
              (value) => (snap) {
                if (snap.value != null) {
                  Navigator.of(_).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const Home(),
                    ),
                  );
                  Toast(_, "New user account has been created successfully");
                } else {
                  _firebaseAuth.signOut();

                  Toast(_,
                      "No recored exists for this user please create new account");
                }
              },
            );
      } else {
        Toast(_, "New user account has not been created");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Toast(_, "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        Toast(_, "The account already exists for that email.");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Toast(_, msg) async {
    return Fluttertoast.showToast(msg: msg);
  }

  validation(_) {
    if (!txtEmail.text.contains("@")) {
      Toast(
        context,
        "Email address is not valid.",
      );
    } else if (txtPass.text.length < 7) {
      Toast(
        context,
        "Password must be at least 6 characters.",
      );
    } else {
      login(context);
    }
  }
}
