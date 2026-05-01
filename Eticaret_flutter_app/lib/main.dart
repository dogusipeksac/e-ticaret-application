
import 'package:e_ticaret_flutter_app/Core/Locator/locator.dart';
import 'package:e_ticaret_flutter_app/View/message_detail.dart';
import 'package:e_ticaret_flutter_app/View/product_share_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Core/Service/auth_service.dart';

import 'View/home_page.dart';
import 'View/login_page.dart';
import 'View/my_product_page.dart';
import 'View/notifications_page.dart';
import 'View/message_list_page.dart';
import 'View/filter_page.dart';
import 'View/register_page.dart';
import 'View/setting_page.dart';
import 'Widget/auth_widget.dart';
import 'Widget/auth_widget_builder.dart';

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_aut) => AuthService(),)
      ],
      child: AuthWidgetBuilder(builder: (context,userSnapshot) {
        return MaterialApp(
            theme: ThemeData(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.grey)),
            home: AuthWidget(userSnapshot: userSnapshot,),
            routes: {
              HomePage.routeName: (context) => HomePage(),
              LoginPage.routeName: (context) => LoginPage(),
              RegisterPage.routeName: (context) => RegisterPage(),
              Notifications.routeName: (context) => Notifications(),
              MessageList.routeName: (context) => MessageList(),
              SettingPage.routeName: (context) => SettingPage(),
              MyProduct.routeName: (context) => MyProduct(),
              FilterPage.routeName: (context) => FilterPage(),
              ProductSharePage.routeName: (context) => ProductSharePage(),
              MessageDetailPage.routeName: (context) => MessageDetailPage(),
            });
      }),
    );
  }
}