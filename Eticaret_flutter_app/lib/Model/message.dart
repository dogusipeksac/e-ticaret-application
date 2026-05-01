import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? message;
  String? senderId;
  String? messageId;


  Message(
      {this.message,
      this.senderId,
      this.messageId});

  factory Message.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;
    return Message(
        messageId: snapshot.id,
        message: data?['message']?.toString(),
        senderId: data?['senderId']?.toString(),
    );
  }
}
