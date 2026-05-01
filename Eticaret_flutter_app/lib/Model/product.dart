import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  static final getPath = FirebaseFirestore.instance.collection("Product");
  String? id;
  String? userId;
  //mesela çok iyi durumda
  String? productLocation;

  //mesela 2 el sıfır gibi
  String? productCategory;

  //ürün ile ilgili açıklamalar
  String? productOfDescription;
  int? productPrice;

  //birdenn fazla resim olacak
  String? productImage1;
  String? productImage2;
  String? productImage3;
  String? productImage4;
  String? productImage5;
  String? productTitle;

  Product(
      {this.id,
        this.userId,
        this.productCategory,
        this.productImage1,
        this.productImage2,
        this.productImage3,
        this.productImage4,
        this.productImage5,
        this.productOfDescription,
        this.productPrice,
        this.productLocation,
        this.productTitle});

  List<String> getImages(){
    return <String?>[
      productImage1,
      productImage2,
      productImage3,
      productImage4,
      productImage5,
    ].whereType<String>().where((e) => e.isNotEmpty).toList();
  }

  factory Product.fromSnapshot(DocumentSnapshot snapshot){
    final data = snapshot.data() as Map<String, dynamic>?;
    final fiyat = data?['Fiyat'];
    return Product(
      id: snapshot.id,
      userId: data?['User id']?.toString(),
      productOfDescription: data?['Aciklama']?.toString(),
      productTitle: data?['Baslik']?.toString(),
      productLocation: data?['Konum']?.toString(),
      productPrice: fiyat is int ? fiyat : int.tryParse(fiyat?.toString() ?? ''),
      productImage1: data?['Image 1']?.toString(),
      productImage2: data?['Image 2']?.toString(),
      productImage3: data?['Image 3']?.toString(),
      productImage4: data?['Image 4']?.toString(),
      productImage5: data?['Image 5']?.toString(),
      productCategory: data?['Kategori']?.toString(),
    );
  }

  Future<Product> fromProductId(String productId) async {
    DocumentSnapshot doc = await getPath.doc(productId).get();
    return Product.fromSnapshot(doc);
  }

}