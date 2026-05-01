
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_ticaret_flutter_app/Core/Controller/user_controller.dart';
import 'package:e_ticaret_flutter_app/Core/Service/auth_service.dart';
import 'package:e_ticaret_flutter_app/Core/Service/notification_service.dart';
import 'package:e_ticaret_flutter_app/Core/Service/product_share_service.dart';
import 'package:e_ticaret_flutter_app/Model/notification.dart';
import 'package:e_ticaret_flutter_app/Model/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWidgetBuilder extends StatelessWidget {
  AuthWidgetBuilder({super.key, required this.builder});
  final Widget Function(BuildContext, AsyncSnapshot<User?>) builder;
  final NotificationService notificationService = NotificationService();
  final ProductShareService productShareService = ProductShareService();
  final UserController userController = UserController();

  @override
  Widget build(BuildContext context) {
    print('AuthWidgetBuilder rebuild');
    final authService =
    Provider.of<AuthService>(context, listen: false);
    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        print('StreamBuilder: ${snapshot.connectionState} , ${snapshot.data}');
        final User? user = snapshot.data;
        return MultiProvider(
          providers: [
            StreamProvider<List<NotificationModel>>.value(
              value: notificationService.getUserNotificationList(),
              initialData: const [],
            ),
            StreamProvider<List<Product>>.value(
              value: productShareService.getUserProducts(),
              initialData: const [],
            ),
            StreamProvider<DocumentSnapshot?>.value(
              value: userController.getPath().snapshots(),
              initialData: null,
            ),
            Provider<User?>.value(value: user),
          ],
          child: builder(context, snapshot),
        );
      },
    );
  }
}