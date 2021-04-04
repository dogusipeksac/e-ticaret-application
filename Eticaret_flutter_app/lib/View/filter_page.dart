import 'package:e_ticaret_flutter_app/Database/product_share_service.dart';
import 'package:e_ticaret_flutter_app/DesignStyle/colors_cons.dart';
import 'package:e_ticaret_flutter_app/DesignStyle/for_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';



class FilterPage extends StatefulWidget {
  static String routeName = '/routeFilterPage';
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String valueChoseCategoryOnTheFilter;
  String valueChoseLocation;
  String selectedButtonSmartSort;

  ProductShareService _productSharePage = ProductShareService();
  String image = "";

  List listItemCategory = [
    "2.El Araç",
    "1.El Araç",
    "Teknoloji",
    "Telefon",
    "Giyim"
  ];
  List listItemCityState = ["Adana", "Mersin", "İstanbul", "Malatya"];


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width*2;
    double height = MediaQuery.of(context).size.height*2;
    final TextEditingController _title = TextEditingController();


    final title = TextField(
        controller: _title,
        obscureText: false,
        cursorColor: text,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.bottom,
        style: TextStyle(
          fontSize: 20,
          color: text,
        ),
        decoration: InputDecoration(
          hintText: "İlanınız için başlık giriniz.",
          hintStyle: TextStyle(color: textDarkHint),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: filterBackground),
          ),
        ));



    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: background,
      appBar: AppBar(
        title: Text('Filtrele'),
        backgroundColor: background,
      ),
      body: Stack(
        children: [
          // DraggableScrollableSheet(
          /* initialChildSize: 0.6,
            minChildSize: 0.1,
            maxChildSize: 0.9,*/
          // builder: (BuildContext context, myScrollConroller) {
          Container(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(10),/*
                  controller: myScrollConroller,*/
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10),
                  child: Text(
                    "Tüm Kategori",
                    style: filterStyle,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10),
                  child: Container(
                    padding: EdgeInsets.only(left: 14, right: 14),
                    decoration: BoxDecoration(
                      color: filterBackground,
                      border: Border.all(color: filterBackground, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: DropdownButton(
                      hint: Text(
                        "Bir kategori seç...",
                        style: textStyle,
                      ),
                      dropdownColor: background,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      iconSize: 30,
                      isExpanded: true,
                      underline: SizedBox(),
                      value: valueChoseCategoryOnTheFilter,
                      style: textStyle,
                      onChanged: (newValue) {
                        setState(() {
                          valueChoseCategoryOnTheFilter = newValue;
                        });
                      },
                      items: listItemCategory.map((valueItem) {
                        return DropdownMenuItem(
                          value: valueItem,
                          child: Text(valueItem),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10),
                  child: Text(
                    "Fiyat Aralığı",
                    style: filterStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 1,right: 10),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: filterBackground,
                              border: Border.all(color: filterBackground, width: 1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 1,right: 10),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: filterBackground,
                              border: Border.all(color: filterBackground, width: 1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ],

                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10),
                  child: Text(
                    "Konum",
                    style: filterStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10),
                  child: Container(
                    padding: EdgeInsets.only(left: 14, right: 14),
                    decoration: BoxDecoration(
                      color: filterBackground,
                      border: Border.all(color: filterBackground, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: DropdownButton(
                      hint: Text(
                        "Bir şehir seç...",
                        style: textStyle,
                      ),

                      dropdownColor: background,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      iconSize: 30,
                      isExpanded: true,
                      underline: SizedBox(),
                      value: valueChoseLocation,
                      style: textStyle,
                      onChanged: (newValue) {
                        setState(() {
                          valueChoseLocation = newValue;
                        });
                      },
                      items: listItemCityState.map((valueItem) {
                        return DropdownMenuItem(
                          value: valueItem,
                          child: Text(valueItem),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10),
                  child: Text(
                    "Sırala",
                    style: filterStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10),
                  child: Container(
                      height: 50,
                      width: 50,
                      padding: EdgeInsets.only(left: 14, right: 14),
                      decoration: BoxDecoration(
                        color: filterBackground,
                        border: Border.all(color: filterBackground, width: 1),
                        borderRadius: BorderRadius.circular(15),
                      )
                  ),

                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    padding: EdgeInsets.only(left: 14, right: 14),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: themeColor,
                      border: Border.all(color: filterBackground, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),

                    child: FlatButton(
                      onPressed: (){

                      },
                      child: Text("Filtrele",style:TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                      ),),

                    ),
                  ),
                ),
              ],
            ),
          ),

          //},
          // ),
        ],
      ),
    );
  }
}



