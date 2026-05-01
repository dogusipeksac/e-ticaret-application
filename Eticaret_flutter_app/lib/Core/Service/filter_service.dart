import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_ticaret_flutter_app/Model/filteredArgClass.dart';
import 'package:e_ticaret_flutter_app/Model/product.dart';

class FilterService{
  static Query? _query;
  static FilteredArgClass? _filter;

  static FilteredArgClass? get getFilter{
    return _filter;
  }
  static set setFilter(FilteredArgClass? filter){
    _filter = filter;
  }
  static Query? get getQuery{
    return _query;
  }
  static set setQuery(Query? query){
    _query = query;
  }
  Stream<List<Product>> filteredProductList(){
    final query = _query;
    if (query == null) {
      return const Stream.empty();
    }
    return query
        .snapshots()
        .map((qShot) => qShot.docs
        .map((doc) => Product.fromSnapshot(doc))
        .toList());
  }
}