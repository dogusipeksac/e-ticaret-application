import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_ticaret_flutter_app/Core/Service/chat_service.dart';
import 'package:e_ticaret_flutter_app/Core/Service/product_share_service.dart';
import 'package:e_ticaret_flutter_app/Core/Service/wish_list_service.dart';
import 'package:e_ticaret_flutter_app/DesignStyle/for_text_style.dart';
import 'package:e_ticaret_flutter_app/Model/Wish.dart';
import 'package:e_ticaret_flutter_app/Model/product.dart';
import 'package:e_ticaret_flutter_app/View/message_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_ticaret_flutter_app/DesignStyle/colors_cons.dart';
import 'package:provider/provider.dart';

class AdDetail extends StatefulWidget {
  static String routeName = '/routeAdDetailPage';
  final Product snapshot;

  const AdDetail({super.key, required this.snapshot});

  @override
  _AdDetailState createState() => _AdDetailState();
}

class _AdDetailState extends State<AdDetail> {
  final WishListService _wishListService = WishListService();
  late final Product product;
  late final List<String> images;
  late final PageController pageController;
  late int currentPhoto;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    product = widget.snapshot;
    images = widget.snapshot.getImages();
    pageController = PageController(initialPage: 0, viewportFraction: 1);
    currentPhoto = pageController.initialPage;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final _pageView = SizedBox(
      height: size.height / 2,
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
        ],
      ),
    );
    final _productDetail = Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            product.productTitle ?? '',
            style: detailTitle,
            maxLines: 2,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "${product.productPrice} TL",
            style: detailPrice,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Açıklama :",
            style: detailDescriptionTitle,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            product.productOfDescription ?? '',
            style: detailDescription,
          ),
        ],
      ),
    );

    return Consumer<User>(
      builder: (context, user, child) => Scaffold(
        backgroundColor: background,
        bottomNavigationBar: DetailBottomAppBar(product: product),
        body: Column(
          children: [
            Flexible(child: _pageView),
            StreamBuilder<QuerySnapshot>(
              stream: _wishListService.countOfProductWish(product.id ?? ''),
              builder: (builder, count) {
                print(count.data);
                if (count.hasData)
                  {
                  final wishCount = count.data?.size ?? 0;
                  return product.userId != user.uid
                      ? _wishListService.isInWishList(
                          product.id ?? '',
                          wishCount,
                          whenTrue: IconButton(
                            iconSize: 45,
                            color: themeColor,
                            icon: Icon(
                              Icons.favorite,
                            ),
                            onPressed: () => removeWishList(user.uid),
                          ),
                          whenFalse: IconButton(
                            iconSize: 45,
                            color: themeColor,
                            icon: Icon(Icons.favorite_outline),
                            onPressed: () => addWishList(),
                          ),
                        )
                      : Container(
                          width: size.width,
                          color: Colors.black45.withOpacity(0.3),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Center(
                              child: Text(
                            "$wishCount kişi istek listesine ekledi",
                            style: detailDescription,
                          )),
                        );
                  }
                return Center(child: CircularProgressIndicator());
              },
            ),
            Flexible(
              child: ListView(
                children: [_productDetail],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///Product Detail Page FUNCTIONS
  addWishList() {
    _wishListService.addWishList(product);
  }

  removeWishList(String userId) {
    _wishListService.removeWishList(Wish(
      willingId: userId,
      productId: product.id,
    ));
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
}

class DetailBottomAppBar extends StatelessWidget {
  final Product product;

  DetailBottomAppBar({super.key, required this.product});

  final ChatService _chatService = ChatService();
  final ProductShareService service = ProductShareService();


  @override
  Widget build(BuildContext context) {
    bool hasMessageData=false;
    final Size size = MediaQuery.of(context).size;
    final Size buttonSize = Size(size.width / 3, size.height * 0.05);
    final buttonStyle = ElevatedButton.styleFrom(
        minimumSize: buttonSize, backgroundColor: themeColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10);
    return Consumer<User>(
      builder: (context, user, child) => BottomAppBar(
          color: filterBackground,
          child: Row(
            children: [
              Spacer(),
              FutureBuilder<String>(
                future:
                    _chatService.productConversitonsExist(product.id ?? '', user.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("Birşeyler yanlış gitti");

                  }
                  return snapshot.data != null
                      ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => MessageDetailPage(
                                            product: product,
                                            conservationId: snapshot.data,
                                          ))));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),

                              child: Text(
                                "Mesaja Git",
                                style: detailButtonTextStyle,
                              ),
                            ),
                            style: buttonStyle,
                          ),
                      )
                      : product.userId != user.uid ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              showInformationDialog(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                "Mesaj At",
                                style: detailButtonTextStyle,
                              ),
                            ),
                            style: buttonStyle,
                          ),
                      )
                      : Container(width:0,height:0);
                },
              ),
              product.userId != user.uid
                  ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {},
                        child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: Text(
                              "Ara",
                              style: detailButtonTextStyle,
                            )),
                        style: buttonStyle,
                      ),
                  )
                  : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () async {
                          await service
                              .remove(product.id ?? '')
                              .whenComplete(() => Navigator.pop(context));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            "Sil",
                            style: TextStyle(
                                color: background,
                                fontSize: 20,
                            ),
                          ),
                        ),
                        style: buttonStyle,
                      ),
                  ),
              Spacer(),
            ],
          )),
    );
  }

  ///Form key for dialog of form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ///Dialog builder for sending const or custom message to seller
  Future<void> showInformationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        ///information dialog text edit controller
        final TextEditingController _textEditingController =
            TextEditingController();

        ///information dialog button style
        final buttonStyle = ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)), backgroundColor: themeColor,
            elevation: 10);

        ///information dialog button template
        Widget getButton(String text) {
          return ButtonTheme(
            minWidth: double.infinity,
            height: 50,
            buttonColor: themeColor,
            child: ElevatedButton(
              onPressed: () => _textEditingController.text = text,
              style: buttonStyle,
              child: Text(
                text,
                style: TextStyle(color: background, fontSize: 20),
              ),
            ),
          );
        }

        ///information dialog text field input border style
        OutlineInputBorder border = OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(
            width: 2,
            color: themeColor,
          ),
        );

        return StatefulBuilder(builder: (context, setState) {
          return Consumer<User>(
            builder: (context, user, child) => AlertDialog(
              scrollable: true,
              title: Center(
                  child: Text(
                "Mesaj Gönder",
                style: TextStyle(color: Colors.white),
              )),
              backgroundColor: background,
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    getButton("Hala satılık mı?"),
                    SizedBox(
                      height: 10,
                    ),
                    getButton("Pazarlık var mı?"),
                    SizedBox(
                      height: 10,
                    ),
                    getButton("Ne zaman alabilirim?"),
                    SizedBox(
                      height: 10,
                    ),
                    getButton("Sorunu var mı?"),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _textEditingController,
                      style: TextStyle(color: themeColor),
                      validator: (value) {
                        return (value ?? '').isNotEmpty ? null : "Invalid Field";
                      },
                      decoration: InputDecoration(
                        labelText: "Keni Mesajını Yaz",
                        labelStyle: TextStyle(color: themeColor),
                        suffixIcon: IconButton(
                            icon: Icon(
                              Icons.send_outlined,
                              color: themeColor,
                            ),
                            onPressed: () async {
                              sendMessage(context, _textEditingController.text,
                                  product, user);
                            }),
                        enabledBorder: border,
                        focusedBorder: border,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  ///send message function for sending custom or const message send to
  ///message detail page
  sendMessage(
      BuildContext context, String message, Product product, User user) async {
    var concversitonId =
        await _chatService.chatStart(product, user.uid, message);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => MessageDetailPage(
                  product: product,
                  conservationId: concversitonId,
                ))));
  }
}

class SelectedPhoto extends StatelessWidget {
  final int numberOfDots;
  final int photoIndex;
  const SelectedPhoto({super.key, required this.numberOfDots, required this.photoIndex});

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
        "${photoIndex + 1}/$numberOfDots",
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
