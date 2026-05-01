import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel{
  ///Notification firestore path
  static final getPath = FirebaseFirestore.instance.collection("Notification");

  String? id;
  String? productId;
  String? willingId;
  String? userId;
  bool? isShowed;
  NotificationModel({
    this.id,
    this.productId,
    this.willingId,
    this.userId,
    this.isShowed,
  });


  Map<String,dynamic> toMap(){
    return {
      'product_id': productId,
      'willing_id': willingId,
      'user_id': userId,
      'is_showed': isShowed,
    };
  }

  factory NotificationModel.fromSnapshot(DocumentSnapshot snapshot){
    final data = snapshot.data() as Map<String, dynamic>?;
    return NotificationModel(
      id: snapshot.id,
      productId: data?['product_id']?.toString(),
      willingId: data?['willing_id']?.toString(),
      userId: data?['user_id']?.toString(),
      isShowed: data?['is_showed'] as bool?,
    );
  }
}