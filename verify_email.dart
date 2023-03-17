import 'package:checkup_pro/Authentication/register.dart';
import 'package:checkup_pro/Patient/home_page.dart';
import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});
  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool submitValid = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  late EmailAuth emailAuth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailAuth = new EmailAuth(sessionName: 'Aero Checkup Pro');
  }

  void sendOTP() async {
    bool result = await emailAuth.sendOtp(
        recipientMail: _emailController.value.text, otpLength: 5);
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
        recipientMail: _emailController.value.text,
        userOtp: _otpController.value.text);
    if (result) {
      print('OTP Verified');
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => Register()));
    } else {
      print('Invalid OTP');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Stack(
        children: [
        Padding(
          padding: const EdgeInsets.only(top: 90),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('Assets/Images/doc_profile.png'),
            ),]
          ),
        ),
        SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 200),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: 'Enter Email',
                        labelText: 'Email',
                        suffixIcon: TextButton(
                          child: const Text('Send OTP'),
                          onPressed: () {
                            sendOTP();
                          },
                        )),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    decoration: const InputDecoration(
                        hintText: 'Enter OTP', labelText: 'OTP'),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      verifyOTP();
                    },
                    child: const Text('Verify OTP'),
                  )
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
