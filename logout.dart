import 'package:checkup_pro/Authentication/authentication.dart';
import 'package:checkup_pro/Widgets/bottom_navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Logout extends StatefulWidget {
  const Logout({super.key});

  @override
  State<Logout> createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    //_signOut();
  }

  void _signOut() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const Authentication()));
    } else {
      await FirebaseAuth.instance.signOut().then((value) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({'loggedIn': false});
        print('seccessfully logged out');
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const Authentication()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const BottomNavigation()));
          return false;
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.exit_to_app,
                size: 80,
                color: Colors.redAccent,
              ),
              SizedBox(height: 20),
              Text(
                'Are you sure you want to log out?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _signOut(),
                child: const Text('Log Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
