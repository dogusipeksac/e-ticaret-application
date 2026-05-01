
import 'package:e_ticaret_flutter_app/Core/Service/auth_service.dart';
import 'package:e_ticaret_flutter_app/DesignStyle/colors_cons.dart';
import 'package:e_ticaret_flutter_app/DesignStyle/for_text_style.dart';
import 'package:e_ticaret_flutter_app/Dialog/alert_dialog_cool.dart';
import 'package:e_ticaret_flutter_app/View/register_page.dart';

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static String routeName = '/routeLoginPage';

  @override
  _LoginPageState createState() => _LoginPageState();
}

String email_valid =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
RegExp regExp = new RegExp(email_valid);

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool obsture=true;
  bool validation(){
    final FormState? form=_formKey.currentState;
    if(form != null && form.validate()){
      return true;
    }
    else{
      return false;
    }
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final emailField =  TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Boş bırakılamaz.";
        } else if (!regExp.hasMatch(value)) {
          return "E mail geçersiz.";
        }
        return null;
      },
      controller: _emailController,
      style: TextStyle(
        color: Colors.white,
        decorationColor: Colors.white,
      ),
      cursorColor: Colors.white,

      textAlign: TextAlign.start,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        focusColor: Colors.white,
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            )),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            )),
        prefixIcon: Icon(
          Icons.email,
          color: Colors.white,
          size: 20,
        ),
        fillColor: Colors.white,
        hintText: "example@hotmail.com",
        hintStyle: TextStyle(color: Colors.white),

      ),
    );

    final passwordField = TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Boş bırakılmaz.";
        } else if (value.length < 8) {
          return "Şifreniz çok kısa en az 8 karakter olmalı.";
        }
        return null;
      },
      controller: _passwordController,
      style: TextStyle(
        color: Colors.white,
        decorationColor: Colors.white,
      ),
      cursorColor: Colors.white,
      textAlign: TextAlign.start,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        focusColor: Colors.white,
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            )),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            )),
        prefixIcon: Icon(
          Icons.vpn_key,
          color: Colors.white,
          size: 20,
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              obsture=!obsture;
            });
            FocusScope.of(context).unfocus();

          },
          child: Icon(
            obsture==true ? Icons.visibility : Icons.visibility_off,
            color: Colors.white,
            size: 20,
          ),
        ),
        fillColor: Colors.white,
        hintText: "Şifre giriniz.",
        hintStyle: TextStyle(color: Colors.white),

      ),
      obscureText: obsture,
    );;

    final loginButton = Material(
      borderRadius: BorderRadius.circular(1.0),
      color: background,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: text,
          shape: RoundedRectangleBorder(side: BorderSide(color: text)),
        ),
        child: Text(
          "GİRİŞ YAP",
          textAlign: TextAlign.center,
          style: TextStyle(color: text, fontWeight: FontWeight.bold),
        ),
        onPressed: () async {
          if (!validation()) return;
          final result = await _authService
              .signIn(_emailController.text, _passwordController.text);
          if (result) {
            SuccessAlertLogin(context);
          } else {
            ErorrAlertLogin(context);
          }
          // dynamic result=await _authService.signInAnon();


        },
      ),
    );
    final goRegisterButton = TextButton(
      style: ButtonStyle(),
      onPressed: () {
        Navigator.pushNamed(context, RegisterPage.routeName);
      },
      child: Text(
        "Hesap oluşturak için tıklayın.",
        style: TextStyle(color: text),
      ),
    );
    return Scaffold(
      backgroundColor: background,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Center(
                    child: Image.asset(
                      "images/kapak.png",
                    )),
                SizedBox(height: 10.0),
                Text('E-posta', style: inputTexts),
                SizedBox(height: 10.0),
                emailField,
                SizedBox(height: 10.0),
                Text('Şifre', style: inputTexts),
                SizedBox(height: 10.0),
                passwordField,
                SizedBox(height: 10.0),
                Center(child: loginButton),
                SizedBox(height: 10.0),
                Center(child: goRegisterButton),
              ],
            ),
          ),
          decoration: new BoxDecoration(
              color: background,
              borderRadius: new BorderRadius.only(
                  bottomRight: const Radius.circular(180))),
        ),
      ),
    );
  }






  }


