import 'package:e_ticaret_flutter_app/Core/Service/auth_service.dart';
import 'package:e_ticaret_flutter_app/DesignStyle/colors_cons.dart';
import 'package:e_ticaret_flutter_app/Dialog/alert_dialog_cool.dart';

import 'package:flutter/material.dart';

import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  static String routeName = '/routeRegisterPage';
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

String email_valid =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
RegExp regExp = new RegExp(email_valid);


class _RegisterPageState extends State<RegisterPage> {


  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool obsture = true;

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
  final TextEditingController _nameSurnameController = TextEditingController();

  AuthService _userController = AuthService();

  @override
  Widget build(BuildContext context) {
    final nameSurname = TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Boş bırakılmaz.";
        }
        if (value.length < 6) {
          return "İsminiz çok kısa";
        }
        return null;
      },
      controller: _nameSurnameController,
      textAlign: TextAlign.start,
      textAlignVertical: TextAlignVertical.center,
      style: TextStyle(
        fontSize: 18,
        color: text,
      ),
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
          Icons.person,
          color: Colors.white,
          size: 20,
        ),
        fillColor: Colors.white,
        hintText: "Ad ve soyad giriniz.",
        hintStyle: TextStyle(color: Colors.white),
      ),
    );
    final email = TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Boş bırakılamaz.";
        } else if (!regExp.hasMatch(value)) {
          return "E mail geçersiz.";
        }
        return null;
      },
      controller: _emailController,
      textAlign: TextAlign.start,
      textAlignVertical: TextAlignVertical.center,
      style: TextStyle(
        fontSize: 18,
        color: text,
      ),
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
          Icons.mail,
          color: Colors.white,
          size: 20,
        ),
        fillColor: Colors.white,
        hintText: "E mail giriniz.",
        hintStyle: TextStyle(color: Colors.white),
      ),
    );
    ;
    final password = TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Boş bırakılmaz.";
        } else if (value.length < 8) {
          return "Şifreniz çok kısa en az 8 karakter olmalı.";
        }
        return null;
      },
      controller: _passwordController,
      obscureText: obsture,
      textAlign: TextAlign.start,
      textAlignVertical: TextAlignVertical.center,
      style: TextStyle(
        fontSize: 18,
        color: text,
      ),
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
              obsture = !obsture;
            });
            FocusScope.of(context).unfocus();
          },
          child: Icon(
            obsture == true ? Icons.visibility : Icons.visibility_off,
            color: Colors.white,
            size: 20,
          ),
        ),
        fillColor: Colors.white,
        hintText: "Şifre giriniz.",

        hintStyle: TextStyle(color: Colors.white),
      ),
    );
    ;
    final registerButton = Material(
      borderRadius: BorderRadius.circular(1.0),
      color: background,
      child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: text,
            shape: RoundedRectangleBorder(side: BorderSide(color: text)),
          ),
          child: Text(
            "HESAP OLUŞTUR",
            textAlign: TextAlign.center,
            style: TextStyle(color: text, fontWeight: FontWeight.bold),
          ),
          onPressed: () async {
            if(!validation()) return;
            await _userController.createPerson(
              _emailController.text,
              _nameSurnameController.text,
              _passwordController.text,
            );
            SuccessAlertRegister(context);
          }),
    );
    final goLoginButton = goLoginTextButton(context);

    return Scaffold(
      backgroundColor: background,
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: const Color(0XFF),
                      backgroundImage: AssetImage("images/Logo.png"),
                    ),
                  ),
                  SizedBox(height: 10),
                  registerTitleText('KAYIT OL', 42),
                  SizedBox(height: 10),
                  registerTitleText("Adı Soyadı", 14),
                  nameSurname,
                  SizedBox(height: 10),
                  registerTitleText("E-posta", 14),
                  email,
                  SizedBox(height: 10),
                  registerTitleText("Şifre", 14),
                  password,
                  SizedBox(height: 10),
                  Center(child: registerButton),
                  SizedBox(height: 10),
                  Center(child: goLoginButton),
                ],
              ),
            ],
          ),
        ),

      ),
    );
  }


  Text registerTitleText(String title, double fontsize) {
    return Text(
      title,
      style: TextStyle(
        color: text,
        fontSize: fontsize,
      ),
    );
  }



  TextButton goLoginTextButton(BuildContext context) {
    return TextButton(
      style: ButtonStyle(),
      onPressed: () {
        Navigator.pushNamed(context, LoginPage.routeName);
      },
      child: Text(
        "Hesabım var Giriş yapmak için dokun.",
        style: TextStyle(color: text),
      ),
    );
  }


}
