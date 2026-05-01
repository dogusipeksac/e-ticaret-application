import 'package:cloud_firestore/cloud_firestore.dart';

class Wish{
  static final getPath = FirebaseFirestore.instance.collection("WishList");

  String? id;
  String? productId;
  String? willingId;
  Wish({
    this.id,
    this.productId,
    this.willingId,
  });

  factory Wish.fromSnapshot(DocumentSnapshot snapshot){
    final data = snapshot.data() as Map<String, dynamic>?;
    return Wish(
      id: snapshot.id,
      productId: data?['product_id']?.toString(),
      willingId: data?['willing_id']?.toString(),
    );
  }

}