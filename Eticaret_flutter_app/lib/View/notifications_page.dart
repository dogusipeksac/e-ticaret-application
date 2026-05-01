import 'package:e_ticaret_flutter_app/Core/Service/notification_service.dart';
import 'package:e_ticaret_flutter_app/DesignStyle/colors_cons.dart';
import 'package:e_ticaret_flutter_app/Model/notification.dart';
import 'package:e_ticaret_flutter_app/Model/product.dart';
import 'package:e_ticaret_flutter_app/Model/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Map/main_drawer.dart';
import 'ad_detail_page.dart';

//bildirimler sayfasi
class Notifications extends StatelessWidget {
  NotificationService _notificationService = NotificationService();

  static String routeName = '/routeNotificationPage';
  @override
  Widget build(BuildContext context) {
    List<NotificationModel> notificationList =
        Provider.of<List<NotificationModel>>(context) ?? <NotificationModel>[];

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text('Bildirimler'),
        backgroundColor: background,
      ),
      drawer: MainDrawer(),
      body: ListView.builder(
              itemCount: notificationList.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) => FutureBuilder<UserModel>(
                future: UserModel().fromUserId(notificationList[index].willingId ?? ''),
                builder: (context, user) {
                  if(user.hasError){
                    return Text("Birseyler yanlis gitti");
                  }
                  if(user.hasData){
                    final isShowed = notificationList[index].isShowed ?? false;
                    changeShowState(isShowed, notificationList[index]);
                    return GestureDetector(
                      onTap: () => toProductDetailPage(notificationList[index], context),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                        child: Card(
                          color: background,
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                color: isShowed ? filterBackground : themeColor,
                                borderRadius: BorderRadius.all(Radius.circular(10.0))),
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    height: 55,
                                    color: Colors.transparent,
                                    child: CircleAvatar(
                                      backgroundColor: filterBackground,
                                      foregroundColor: filterBackground,
                                      backgroundImage: NetworkImage(user.data?.userImageLink ?? ''),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      (user.data?.name ?? '') + " ilanını istek listesine ekledi",
                                      style:
                                      TextStyle(color: Colors.white, fontSize: 15),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              ),
            ),
    );
  }
  
  toProductDetailPage(NotificationModel model,BuildContext context) {
    Product().fromProductId(model.productId ?? '').then((product){
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => AdDetail(snapshot: product,),
      ));
    });
  }

  changeShowState(bool isShowed,NotificationModel model){
    if(!isShowed) {
      _notificationService.updateNotification(NotificationModel(
        id: model.id,
        willingId: model.willingId,
        userId: model.userId,
        productId: model.productId,
        isShowed: !isShowed,));
    }
  }

  ///geting data from firebase
  /*StreamBuilder getDatas({Widget child}){
    return StreamBuilder(
      stream: _notificationService.getUserNotificationList(),
      builder: (builderContext,notifyList){
        if(notifyList.hasData){
          List<NotificationModel> list = notifyList.data;
          print("${list.length}");
          return child;
        }
        return CircularProgressIndicator();
      },
    );
  }*/
}
