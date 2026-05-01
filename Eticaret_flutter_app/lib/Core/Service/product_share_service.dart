import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_ticaret_flutter_app/Model/product.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductShareService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth auth = FirebaseAuth.instance;

//veri ekleme fonksiyonu
  Future<void> addProduct(
      String userId,
      String pickedFile1,
      String pickedFile2,
      String pickedFile3,
      String pickedFile4,
      String pickedFile5,
      String productCategory,
      String productTitle,
      int productPrize,
      String productLocation,
      String productOfDescription) async {
    var ref = _firestore.collection("Product");

    await ref.add({
      'User id': userId,
      'Image 1': pickedFile1,
      'Image 2': pickedFile2,
      'Image 3': pickedFile3,
      'Image 4': pickedFile4,
      'Image 5': pickedFile5,
      'Kategori': productCategory,
      'Baslik': productTitle,
      'Fiyat': productPrize,
      'Konum': productLocation,
      'Aciklama': productOfDescription,
    });
  }


  Query getUserProduct(){
    return FirebaseFirestore.instance.collection("Product").
    where("User id",isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? '');
  }

  Future<int> getCount(String field) async{
        var deger =Product.getPath
          .where("Kategori",isEqualTo: field).get().then((value) =>  value.docs.length);
        return deger;
  }

  Stream<List<Product>> getUserProducts(){
    return getUserProduct()
        .snapshots()
        .map((qShot) => qShot.docs
        .map((doc) => Product.fromSnapshot(doc))
        .toList());
  }

  Stream<List<Product>> getProduct() {
    var stream =
    _firestore.collection('Product').snapshots();
    return stream.map(
            (qShot) => qShot.docs.map(
                (doc) => Product.fromSnapshot(doc)
        ).toList()
    );
  }
  Stream<List<Product>> FilteredgetProduct(String kategori) {
    var stream =
    _firestore.collection('Product').where('Kategori',isEqualTo: kategori).snapshots();
    return stream.map(
            (qShot) => qShot.docs.map(
                (doc) => Product.fromSnapshot(doc)
        ).toList()
    );
  }



  //silme
  Future<void> remove(String docId) {
    var ref = _firestore.collection("Product").doc(docId).delete();
    return ref;
  }
}