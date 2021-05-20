
import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_ticaret_flutter_app/Core/Service/product_share_service.dart';
import 'package:e_ticaret_flutter_app/Core/Service/wish_list_service.dart';
import 'package:e_ticaret_flutter_app/DesignStyle/for_text_style.dart';
import 'package:e_ticaret_flutter_app/Model/Wish.dart';
import 'package:e_ticaret_flutter_app/Model/messageCreate.dart';
import 'package:e_ticaret_flutter_app/Model/product.dart';
import 'package:e_ticaret_flutter_app/View/message_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_ticaret_flutter_app/DesignStyle/colors_cons.dart';
import 'package:provider/provider.dart';

class AdDetail extends StatefulWidget {
  static String routeName = '/routeAdDetailPage';
  final Product snapshot;

  const AdDetail({@required this.snapshot});


  @override
  _AdDetailState createState() => _AdDetailState(
      product: snapshot,
      images: snapshot.getImages()
  );
}

class _AdDetailState extends State<AdDetail> {
  final WishListService _wishListService = WishListService();
  final auth = FirebaseAuth.instance;
  PageController pageController;
  int currentPhoto;
  _AdDetailState({
    @required this.product,
    @required this.images
  });
  final Product product;

  final List<String> images;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController(initialPage: 0, viewportFraction: 1);
    currentPhoto = pageController.initialPage;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final _pageView = Consumer<User>(
      builder: (context, user, child) => SizedBox(
        height: size.height/2,
        width: size.width,
        child: Stack(
          children: [
            ///image view
            PageView.builder(
              pageSnapping: true,
              controller: pageController,
              itemCount: images.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, position) {
                return imageSlider(position);
              },
            ),
            ///image counter display
            Align(
              alignment: Alignment.bottomRight,
              child: SelectedPhoto(
                numberOfDots: images.length,
                photoIndex: currentPhoto,
              ),
            ),
            ///return back button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: themeColor,
                    size: 40,
                  ),
                ),
              ),
            ),
            ///add to wish list
            Align(
              alignment: Alignment.bottomLeft,
              child: _wishListService.isInWishList(product.id,
                whenTrue:IconButton(
                  iconSize: 50,
                  color: themeColor,
                  icon: Icon(Icons.favorite) ,
                  onPressed: ()=> removeWishList(user.uid),
                ),
                whenFalse: IconButton(
                  iconSize: 50,
                  color: themeColor,
                  icon: Icon(Icons.favorite_outline),
                  onPressed: ()=> addWishList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
    final _productDetail = Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(product.productTitle, style: detailTitle, maxLines: 2,),
          SizedBox(height: 15,),
          Text("${product.productPrice} TL", style: detailPrice,),
          SizedBox(height: 15,),
          Text("Açıklama :", style: detailDescriptionTitle,),
          SizedBox(height: 15,),
          Text(product.productOfDescription, style: detailDescription,),
        ],
      ),
    );


    return Consumer<User>(
      builder: (context, user, child) => Scaffold(
        backgroundColor: background,
        bottomNavigationBar: DetailBottomAppBar(product: product,uid: user.uid,),
        body: Column(
          children: [
            _pageView,
            Expanded(
              child: ListView(
                children: [
                  _productDetail
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///Product Detail Page FUNCTIONS
  addWishList(){
    setState(() {
      _wishListService.addWishList(product);
    });
  }
  removeWishList(String userId){
    setState(() {
      _wishListService.removeWishList(Wish(
        willingId: userId,
        productId: product.id,
      ));
    });
  }
  _onPageChanged(int page) {
    setState(() {
      currentPhoto = page;
    });
  }
  imageSlider(int index) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      child: FittedBox(
        fit: BoxFit.fill,
        child: Image.network(
          images[index],
          fit: BoxFit.fill,
        ),
      ),
    );
  }
  sendMessage(BuildContext context,String message,Product product){
    Navigator.pushNamed(context, MessageDetail.routeName,arguments:MessageCreate(
      product: product,
      message: message,
    ),) ;
  }
}

class DetailBottomAppBar extends StatelessWidget {
  final Product product;
  final String uid;
  final ProductShareService service = ProductShareService();
  DetailBottomAppBar({@required this.product,@required this.uid});

  ///send message function for sending custom or const message send to
  ///message detail page
  sendMessage(BuildContext context,String message,Product product){
    Navigator.pushNamed(context, MessageDetail.routeName,
      arguments:MessageCreate(
        product: product,
        message: message,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final Size buttonSize = Size(size.width/3,size.height*0.05);
    final buttonStyle = ElevatedButton.styleFrom(
        minimumSize: buttonSize,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        primary: themeColor,
        elevation: 10
    );
    return BottomAppBar(
      color: filterBackground,
      child: product.userId!=uid ? Row(
        children: [
          Spacer(),
          ElevatedButton(
            onPressed: ()=>showInformationDialog(context),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text("Mesaj At",style: detailButtonTextStyle,),
            ),
            style: buttonStyle,
          ),
          Spacer(),
          ElevatedButton(
            onPressed: () {},
            child: Padding(
                padding: const EdgeInsets.all(3),
                child: Text("Ara", style: detailButtonTextStyle,)
            ),
            style: buttonStyle,
          ),
          Spacer(),
        ],
      ):Row(
        children: [
          Spacer(),
          ElevatedButton(
            onPressed: () async{
              await service.remove(product.id).whenComplete(() => Navigator.pop(context));
            },
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child:  Text(
                "Sil",
                style: TextStyle(
                    color: background, fontSize: 20, fontFamily: 'Tienne'),
              ),
            ),
            style: buttonStyle,
          ),
          Spacer(),
        ],
      ),
    );
  }
  ///Form key for dialog of form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ///Dialog builder for sending const or custom message to seller
  Future<void> showInformationDialog(BuildContext context) async {
    return await showDialog(context: context,
      builder: (context){
        ///information dialog text edit controller
        final TextEditingController _textEditingController = TextEditingController();
        ///information dialog button style
        final buttonStyle = ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            primary: themeColor,
            elevation: 10
        );
        ///information dialog button template
        Widget getButton(String text){
          return ButtonTheme(
            minWidth: double.infinity,
            height: 50,
            buttonColor: themeColor,
            child: ElevatedButton(
              onPressed: () => _textEditingController.text=text,
              style: buttonStyle,
              child: Text(text,style: TextStyle(color: background, fontSize: 20),),
            ),
          );
        }
        ///information dialog text field input border style
        OutlineInputBorder border = OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(
            width:2,
            color: themeColor,),
        );

        return StatefulBuilder(builder: (context,setState){
          return AlertDialog(
            scrollable: true,
            title: Center(child: Text("Mesaj Gönder",style: TextStyle(color:Colors.white),)),
            backgroundColor: background,
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  getButton("Hala satılık mı?"),
                  SizedBox(height: 10,),
                  getButton("Pazarlık var mı?"),
                  SizedBox(height: 10,),
                  getButton("Ne zaman alabilirim?"),
                  SizedBox(height: 10,),
                  getButton("Sorunu var mı?"),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: _textEditingController,
                    style: TextStyle(color: themeColor),
                    validator: (value){
                      return value.isNotEmpty ? null : "Invalid Field";
                    },
                    decoration: InputDecoration(
                      labelText: "Keni Mesajını Yaz",
                      labelStyle: TextStyle(color: themeColor),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send_outlined,color: themeColor,),
                        onPressed: () =>sendMessage(context,_textEditingController.text,product),
                      ),
                      enabledBorder: border,
                      focusedBorder: border,
                    ),
                  )
                ],
              ),
            ),
          );
        });

      },
    );

  }
}


class SelectedPhoto extends StatelessWidget {

  final int numberOfDots;
  final int photoIndex;
  const SelectedPhoto({this.numberOfDots, this.photoIndex});

  Widget _inactivePhoto() {
    return new Container(
      child: new Padding(
        padding: const EdgeInsets.only(left: 3, right: 3),
        child: Container(
          height: 10.0,
          width: 10.0,
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
    );
  }

  Widget _activePhoto() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        child: Container(
          height: 15.0,
          width: 15.0,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey, spreadRadius: 0.0, blurRadius: 2.0)
              ]),
        ),
      ),
    );
  }

  List<Widget> _buildDots() {
    List<Widget> dots = [];
    for (int i = 0; i < numberOfDots; ++i) {
      dots.add(i == photoIndex ? _activePhoto() : _inactivePhoto());
    }
    dots.add(Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        "${photoIndex+1}/$numberOfDots",
        style: TextStyle(color: Colors.black, fontSize: 20),
      ),
    ));
    return dots;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30.0, bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: _buildDots(),
      ),
    );
  }



}