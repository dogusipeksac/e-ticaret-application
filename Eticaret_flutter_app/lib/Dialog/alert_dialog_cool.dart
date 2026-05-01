import 'package:e_ticaret_flutter_app/DesignStyle/colors_cons.dart';
import 'package:e_ticaret_flutter_app/View/login_page.dart';
import 'package:flutter/material.dart';

Future<void> _showBasicDialog(
  BuildContext context, {
  required String title,
  required String message,
  String okText = 'Tamam',
  VoidCallback? onOk,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: background,
      title: Text(title, style: const TextStyle(color: Colors.white)),
      content: Text(message, style: const TextStyle(color: Colors.white)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onOk?.call();
          },
          child: Text(okText, style: const TextStyle(color: Colors.white)),
        )
      ],
    ),
  );
}

void SuccessAlertRegister(BuildContext context) {
  _showBasicDialog(
    context,
    title: 'Harika.',
    message: "Kayıt başarılı!",
    okText: 'Giriş için tıkla!',
    onOk: () => Navigator.pushNamed(context, LoginPage.routeName),
  );
}

void ErorrAlertRegister(BuildContext context) {
  _showBasicDialog(
    context,
    title: 'Ups...',
    message: "Kayıt başarısız eksiklerinizi doldurun!",
  );
}

void ErorrAlertLogin(BuildContext context) {
  _showBasicDialog(
    context,
    title: 'Giriş başarısız!',
    message: "Eksit veya yanlış girdiniz!",
  );
}

void LoadingAlertLogin(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );
}

void SuccessAlertLogin(BuildContext context) {
  _showBasicDialog(
    context,
    title: 'Harika.',
    message: "Giriş başarılı!",
    okText: 'Anasayfaya Dön!',
  );
}

