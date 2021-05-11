import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_ticaret_flutter_app/DesignStyle/colors_cons.dart';
import 'package:e_ticaret_flutter_app/Entitiy/product.dart';
import 'package:e_ticaret_flutter_app/View/ad_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CardView extends StatefulWidget {
  const CardView({Key key, @required this.product}):super(key: key);
  final Product product;
  @override
  _CardViewState createState() => _CardViewState(product: product);
}

class _CardViewState extends State<CardView> {
  var _displayFront ;
  var _flipXAxis ;
  final Product product;
  _CardViewState({@required this.product}):super();
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
        onTap: () => setState(() =>_displayFront = !_displayFront),
        onLongPress: () => _onTileClicked(product, context),
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 600),
          layoutBuilder: (widget, list) => Stack(children: [widget, ...list]),
          transitionBuilder: __transitionBuilder,
          child: _displayFront ? _buildFront(product.productImage1) : _buildRear(product),
        ),
      ),
    );
  }

  Widget __transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(_displayFront) != widget.key);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final value = isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
        return Transform(
          transform: _flipXAxis
              ? (Matrix4.rotationY(value)..setEntry(3, 0, tilt))
                :(Matrix4.rotationX(value)..setEntry(3, 1, tilt)),
          child: widget,
          alignment: Alignment.center,
        );
      },
    );
  }
  Widget __buildLayout({Key key, Widget widget, Color backgroundColor}) {
    return Container(
      key: key,
      width: double.maxFinite,
      height: double.maxFinite,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20.0),
        color: backgroundColor,
      ),
      child: widget,
    );
  }
  Widget _buildFront(String imageUrl) {
    return __buildLayout(
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
  }
}