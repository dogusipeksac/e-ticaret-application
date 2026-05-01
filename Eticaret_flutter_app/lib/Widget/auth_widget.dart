import 'package:e_ticaret_flutter_app/View/home_page.dart';
import 'package:e_ticaret_flutter_app/View/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';




class AuthWidget extends StatelessWidget {
  const AuthWidget({super.key, required this.userSnapshot});
  final AsyncSnapshot<User?> userSnapshot;

  @override
  Widget build(BuildContext context) {
    print("AuthWidget = ${userSnapshot.connectionState}");
    if (userSnapshot.connectionState == ConnectionState.active) {
      print("has data : ${userSnapshot.hasData}");
      return userSnapshot.hasData ? HomePage() : LoginPage();
    }
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
