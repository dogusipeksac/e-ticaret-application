import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class UserModel {
  static final getPath = FirebaseFirestore.instance.collection("User");
  final String? uid;
  final String? name;
  final String? email;
  final String? password;
  final String? userLocation;
  final String? userImageLink;
  final Image? userImage;


  UserModel({this.uid,
    this.name,
    this.password,
    this.email,
    this.userImage,
    this.userImageLink,
    this.userLocation});


  factory UserModel.fromSnapshot(DocumentSnapshot snapshot){
    final data = snapshot.data() as Map<String, dynamic>?;

    return UserModel(
      uid: snapshot.id,
      name: data?['name']?.toString(),
      email: data?['email']?.toString(),
      password: data?['password']?.toString(),
      userImageLink: data?['image']?.toString(),
      userLocation: data?['location']?.toString(),
    );
  }

  Future<UserModel> fromUserId(String userId) async{
    var sending = await getPath.doc(userId).snapshots()
        .map((snapshot)  {
          final data = snapshot.data() as Map<String, dynamic>?;
          return UserModel(
            uid: snapshot.id,
            name: data?['name']?.toString(),
            userImageLink: data?['image']?.toString(),
          );
        }).first;
    print(sending);
    return sending;
  }
}