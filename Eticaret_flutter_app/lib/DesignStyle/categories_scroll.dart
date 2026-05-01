import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_ticaret_flutter_app/Core/Service/product_share_service.dart';
import 'package:e_ticaret_flutter_app/DesignStyle/colors_cons.dart';
import 'package:flutter/material.dart';
class CategoriesScroller extends StatelessWidget {
  const CategoriesScroller({super.key});

  @override
  Widget build(BuildContext context) {
    List catList = [
      "1.El Araç",
      "2.El Araç",
      "Teknoloji",
      "Telefon",
      "Giyim"
    ];
    ProductShareService _service = ProductShareService();

    return ListView.builder(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: catList.length,
      itemBuilder: (context, index) {
        return FutureBuilder<int>(
            future: _service.getCount(catList[index]),
            builder: (context, value) {
              if(value.hasData )
                return CategoryCard(CategoryName: catList[index], CountOfProduct: value.data.toString());
              else
                return  CategoryCard(CategoryName: catList[index], CountOfProduct: "0");
            }
        );
      },
    );
  }
}

//Colors.blue.shade400 Colors.lightBlueAccent.shade400 Colors.orange.shade400
class CategoryCard extends StatelessWidget {
  final String CategoryName;
  final String CountOfProduct;
  const CategoryCard({
    super.key,
    required this.CategoryName,
    required this.CountOfProduct,
  });
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height * 0.10;
    return FittedBox(
      fit: BoxFit.fill,
      child: Container(
        width: 125,
        height: categoryHeight,
        margin: EdgeInsets.only(left: 20),
        decoration: BoxDecoration(color: themeColor, borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AutoSizeText(
                this.CategoryName,
                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              AutoSizeText(
                "Ürün sayısı: ${this.CountOfProduct}",
                style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold ,color: background),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
