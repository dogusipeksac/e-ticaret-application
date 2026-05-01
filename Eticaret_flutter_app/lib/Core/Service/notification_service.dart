import 'package:e_ticaret_flutter_app/Model/notification.dart';
import 'package:e_ticaret_flutter_app/Model/product.dart';
import 'package:e_ticaret_flutter_app/Model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService{
  ///turn current user's notification list
  Stream<List<NotificationModel>> getUserNotificationList(){
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Stream.empty();
    var snapshots = NotificationModel.getPath
        .where("user_id",isEqualTo: uid)
        .snapshots();
    var notificationList = snapshots.map((qShot) => qShot.docs
        .map((doc) => NotificationModel.fromSnapshot(doc))
        .toList());
    return notificationList;
  }

  ///send notification to seller from user
  addNotification(Product product,String userId) async {
    UserModel seller = await UserModel().fromUserId(userId);
    NotificationModel.getPath.add({
      'product_id': product.id,
      'willing_id' : userId,
      'willing_name': seller.name,
      'willing_image':seller.userImageLink,
      'user_id': product.userId,
      'is_showed':false,
    });
  }
  ///remove notification from seller
  void removeNotification(String productId,String userId) {
    NotificationModel.getPath.where('willing_id',isEqualTo: userId).where('product_id',isEqualTo:productId)
        .get()
        .then((value) => value.docs.forEach((element) {
      NotificationModel.getPath.doc(element.id).delete();
    }));
  }
  ///update notification
  updateNotification(NotificationModel notificationModel){
    NotificationModel.getPath
        .doc(notificationModel.id)
        .update(notificationModel.toMap());
  }

}