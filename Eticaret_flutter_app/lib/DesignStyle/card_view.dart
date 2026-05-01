
import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_ticaret_flutter_app/DesignStyle/colors_cons.dart';
import 'package:e_ticaret_flutter_app/Model/product.dart';
import 'package:e_ticaret_flutter_app/View/ad_detail_page.dart';
import 'package:flutter/material.dart';

class CardView extends StatefulWidget {
  const CardView({super.key, required this.product});
  final Product product;
  @override
  _CardViewState createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  var _displayFront ;
  var _flipXAxis ;
  void _onTileClicked(Product snapshot,var context){
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => AdDetail(snapshot: snapshot,),
    ));
  }

  @override
  void initState() {
    super.initState();
    _displayFront = true;
    _flipXAxis = true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.tight(Size.square(200.0)),
      child: GestureDetector(
        onDoubleTap: () => setState(() =>_displayFront = !_displayFront),
        onTap: () => _onTileClicked(widget.product, context),
        child: __buildLayout(widget.product.productImage1 ?? ''),
      ),
    );
  }


  Widget __buildLayout(String imageUrl,{Widget? widget}) {
    var title = this.widget.product.productTitle ?? '';
    var category = this.widget.product.productCategory ?? '';
    var price = "${this.widget.product.productPrice ?? ''} TL";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        Expanded(
          flex: 10,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20.0),
              image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.fill
              ),
              color: themeColor,
            ),
            child: widget,
          ),
        ),
        Expanded(
          flex: 2,
          child: AutoSizeText(price,
            maxLines: 1,
            style: TextStyle(
                color: text,
                fontSize:50,
                fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: AutoSizeText(category,
            maxLines: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textDarkHint,
              fontSize:40,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: AutoSizeText(title.length>33 ?
          title.replaceRange(33, title.length, "..."):title,
            maxLines: 2,
            style: TextStyle(
              fontSize:50,
              color:themeColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ]
    );
  }
  /*Widget _buildFront(String imageUrl) {
    return __buildLayout(imageUrl
      key: ValueKey(true),
      backgroundColor: Colors.blue,
      widget: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.fill
            ),
            borderRadius: BorderRadius.circular(20.0),
          )
      ),
    );
  }
  Widget _buildRear(Product product) {
    var title = product.productTitle;
    var category = product.productCategory;
    var price = "${product.productPrice}\$";
    return __buildLayout(
      key: ValueKey(false),
      backgroundColor: themeColor,
      widget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: AutoSizeText(category,
                maxLines: 1,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: background,
                  fontSize:50,),
              ),
            ),
            Spacer(flex: 2),
            Expanded(
              flex: 2,
              child: AutoSizeText(title.length>33 ?
              title.replaceRange(33, title.length, "..."):title,
                maxLines: 2,
                style: TextStyle(
                  fontSize:50,
                  color:background,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: AutoSizeText(price,
                maxLines: 1,
                style: TextStyle(
                    color: text,
                    fontSize:50,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }*/
}
