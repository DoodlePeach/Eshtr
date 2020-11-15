import 'package:flutter/cupertino.dart';
import './../models/product_model.dart';
import './../resources/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc  with ChangeNotifier{
  var filter = new Map<String, dynamic>();
  int page = 1;
  final apiProvider = ApiProvider();

  final _hasMoreSearchItemsFetcher = BehaviorSubject<bool>();
  final _searchLoadingFetcher = BehaviorSubject<bool>();
  final _searchFetcher = BehaviorSubject<List<Product>>();

  Observable<List<Product>> get searchResults => _searchFetcher.stream;
  Observable<bool> get hasMoreItems => _hasMoreSearchItemsFetcher.stream;
  Observable<bool> get searchLoading => _searchLoadingFetcher.stream;

  fetchSearchResults(String query) async {
    filter['q'] = query.toString();
    page = 1;
    _searchLoadingFetcher.sink.add(true);
    final response = await apiProvider.fetchProducts(filter);
    _searchLoadingFetcher.sink.add(false);
    if (response.statusCode == 200) {
      List<Product> products = productModelFromJson(response.body);
      _searchFetcher.sink.add(products);
      if(products.length == 0){
        _hasMoreSearchItemsFetcher.sink.add(false);
      }
    } else {
      throw Exception('Failed to load products');
    }
  }

 loadMoreSearchResults(String query) async {
    filter['q'] = query.toString();
    page = page + 1;
    filter['page'] = page.toString();
    final response = await apiProvider.fetchProducts(filter);
    if (response.statusCode == 200) {
      List<Product> products = productModelFromJson(response.body);
      _searchFetcher.sink.add(products);
      if(products.length == 0){
        _hasMoreSearchItemsFetcher.sink.add(false);
      }
    } else {
      throw Exception('Failed to load products');
    }
  }

  dispose() {
    _hasMoreSearchItemsFetcher.close();
    _searchFetcher.close();
    _searchLoadingFetcher.close();
  }
}
