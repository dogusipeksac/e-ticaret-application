import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_ticaret_flutter_app/Core/Service/message_service.dart';
import 'package:e_ticaret_flutter_app/Model/chat.dart';
import 'package:e_ticaret_flutter_app/Model/product.dart';
import 'package:e_ticaret_flutter_app/Model/user.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  MessageService _service = MessageService();

  Stream<List<Chat>> getConversition(String userId) {
    var ref = _firestore
        .collection("Conversitons")
        .where("members", arrayContains: userId).snapshots();
    return ref.map((qShot) => qShot.docs
        .map((doc) => Chat(
        id: doc.id,
        title: doc.get('title'),
        productId: doc.get('productId'),
        productImage: doc.get('productImage'),
        productPrize: doc.get('productPrize'),
        senderImage: doc.get('senderImage'),
        senderName: doc.get('senderName'),
        receiverImage: doc.get('receiverImage'),
        receiverName: doc.get('receiverName'),
        productUserId: doc.get('productUserId'),
      displayMessage: doc.get('displayMessage')

    )).toList());
  }

  Future<String> chatStart(
      Product product, String userId, String message) async {
    //ürün sahibinni bilgilerini çekme için



    UserModel profileSender = await UserModel().fromUserId(userId);
    UserModel profileReceiver = await UserModel().fromUserId(product.userId ?? '');


    var doc;
    var startConversitns = _firestore.collection("Conversitons");
    doc = await startConversitns.add({
      //
      'members': FieldValue.arrayUnion([userId, product.userId ?? '']),
      //
      'title': product.productTitle,
      'productImage': product.productImage1,
      'senderName': profileSender.name,
      'senderImage': profileSender.userImageLink,
      'receiverName':profileReceiver.name,
      'receiverImage':profileReceiver.userImageLink,

      'productPrize': product.productPrice,
      'productUserId':product.userId,
      //
      'productId': product.id,
      'displayMessage':message,
      //

    });
    _service.addMessage(message, userId, doc.id);

    return doc.id;
  }

  Future<String> productConversitonsExist(
      String productId, String userId) async {
    var query = (await FirebaseFirestore.instance
        .collection("Conversitons")
        .where("productId", isEqualTo: productId)
        .where("members", arrayContains: userId)
        .get())
        .docs;
    print("Query result:" + query.toString());
    print("productId:" + productId);

    return query.isNotEmpty ? query.first.id : '';
  }
}
