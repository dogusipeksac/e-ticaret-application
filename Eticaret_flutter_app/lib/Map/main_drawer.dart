import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_ticaret_flutter_app/Core/Service/auth_service.dart';
import 'package:e_ticaret_flutter_app/Core/Service/notification_service.dart';
import 'package:e_ticaret_flutter_app/DesignStyle/colors_cons.dart';
import 'package:e_ticaret_flutter_app/DesignStyle/for_text_style.dart';
import 'package:e_ticaret_flutter_app/Model/notification.dart';
import 'package:e_ticaret_flutter_app/Model/product.dart';
import 'package:e_ticaret_flutter_app/Model/user.dart';
import 'package:e_ticaret_flutter_app/View/home_page.dart';
import 'package:e_ticaret_flutter_app/View/message_list_page.dart';
import 'package:e_ticaret_flutter_app/View/my_product_page.dart';
import 'package:e_ticaret_flutter_app/View/notifications_page.dart';
import 'package:e_ticaret_flutter_app/View/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  //final UserController _userController = UserController();
  final NotificationService service = NotificationService();

  @override
  Widget build(BuildContext context) {
    final notifyList = Provider.of<List<NotificationModel>>(context) ?? <NotificationModel>[];
    final docSnap = Provider.of<DocumentSnapshot?>(context);
    final user = docSnap == null ? UserModel() : UserModel.fromSnapshot(docSnap);
    final productList = Provider.of<List<Product>>(context) ?? <Product>[];

    return Drawer(
      elevation: 3,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              color: themeColor,
              child: Center(
                child: Row(
                  children: <Widget>[
                    Material(
                      borderRadius: BorderRadius.all(Radius.circular(180)),
                      color: text,
                      elevation: 20,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                          child: Image(
                            image: (user.userImageLink == null || user.userImageLink!.isEmpty)
                                ? const AssetImage("images/profile.png")
                                : NetworkImage(user.userImageLink!) as ImageProvider,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.only(left: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              user.name ?? '',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: text,
                              ),
                            ),
                            IconTheme(
                              data: IconThemeData(
                                color: Colors.deepOrange,
                                size: 20,
                              ),
                              child: StarDisplay(value: 3),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                '${productList.length} Ürün',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: text,
                                ),
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
            Expanded(
              child: Container(
                color: background,
                child: Column(
                  children: <Widget>[
                    /** Main Page **/
                    PageTile(
                      name: 'Anasayfa',
                      textColor: text,
                      routeName: HomePage.routeName,
                      notificationNumber: 0,
                    ),
                    /** Notification **/
                    PageTile(
                      name: 'Bildirimler',
                      textColor: text,
                      routeName: Notifications.routeName,
                      notificationNumber: numberOfNewNotification(notifyList),
                    ),
                    /** Messages **/
                    PageTile(
                      name: 'Mesajlar',
                      textColor: text,
                      routeName: MessageList.routeName,
                      notificationNumber: 0,
                    ),
                    /** My Products **/
                    PageTile(
                      name: 'Ürünlerim',
                      textColor: text,
                      routeName: MyProduct.routeName,
                      notificationNumber: 0,
                    ),
                    /** Settings **/
                    PageTile(
                      name: 'Ayarlar',
                      textColor: text,
                      routeName: SettingPage.routeName,
                      notificationNumber: 0,
                    ),
                    /** Log out **/
                    PageTile(
                      name: 'Çıkış',
                      textColor: Colors.red,
                      routeName: "",
                      notificationNumber: 0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    }

  int numberOfNewNotification(List<NotificationModel> list) {
    int count = 0;
    list.forEach((element) {
      if (!(element.isShowed ?? false)) count++;
    });
      return count;
  }
}

class PageTile extends StatelessWidget {
  final String name;
  final Color textColor;
  final String routeName;
  final int notificationNumber;
  const PageTile({
    super.key,
    required this.name,
    required this.textColor,
    required this.routeName,
    required this.notificationNumber,
  });

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        Stack(children: [
          Align(
            alignment: Alignment.center,
            child: ListTile(
              title: Text(
                name,
                style: TextStyle(
                  color: textColor,
                  fontSize: 30,
                  fontWeight: FontWeight.normal,
                ),
              ),
              onTap: () => routeName.isEmpty
                  ? _signOut(context)
                  : Navigator.pushNamed(context, routeName),
            ),
          ),
          ((notificationNumber != 0) &&
                  routeName == Notifications.routeName)
              ? Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.lightGreenAccent,
                      child: Center(
                          child: Text(
                        notificationNumber.toString(),
                        style: detailButtonTextStyle,
                      )),
                    ),
                  ),
                )
              : SizedBox(),
        ]),
        SizedBox(
          width: 280,
          child: Divider(
            color: filterBackground,
            thickness: 2,
            height: 3,
          ),
        ),
      ],
    );
  }
}

//class for rating with star
class StarDisplay extends StatelessWidget {
  final int value;
  const StarDisplay({super.key, this.value = 0});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < value ? Icons.star : Icons.star_border,
        );
      }),
    );
  }
}
