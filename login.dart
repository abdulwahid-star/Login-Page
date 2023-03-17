import 'package:checkup_pro/Authentication/authentication.dart';
import 'package:checkup_pro/Authentication/forgot_password.dart';
import 'package:checkup_pro/Authentication/register.dart';
import 'package:checkup_pro/Widgets/Roles.dart';
import 'package:checkup_pro/Widgets/bottom_navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Patient/home_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    //String email = '', pass = '';
    final email = TextEditingController();
    final pass = TextEditingController();

    // bool changeButton = false;
    final _formKey = GlobalKey<FormState>();

    moveToHome(BuildContext context) async {
      if (_formKey.currentState!.validate()) {
        await Future.delayed(const Duration(seconds: 1));
        await Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const BottomNavigation()));
      }
    }

    return WillPopScope(
      onWillPop: () async{
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const Authentication()));
        return false;
      },
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('Assets/Images/login.png'), fit: BoxFit.cover),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Container(),
              Container(
                padding: const EdgeInsets.only(left: 35, top: 130),
                child: const Text(
                  'Welcome\nBack',
                  style: TextStyle(color: Colors.white, fontSize: 33),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(top: 350),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 35, right: 35),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: email,
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    labelText: 'Email',
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: "Enter Email",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Email can not be empty";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              TextFormField(
                                controller: pass,
                                style: const TextStyle(),
                                obscureText: true,
                                decoration: InputDecoration(
                                    labelText: 'Password',
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: "Enter Password",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Password can not be empty";
                                  } else if (value.length < 6) {
                                    return "Password should be atleast 8 characters";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Sign in',
                                    style: TextStyle(
                                        fontSize: 27,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: const Color(0xff4c505b),
                                    child: IconButton(
                                        color: Colors.white,
                                        onPressed: () async {
                                          // try {
                                          //   final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                          //     email: email,
                                          //     password: pass
                                          //   );
                                          //   Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HomePage()));
                                          // } on FirebaseAuthException catch (e) {
                                          //   if (e.code == 'user-not-found') {
                                          //     print('No user found for that email.');
                                          //   } else if (e.code == 'wrong-password') {
                                          //     print('Wrong password provided for that user.');
                                          //   }
                                          // }

                                          await FirebaseAuth.instance
                                              .signInWithEmailAndPassword(
                                                  email: email.text,
                                                  password: pass.text)
                                              .then((user) async {
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(user.user!.uid)
                                                .set({'loggedIn': true});
                                            toast(context,
                                                'Email or password exists');
                                            moveToHome(context);
                                            // final post = await FirebaseFirestore
                                            //     .instance
                                            //     .collection("checkup_pro")
                                            //     .where('email',
                                            //         isEqualTo: email.text)
                                            //     .where('password',
                                            //         isEqualTo: pass.text)
                                            //     .get()
                                            //     .then((value) async {
                                            //   if (value.docs.isNotEmpty) {
                                            //     toast(context,
                                            //         'Email or password exists');
                                            //     moveToHome(context);
                                            //   } else {
                                            //     toast(context,
                                            //         'Invalid email or password');
                                            //     if (_formKey.currentState!
                                            //         .validate()) {}
                                            //   }
                                            //   return value.docs[0].reference;
                                            // });
                                            // var batch = FirebaseFirestore.instance
                                            //     .batch();
                                            // batch.update(post, {
                                            //   'createdAt': DateTime.now()
                                            //       .millisecondsSinceEpoch
                                            // });
                                            // batch.commit();
                                          }).catchError((error) {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text('Error'),
                                                      content: Text(
                                                          'Invalid email or password'),
                                                      actions: [
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text('OK'),
                                                        )
                                                      ],
                                                    );
                                                  });
                                            }
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.arrow_forward,
                                        )),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const Register()));
                                    },
                                    style: const ButtonStyle(),
                                    child: const Text(
                                      'Sign Up',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Color(0xff4c505b),
                                          fontSize: 18),
                                    ),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    ForgotPassword()));
                                      },
                                      child: const Text(
                                        'Forgot Password',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Color(0xff4c505b),
                                          fontSize: 18,
                                        ),
                                      )),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  valid(QuerySnapshot<Map<String, dynamic>> value) {
    if (value.docs.isEmpty) {
      return 'Email or password exists';
    }
  }

  toast(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
