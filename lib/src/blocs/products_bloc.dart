import 'dart:convert';
import 'package:flutter/material.dart';

import './../models/attributes_model.dart';
import './../resources/api_provider.dart';

import 'package:rxdart/rxdart.dart';
import '../models/product_model.dart';

class ProductsBloc {

  Map<String, List<Product>> products;
  var productsPage = new Map<String, int>();
  List<AttributesModel> attributes;
  var productsFilter = new Map<String, dynamic>();

  final apiProvider = ApiProvider();
  final _productsFetcher = BehaviorSubject<List<Product>>();
  final _attributesFetcher = BehaviorSubject<List<AttributesModel>>();
  final _hasMoreItemsFetcher = BehaviorSubject<bool>();
  final _isLoadingProductsFetcher = BehaviorSubject<bool>();

  ProductsBloc() : products = Map() {

  }

  //String search="";

  Observable<List<Product>> get allProducts => _productsFetcher.stream;
  Observable<List<AttributesModel>> get allAttributes => _attributesFetcher.stream;
  Observable<bool> get hasMoreItems => _hasMoreItemsFetcher.stream;
  Observable<bool> get isLoadingProducts => _isLoadingProductsFetcher.stream;



  fetchAllProducts([String query]) async {
    _hasMoreItemsFetcher.sink.add(true);
    if(products.containsKey(productsFilter['id']) && products[productsFilter['id']].isNotEmpty) {
      _productsFetcher.sink.add(products[productsFilter['id']]);
    } else {
      _productsFetcher.sink.add([]);
      products[productsFilter['id']] = [];
      productsPage[productsFilter['id']] = 1;
      productsFilter['page'] = productsPage[productsFilter['id']].toString();
      _isLoadingProductsFetcher.sink.add(true);
      List<Product> newProducts = await apiProvider.fetchProductList(productsFilter);
      products[productsFilter['id']].addAll(newProducts);
      _productsFetcher.sink.add(products[productsFilter['id']]);
      _isLoadingProductsFetcher.sink.add(false);
      if(newProducts.length < 10) {
        _hasMoreItemsFetcher.sink.add(false);
      }
    }
  }

  loadMore() async {
    productsPage[productsFilter['id']] = productsPage[productsFilter['id']] + 1;
    productsFilter['page'] = productsPage[productsFilter['id']].toString();
    List<Product> moreProducts = await apiProvider.fetchProductList(productsFilter);
    products[productsFilter['id']].addAll(moreProducts);
    _productsFetcher.sink.add(products[productsFilter['id']]);
    if(moreProducts.length < 10){
      _hasMoreItemsFetcher.sink.add(false);
    }
  }

  dispose() {
    _productsFetcher.close();
    _attributesFetcher.close();
    _hasMoreItemsFetcher.close();
    _isLoadingProductsFetcher.close();
  }

  Future fetchProductsAttributes() async {
    final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=mstore_flutter-product-attributes', {'category': productsFilter['id'].toString()});
    if (response.statusCode == 200) {
      attributes = filterModelFromJson(response.body);
      _attributesFetcher.sink.add(attributes);
    } else {
      throw Exception('Failed to load attributes');
    }
  }

  void clearFilter() {
    for(var i = 0; i < attributes.length; i++) {
      for(var j = 0; j < attributes[i].terms.length; j++) {
        attributes[i].terms[j].selected = false;
      }
    }
    _attributesFetcher.sink.add(attributes);
    fetchAllProducts();
  }

  void applyFilter(int id, double minPrice, double maxPrice) {
    if(products[productsFilter['id']] != null) {
      products[productsFilter['id']].clear();
    }

    //filter = new Map<String, dynamic>();
    //filter['id'] = id.toString();

    productsFilter['min_price'] = minPrice.toString();
    productsFilter['max_price'] = maxPrice.toString();
    if(attributes != null)
    for(var i = 0; i < attributes.length; i++) {
      for(var j = 0; j < attributes[i].terms.length; j++) {
        if(attributes[i].terms[j].selected) {
          productsFilter['attribute_term' + j.toString()] = attributes[i].terms[j].termId.toString();
          productsFilter['attributes' + j.toString()] = attributes[i].terms[j].taxonomy;
        }
      }
    }
    fetchAllProducts();
  }

  void changeCategory(int id) {
    productsFilter['id'] = id.toString();
    fetchAllProducts();
  }
}