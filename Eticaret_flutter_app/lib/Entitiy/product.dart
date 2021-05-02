import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id;
  //mesela çok iyi durumda
  String productState;

  //mesela 2 el sıfır gibi
  String productCategory;

  //ürün ile ilgili açıklamalar
  String productOfDescription;
  String productPrice;

  //birdenn fazla resim olacak
  String productImage1;
  String productImage2;
  String productImage3;
  String productImage4;
  String productImage5;
  String productTitle;

  Product(
      {this.id,
      this.productCategory,
      this.productImage1,
      this.productImage2,
      this.productImage3,
      this.productImage4,
      this.productImage5,
      this.productOfDescription,
      this.productPrice,
      this.productState,
      this.productTitle});

  factory Product.fromSnapshot(DocumentSnapshot snapshot) {
    return Product(
      id: snapshot.id,
      productCategory: snapshot["Kategori"],
      productImage1: snapshot["Image 1"],
      productImage2: snapshot["Image 2"],
      productImage3: snapshot["Image 3"],
      productImage4: snapshot["Image 4"],
      productImage5: snapshot["Image 5"],
      productOfDescription: snapshot["Aciklama"],
      productPrice: snapshot["Fiyat"],
      productState: snapshot["Durumu"],
      productTitle: snapshot[" "],
    );


  }
}
