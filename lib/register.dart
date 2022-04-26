import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uber/login.dart';

import 'home.dart';
import 'main.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtPhone = TextEditingController();
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
              "Register as a Rider",
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
                    controller: txtName,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      labelStyle: TextStyle(
                        fontSize: 14,
                      ),
                      hintText: "john do.",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 1),
                  TextFormField(
                    controller: txtPhone,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Phone",
                      labelStyle: TextStyle(
                        fontSize: 14,
                      ),
                      hintText: "05xxxxxxxxx",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
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
                    onPressed: () => validation(context),
                    child: const SizedBox(
                      height: 50,
                      child: Center(
                        child: Text(
                          "Register",
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const Login(),
                  ),
                );
              },
              child: const Text(
                'Already have an Account? Login here.',
              ),
            ),
          ],
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void register(_) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: txtEmail.text,
        password: txtPass.text,
      );
      if (user != null) {
        Map userDataMap = {
          "name": txtName.text.trim(),
          "phone": txtPhone.text.trim(),
          "email": txtEmail.text.trim(),
          "password": txtPass.text.trim(),
        };
        usersRef.child(user.user!.uid).set(userDataMap);
        Toast(_, "New user account has been created successfully");
        Navigator.of(_).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const Home(),
          ),
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
    if (txtName.text.length < 4) {
      Toast(
        context,
        "Name must be at least 3 characters.",
      );
    } else if (txtPhone.text.isEmpty) {
      Toast(
        context,
        "Phone number is mandatory.",
      );
    } else if (!txtEmail.text.contains("@")) {
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
      register(context);
    }
  }
}
