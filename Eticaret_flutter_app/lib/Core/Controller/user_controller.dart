import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserController{

  final auth = FirebaseAuth.instance;
  final _firebaseFirestore=FirebaseFirestore.instance;
  //profil update
  Future<void>updateUser(
      String userId,
      String location,
      String name,
      String password,
      String imageAdress
      ) async {
    await _firebaseFirestore.collection("User").doc(userId).update({
      'name': name,
      'password': password,
      'location': location,
      'image': imageAdress,
    });
  }

  getPath(){
    final uid = auth.currentUser?.uid;
    if (uid == null) return _firebaseFirestore.collection('User').doc('unknown');
    return _firebaseFirestore.collection('User').doc(uid);
  }

}