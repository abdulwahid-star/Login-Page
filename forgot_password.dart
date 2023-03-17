import 'package:checkup_pro/Authentication/authentication.dart';
import 'package:checkup_pro/Authentication/verify_email.dart';
// import 'package:checkup_pro/Widgets/Roles.dart';
import 'package:checkup_pro/Widgets/bottom_navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool passWidget = true;
  bool showWidget = true;
  bool submitValid = false;
  final TextEditingController pass = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  late EmailAuth emailAuth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailAuth = EmailAuth(sessionName: 'Aero Checkup Pro');
  }

  void sendOTP() async {
    bool result = await emailAuth.sendOtp(
        recipientMail: emailController.value.text, otpLength: 5);
    if (result) {
      setState(() {
        submitValid = true;
      });
      print('OTP Sent');
    } else {
      print('We could not sent the OTP');
    }
  }

  void verifyOTP() {
    bool result = emailAuth.validateOtp(
        recipientMail: emailController.value.text,
        userOtp: otpController.value.text);
    if (result) {
      print('OTP Verified');
    } else {
      print('Invalid OTP');
    }
  }

  @override
  Widget build(BuildContext context) {
    String text1 = 'Forgot Password';
    String text2 =
        'Enter your email address and we will send you a 6 digit code to reset your password';
    String text3 = 'Email Address';

    final formKey = GlobalKey<FormState>();

    moveToVerify(BuildContext context) async {
      if (formKey.currentState!.validate()) {
        await Future.delayed(const Duration(seconds: 1));
        await Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const VerifyEmail()));
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 1, 4, 22)),
      ),
      body: WillPopScope(
        onWillPop: () async{
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const Authentication()));
          return false;
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            doctorInfo(text1, 20.0, FontWeight.bold,
                const Color.fromARGB(255, 1, 4, 22)),
            const SizedBox(height: 20.0),
            doctorInfo(text2, 12.0, FontWeight.normal,
                const Color.fromARGB(255, 1, 4, 22)),
            const SizedBox(height: 25.0),
            doctorInfo(text3, 12.0, FontWeight.normal,
                const Color.fromARGB(255, 1, 4, 22)),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        labelText: 'Email',
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: "example@domain.com",
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
                  const SizedBox(height: 20),
                  showWidget
                      ? Container()
                      : passWidget
                          ? TextFormField(
                              controller: otpController,
                              keyboardType: TextInputType.number,
                              obscureText: true,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  labelText: 'OTP',
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  hintText: "Send OTP",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "OTP can not be empty";
                                }
                                return null;
                              },
                            )
                          : TextFormField(
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
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: showWidget
                      ? GestureDetector(
                          onTap: () {
                            FirebaseFirestore.instance
                                .collection("checkup_pro")
                                .where('email', isEqualTo: emailController.text)
                                .get()
                                .then((value) {
                              if (value.docs.isNotEmpty) {
                                toast(context, 'Email exists');
                                setState(() {
                                  showWidget = false;
                                });
                                sendOTP();
                                // moveToVerify(context);
                              } else {
                                toast(context, 'Invalid email');
                                if (formKey.currentState!.validate()) {}
                              }
                            });
                          },
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: const Color.fromARGB(255, 37, 33, 243),
                            ),
                            child: const Center(
                              child: Text(
                                'Send Email',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ),
                        )
                      : passWidget
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  passWidget = false;
                                });
                                verifyOTP();
                              },
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: const Color.fromARGB(255, 37, 33, 243),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Verify Email',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () async {
                                final post = await FirebaseFirestore.instance
                                    .collection("checkup_pro")
                                    .where('email',
                                        isEqualTo: emailController.text)
                                    .get()
                                    .then((value) {
                                  return value.docs[0].reference;
                                });
                                var batch = FirebaseFirestore.instance.batch();
                                batch.update(post, {
                                  'password': pass.text,
                                  'createdAt':
                                      DateTime.now().millisecondsSinceEpoch
                                });
                                batch.commit();
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                      builder: (_) => const BottomNavigation()));
                                //Roles().roles(context);
                              },
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: const Color.fromARGB(255, 37, 33, 243),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Enter New Password',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ),
                              ),
                            )),
            ),
          ]),
        ),
      ),
    );
  }

  Widget doctorInfo(
      String j, double fontChange, FontWeight newfont, Color newColor) {
    return Text(
      j.toString(),
      style: TextStyle(
        color: newColor,
        fontWeight: newfont,
        fontSize: fontChange,
      ),
    );
  }

  toast(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
