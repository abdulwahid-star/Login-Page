import 'package:checkup_pro/Authentication/authentication.dart';
import 'package:checkup_pro/Patient/home_page.dart';
import 'package:checkup_pro/Widgets/Roles.dart';
import 'package:checkup_pro/Widgets/bottom_navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var selectedToggle = 0;
  List<String> toggel = ['Patient', 'Doctor'];
  String role = '';
  final name = TextEditingController();
  final email = TextEditingController();
  final pass = TextEditingController();
  //final createdAt = DateTime.now().millisecondsSinceEpoch;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const Authentication()));
        return false;
      },
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('Assets/Images/register.png'), fit: BoxFit.cover),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 35, top: 30),
                child: const Text(
                  'Create\nAccount',
                  style: TextStyle(color: Colors.white, fontSize: 33),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(top: 200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 35, right: 35),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Role',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                ToggleSwitch(
                                  minWidth: 90,
                                  cornerRadius: 20,
                                  initialLabelIndex: selectedToggle,
                                  activeBgColor: [Colors.blue, Colors.pink],
                                  activeFgColor: Colors.white,
                                  inactiveBgColor: Colors.grey,
                                  inactiveFgColor: Colors.black54,
                                  labels: toggel,
                                  icons: const [
                                    FontAwesomeIcons.thermometer,
                                    FontAwesomeIcons.userDoctor
                                  ],
                                  onToggle: (index) {
                                    setState(() {
                                      role = toggel[index!];
                                      selectedToggle = index;
                                    });
                                  },
                                  changeOnTap: true,
                                )
                              ],
                            ),
                            SizedBox(height: 30),
                            TextField(
                              controller: name,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Name",
                                  hintStyle: const TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            TextField(
                              controller: email,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Email",
                                  hintStyle: const TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            TextField(
                              controller: pass,
                              style: const TextStyle(color: Colors.white),
                              obscureText: true,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Password",
                                  hintStyle: const TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 27,
                                      fontWeight: FontWeight.w700),
                                ),
                                CircleAvatar(
                                  backgroundColor: const Color(0xff4c505b),
                                  radius: 30,
                                  child: IconButton(
                                      color: Colors.white,
                                      onPressed: () {
                                        // Map<String, dynamic> data = {
                                        //   'field1': name.text,
                                        //   'field2': email.text,
                                        //   'field3': pass.text
                                        // };
                                        FirebaseAuth.instance
                                            .createUserWithEmailAndPassword(
                                                email: email.text,
                                                password: pass.text)
                                            .then((value) {
                                          FirebaseFirestore.instance
                                              .collection('checkup_pro')
                                              .doc(value.user!.uid)
                                              .set({
                                            'name': name.text,
                                            'email': email.text,
                                            'password': pass.text,
                                            'role': role,
                                            'uid': FirebaseAuth.instance.currentUser!.uid
                                            //'createdAt': createdAt
                                          }).then((values) {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        const BottomNavigation()));
                                          });
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.arrow_forward,
                                      )),
                                )
                              ],
                            ),
                          ],
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

  // static time() {
  //   int createdAt = DateTime.now().millisecondsSinceEpoch;
  //   return createdAt;
  // }
}
