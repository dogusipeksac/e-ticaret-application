
import 'package:e_ticaret_flutter_app/Core/Service/filter_service.dart';
import 'package:e_ticaret_flutter_app/DesignStyle/colors_cons.dart';
import 'package:e_ticaret_flutter_app/DesignStyle/for_text_style.dart';
import 'package:e_ticaret_flutter_app/Model/filteredArgClass.dart';
import 'package:e_ticaret_flutter_app/View/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class FilterPage extends StatefulWidget {
  static String routeName = '/routeFilterPage';
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String? valueChoseCategoryOnTheFilter;
  String? valueChoseLocation;
  String? selectedButtonSmartSort;
  final TextEditingController _minimum = TextEditingController();
  final TextEditingController _maximum = TextEditingController();

  String image = "";

  List<String> listItemCategory = [
    "Bir kategori seç...",
    "2.El Araç",
    "1.El Araç",
    "Teknoloji",
    "Telefon",
    "Giyim"
  ];
  List<String> listItemCityState = ["Bir şehir seç...","Adana", "Mersin", "İstanbul", "Malatya"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final filter = FilterService.getFilter;
    valueChoseCategoryOnTheFilter = filter?.category;
    valueChoseLocation = filter?.location;
    selectedButtonSmartSort = filter?.getSort;
    _maximum.text = (filter?.priceMax ?? '').toString();
    _minimum.text = (filter?.priceMin ?? '').toString();
    }

  reset(){
    setState(() {
      valueChoseCategoryOnTheFilter = null;
      valueChoseLocation = null;
      selectedButtonSmartSort = null;
      _maximum.text = "";
      _minimum.text = "";
      FilterService.setFilter = null;
      FilterService.setQuery = null;
    });
  }

  @override
  Widget build(BuildContext context) {

    final minumumPrize = TextField(
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        controller: _minimum,
        obscureText: false,
        cursorColor: themeColor,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.bottom,
        style: TextStyle(
          fontSize: 18,
          color: text,
        ),
        decoration: InputDecoration(
          hintText: "Minimum(TL)",
          hintStyle: TextStyle(color: textDarkHint),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: filterBackground, width: 0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: filterBackground, width: 0),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: filterBackground, width: 0),
          ),
        ),
    );
    final maximumPrize = TextField(
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        controller: _maximum,
        obscureText: false,
        cursorColor: themeColor,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.bottom,
        style: TextStyle(
          fontSize: 18,
          color: text,
        ),
        decoration: InputDecoration(
          hintText: "Maximum(TL)",
          hintStyle: TextStyle(color: textDarkHint),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: filterBackground, width: 0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: filterBackground, width: 0),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: filterBackground, width: 0),
          ),
        ),
    );

    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushNamed(context, HomePage.routeName),
        ),
        title: Text('Filtrele'),
        backgroundColor: background,
      ),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(10),
          /*
              controller: myScrollConroller,*/
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: Text(
                "Tüm Kategori",
                style: filterStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
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
                      if(newValue == listItemCategory.elementAt(0))
                        valueChoseCategoryOnTheFilter = null;
                      else
                        valueChoseCategoryOnTheFilter = newValue as String?;
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
              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: Text(
                "Fiyat Aralığı",
                style: filterStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 1, right: 10),
                      child: Container(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, bottom: 2),
                          child: minumumPrize,
                        ),
                        height: 50,
                        decoration: BoxDecoration(
                          color: filterBackground,
                          border:
                              Border.all(color: filterBackground, width: 1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 1, right: 10),
                      child: Container(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, bottom: 2),
                          child: maximumPrize,
                        ),
                        height: 50,
                        decoration: BoxDecoration(
                          color: filterBackground,
                          border:
                              Border.all(color: filterBackground, width: 1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: Text(
                "Konum",
                style: filterStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
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
                      if(newValue == listItemCityState.elementAt(0))
                        valueChoseLocation = null;
                      else
                        valueChoseLocation = newValue as String?;
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
              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: Text(
                "Sırala",
                style: filterStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: Column(
                children: [
                  Row(
                    children:<Widget> [
                      ForShortContainer(
                        onPressed: () {
                          setState(() {
                            selectedButtonSmartSort = FilteredArgClass.SORT_PRIVATE;
                          });
                        },
                        color: selectedButtonSmartSort == FilteredArgClass.SORT_PRIVATE
                            ? themeColor
                            : filterBackground,
                        child: Center(child: Text("Akıllı Sıralama",style: textStyle,)),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ForShortContainer(
                        onPressed: () {
                          setState(() {
                            selectedButtonSmartSort = FilteredArgClass.SORT_DECRAESE;
                          });
                        },
                        color: selectedButtonSmartSort == FilteredArgClass.SORT_DECRAESE
                            ? themeColor
                            : filterBackground,
                        child: Center(child: Text("Azalan fiyat",style: textStyle,)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      ForShortContainer(
                        onPressed: () {
                          setState(() {
                            selectedButtonSmartSort = FilteredArgClass.SORT_INCREASE;
                          });
                        },
                        color: selectedButtonSmartSort == FilteredArgClass.SORT_INCREASE
                            ? themeColor
                            : filterBackground,
                        child: Center(child: Text("Artan fiyat",style: textStyle,)),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                   /*   ForShortContainer(
                        onPressed: () {
                          setState(() {
                            selectedButtonSmartSort = '';
                          });
                        },
                      ),*/
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(
                    width: 150,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: themeColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    onPressed: () {
                      FilterService.setFilter =
                          FilteredArgClass(
                            category: valueChoseCategoryOnTheFilter,
                            location: valueChoseLocation,
                            priceMax: _maximum.text.isEmpty ? null : double.parse(_maximum.text),
                            priceMin: _minimum.text.isEmpty ? null : double.parse(_minimum.text),
                          ).setSort(selectedButtonSmartSort ?? '');
                      FilterService.setQuery = FilterService.getFilter?.buildQuery();
                      Navigator.pushNamed(context, HomePage.routeName);
                    },
                    child: Text(
                      "Filtrele",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: themeColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    onPressed: () {
                      reset();
                    },
                    child: Text(
                      "Resetle",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ForShortContainer extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color color;

  const ForShortContainer({
    super.key,
    this.onPressed,
    required this.child,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          child: child,
          height: 50,
          width: 150,
          padding: EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: filterBackground, width: 1),
            borderRadius: BorderRadius.circular(15),
          )),
    );
  }
}
