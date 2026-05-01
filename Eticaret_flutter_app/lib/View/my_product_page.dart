import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_ticaret_flutter_app/Core/Service/product_share_service.dart';

import 'package:e_ticaret_flutter_app/DesignStyle/colors_cons.dart';
import 'package:e_ticaret_flutter_app/Model/product.dart';
import 'package:flutter/material.dart';

import '../Map/main_drawer.dart';
import 'ad_detail_page.dart';

class MyProduct extends StatefulWidget {
  static String routeName = '/routeMyProduct';



  @override
  _MyProductState createState() => _MyProductState();
}

class _MyProductState extends State<MyProduct> {
  final ProductShareService service= ProductShareService();


  @override
  Widget build(BuildContext context) {

    Query myProduct= service.getUserProduct();

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text('Ürünlerim'),
        backgroundColor: background,
      ),
      drawer: MainDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: myProduct.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError){
            return Text("Birşeyler yanlış gitti");
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final docs = snapshot.data?.docs ?? [];
          return  ListView.builder(
            padding: EdgeInsets.only(bottom:40),
            itemCount: docs.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) => Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: GestureDetector(
                onTap: (){
                  toProductDetailPage(docs[index].id,context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: filterBackground,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(flex: 1,
                        child: Container(
                          color: filterBackground,
                          child: (docs[index].data() as Map<String, dynamic>?)?["Image 1"] == "" ?
                          Image.asset("images/Opel_KARL.jpg") :
                          Image.network(((docs[index].data() as Map<String, dynamic>?)?["Image 1"] ?? '').toString()),
                        ),
                      ),
                      SizedBox(
                        width: 3.0,
                      ),
                      Expanded(flex: 2,
                        child: Container(

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                ((((docs[index].data() as Map<String, dynamic>?)?["Fiyat"]) ?? '').toString())  + "  Türk Lirası",
                                style: TextStyle(color: themeColor, fontSize: 15),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Expanded(
                                child: Text(
                                  (((docs[index].data() as Map<String, dynamic>?)?["Aciklama"]) ?? '').toString(),
                                  style: TextStyle(color: Colors.white, fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  toProductDetailPage(String productId,BuildContext context) {
    Product().fromProductId(productId).then((product){
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => AdDetail(snapshot: product,),
      ));
    });
  }
}
