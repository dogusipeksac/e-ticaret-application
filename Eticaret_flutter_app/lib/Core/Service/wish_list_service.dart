import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_ticaret_flutter_app/Core/Service/notification_service.dart';
import 'package:e_ticaret_flutter_app/DesignStyle/for_text_style.dart';
import 'package:e_ticaret_flutter_app/Model/Wish.dart';
import 'package:e_ticaret_flutter_app/Model/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WishListService{
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  final NotificationService _notificationService= NotificationService();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Widget isInWishList(String productId,int counter,{Widget? whenTrue, Widget? whenFalse})  {
    final currentUid = uid;
    if (currentUid == null) {
      return const SizedBox.shrink();
    }
    Stream<List<Wish>> st= Wish.getPath.where("willing_id",isEqualTo: currentUid)
        .where("product_id",isEqualTo: productId)
        .snapshots().map((event) => event.docs.map((doc) => Wish.fromSnapshot(doc)).toList());
    return StreamBuilder<List<Wish>>(
      stream: st,
      builder: (context,snapshot){
        final list = snapshot.data ?? const <Wish>[];
        if(snapshot.hasData && list.isNotEmpty)
          return Container(
            color: Colors.black45.withOpacity(0.3),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                whenTrue ?? const SizedBox.shrink(),
                Text(counter.toString(),style: detailTitle,),
              ],
            ),
          );
        else
          return Container(
            color: Colors.black45.withOpacity(0.3),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                whenFalse ?? const SizedBox.shrink(),
                Text(counter.toString(),style: detailTitle,),
              ],
            ),
          );
      },
    );
  }

  Stream<QuerySnapshot> countOfProductWish(String productId) {
    var deger= Wish.getPath
        .where("product_id",isEqualTo: productId)
        .snapshots();
    return deger;
  }
  void addWishList(Product product) {
    final currentUid = uid;
    if (currentUid == null) return;
    _notificationService.addNotification(product,currentUid);
    Wish.getPath.add({
      'product_id': product.id,
      'willing_id': currentUid,
    });
  }
  void removeWishList(Wish wish) {
    final currentUid = uid;
    if (currentUid == null) return;
    _notificationService.removeNotification(wish.productId ?? '', currentUid);
    Wish.getPath.where('willing_id',isEqualTo: wish.willingId).where('product_id',isEqualTo:wish.productId)
        .get()
        .then((value) => value.docs.forEach((element) {
          Wish.getPath.doc(element.id).delete();
        }));
  }

  ///future extends maybe
  Stream<List<Wish>> getUserWishList(){
    var wishList;
    var snapshots = Wish.getPath
        .where("willing_id",isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots();
    wishList = snapshots.map((qShot) => qShot.docs.map((doc) => Wish.fromSnapshot(doc)).toList());
    return wishList;
  }
}