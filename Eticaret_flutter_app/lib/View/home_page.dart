
import 'package:e_ticaret_flutter_app/Core/Service/filter_service.dart';
import 'package:e_ticaret_flutter_app/Core/Service/product_share_service.dart';
import 'package:e_ticaret_flutter_app/DesignStyle/card_view.dart';
import 'package:e_ticaret_flutter_app/DesignStyle/categories_scroll.dart';
import 'package:e_ticaret_flutter_app/Model/product.dart';
import 'package:e_ticaret_flutter_app/View/filter_page.dart';
import 'package:e_ticaret_flutter_app/View/product_share_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../Map/main_drawer.dart';
import '../DesignStyle/colors_cons.dart';

//anasayfa
class HomePage extends StatefulWidget {
  static String routeName = '/routeHomePage';


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CategoriesScroller categoriesScroller = CategoriesScroller();
  TextEditingController controller = new TextEditingController();
  ScrollController scrollController = ScrollController();
  ProductShareService _productShareService = ProductShareService();
  FilterService _filterService = FilterService();
  late final Stream<List<Product>> productDatas;
  double topContainer = 0;
  bool closeTopContainer = false;
  bool filtered = false;


  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    _products.forEach((product) {
      if ((product.productTitle ?? '').contains(text) ||
          (product.productOfDescription ?? '').contains(text) ||
          (product.productCategory ?? '').contains(text)) {
        _searchResult.add(product);
      }
    });
    setState(() {});
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productDatas = _filterService.filteredProductList();
    filtered = true;
      scrollController.addListener(() {
      double value = scrollController.offset / 150;
      bool newBool = scrollController.offset > 50;
      if(newBool != closeTopContainer){
        setState(() {
          topContainer = value;
          closeTopContainer = newBool;
        },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const double _radius = 3;

    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height * 0.10;
    final underLine = UnderlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(_radius)),
        borderSide: BorderSide(color: themeColor));
    final searchInput = ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(_radius)),
      child: ListTile(
        tileColor: themeColor,
        contentPadding: EdgeInsets.only(left: 10),
        leading: new Icon(
          Icons.search,
          color: Colors.white,
        ),
        title: new TextField(
          controller: controller,
          style: TextStyle(
            color: searchText,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 8),
            hintText: "Ürün Ara",
            hintStyle: TextStyle(color: searchTextHint),
            filled: true,
            fillColor: themeColor,
            enabledBorder: underLine,
            focusedBorder: underLine,
            border: underLine,
          ),
          onChanged: onSearchTextChanged,
        ),
        trailing: new IconButton(
          icon: new Icon(
            Icons.cancel_outlined,
            color: Colors.white,
          ),
          onPressed: () {
            controller.clear();
            onSearchTextChanged('');
          },
        ),
      ),
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: background,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          actions: <Widget>[
            IconButton(
              onPressed: () => Navigator.pushNamed(context, FilterPage.routeName),
              icon: Icon(
                Icons.filter_list_rounded,
                color: filtered ? themeColor : Colors.white,
                size: 30,
              ),
            ),
          ],
          title: searchInput,
          backgroundColor: background,
        ),
        drawer: MainDrawer(),
        body: StreamBuilder<List<Product>>(
            stream: productDatas,
            builder:
                (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
              final products = snapshot.data ?? <Product>[];
              _products = products;
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (products.isEmpty) {
                return Center(
                    child: Text("Ürün Bulunamadı!",
                      style: TextStyle(color: Colors.white,fontSize: 30),
                    ),
                );
              }
              return Container(
                height: size.height,
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: closeTopContainer ? 0 : 1,
                      child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          width: size.width,
                          alignment: Alignment.topRight,
                          height: closeTopContainer ? 0 : categoryHeight,
                          child: categoriesScroller,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MasonryGridView.count(
                          controller: scrollController,
                          physics: BouncingScrollPhysics(),
                          crossAxisCount: 2,
                          itemCount: _searchResult.isNotEmpty
                              ? _searchResult.length
                              : products.length,
                          itemBuilder: (context, index) {
                            return CardView(
                              product: _searchResult.isNotEmpty
                                  ? _searchResult.elementAt(index)
                                  : products.elementAt(index),
                            );
                          },
                          mainAxisSpacing: 20.0,
                          crossAxisSpacing: 5.0,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, ProductSharePage.routeName);
          },
          elevation: 5,
          shape: CircleBorder(side: BorderSide(color: background, width: 3)),
          child: const Icon(
            Icons.add,
            color: background,
            size: 40,
          ),
          backgroundColor: themeColor,
        ),
      ),
    );
  }
  List<Product> _searchResult = [];

  List<Product> _products = [];
}