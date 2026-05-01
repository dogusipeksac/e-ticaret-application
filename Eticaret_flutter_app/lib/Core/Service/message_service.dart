import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_ticaret_flutter_app/Model/message.dart';


class MessageService{



  FirebaseFirestore _firestore=FirebaseFirestore.instance;
  Stream<List<Message>> getMessage(String conservationId) {

    var stream =
    _firestore.
    collection("Conversitons/${conservationId}/Messages").
    orderBy('timeStamp').snapshots();
    return stream.map(
            (qShot) => qShot.docs.map(
                (doc) => Message(
              message: doc.get('message'),
              senderId: doc.get('senderId'),
              messageId: doc.id,
            )
        ).toList()
    );
  }
  Stream<List<Message>> getMessageLast(String conservationId) {

    var stream =
    _firestore.
    collection("Conversitons/${conservationId}/Messages").
    orderBy('timeStamp').limit(1).snapshots();
    return stream.map(
            (qShot) => qShot.docs.map(
                (doc) => Message(
              message: doc.get('message'),
              senderId: doc.get('senderId'),
              messageId: doc.id,
            )
        ).toList()
    );
  }

  addMessage(String message,String userId,String conservationId)async{
    var _ref=await _firestore
        .collection("Conversitons/${conservationId}/Messages");
    _ref.add({
      'message': message,
      'senderId': userId,
      'timeStamp': DateTime.now(),

    });
  }



  getConversitonsPath(String conversitonsId){
    return _firestore.collection('Conversitons').doc(conversitonsId).snapshots();
  }
   updateLastMessage(String conversitonsId,String message)async{
     await _firestore.collection("Conversitons")
         .doc(conversitonsId).update({
      'lastMessage':message,
    });

  }




}
