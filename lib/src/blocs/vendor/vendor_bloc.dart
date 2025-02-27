import 'dart:convert';
import '../../models/checkout/checkout_form_model.dart';
import '../../models/orders_model.dart';
import '../../models/vendor/product_variation_model.dart';
import '../../models/vendor/vendor_product_model.dart';
import '../../resources/wc_api.dart';
import '../../resources/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class VendorBloc {
  List<VendorProduct> products;
  List<ProductVariation> variationProducts;
  var productFilter = new Map<String, dynamic>();
  var orderFilter = new Map<String, dynamic>();
  var variationFilter = new Map<String, dynamic>();

 // final order = Order();

  int productPage = 0;
  String initialSelectedCountry = 'IN';
  var formData = new Map<String, String>();
  int ordersPage = 0;

  static WooCommerceAPI wc_api = new WooCommerceAPI();

  final apiProvider = ApiProvider();
  final _vendorProductsFetcher = PublishSubject<List<VendorProduct>>();
  final _vendorVariationProductsFetcher =
      PublishSubject<List<ProductVariation>>();
  final _ordersFetcher = BehaviorSubject<List<Order>>();
  final _vendorOrderFormFetcher = BehaviorSubject<CheckoutFormModel>();

  Observable<List<Order>> get allOrders => _ordersFetcher.stream;
  Observable<List<VendorProduct>> get allVendorProducts =>
      _vendorProductsFetcher.stream;
  Observable<List<ProductVariation>> get allVendorVariationProducts =>
      _vendorVariationProductsFetcher.stream;
  Observable<CheckoutFormModel> get vendorOrderForm =>
      _vendorOrderFormFetcher.stream;

  fetchAllProducts([String query]) async {
    productFilter['page'] = 1;
    // _vendorProductsFetcher.sink.add([]);
    final response =
        await wc_api.getAsync("products" + getQueryString(productFilter));
    print(response.body);
    products = productFromJson(response.body);
    //products.addAll(products);

    _vendorProductsFetcher.sink.add(products);
  }

  Future<VendorProduct> addProduct(VendorProduct product) async {
    final response = await wc_api.postAsync("products", product.toJson());
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return VendorProduct.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add product');
    }
  }

  Future<VendorProduct> editProduct(VendorProduct product) async {
    final response = await wc_api.putAsync(
        "products/" + product.id.toString(), product.toJson());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return VendorProduct.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to edit product');
    }
  }

  Future<VendorProduct> deleteProduct(VendorProduct product) async {
    final response =
        await wc_api.deleteAsync("products/" + product.id.toString());
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return VendorProduct.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to delete product');
    }
  }

  Future<bool> loadMoreProducts() async {
    productFilter['page'] =
        productFilter['page'] == null ? 1 : productFilter['page'] + 1;
    print(getQueryString(productFilter));
    final response =
        await wc_api.getAsync('products' + getQueryString(productFilter));
    List<VendorProduct> moreProducts = productFromJson(response.body);
    products.addAll(moreProducts);
    _vendorProductsFetcher.sink.add(products);
    if (moreProducts.length == 0) {
      return false;
    } else return true;
  }

  //orders

  List<Order> orders = [];

  getOrders([String query]) async {
    orderFilter['page'] = 1;
    final response = await wc_api.getAsync("orders" + getQueryString(orderFilter));
    orders = orderFromJson(response.body);
    _ordersFetcher.sink.add(orders);
    //_hasMoreOrdersFetcher.sink.add(true);
  }

  Future<bool> loadMoreOrders() async {
    orderFilter['page'] = orderFilter['page'] + 1;
    final response = await wc_api.getAsync("orders" + getQueryString(orderFilter));
    List<Order> moreOrders = orderFromJson(response.body);
    orders.addAll(moreOrders);
    _ordersFetcher.sink.add(orders);
    if(moreOrders.length < 10) {
      return false;
    } return true;
  }

  Future<Order> addOrder(Order order) async {
    final response = await wc_api.postAsync("orders", order.toJson());
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Order.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add order');
    }
  }

  Future<Order> editOrder(Order order) async {
    final response =
        await wc_api.putAsync("orders/" + order.id.toString(), order.toJson());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Order.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to edit order');
    }
  }

  Future<Order> deleteOrder(Order order) async {
    final response = await wc_api.deleteAsync("orders/" + order.id.toString());
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Order.fromJson(json.decode(response.body));
    }
  }

  void getVendorOrderForm() async {
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-get_checkout_form',
        Map()); //formData.toJson();
    if (response.statusCode == 200) {
      CheckoutFormModel checkoutForm =
          CheckoutFormModel.fromJson(json.decode(response.body));
      _vendorOrderFormFetcher.sink.add(checkoutForm);
    } else {
      throw Exception('Failed to load checkout form');
    }
  }

//wallet

  getWallet() async {
    final response = await wc_api.postAsync(
        '/wp-admin/admin-ajax.php?action=mstoreapp-wallet', Map());
  }

  //Variation Products

  Future<void> getVariationProducts(int id) async {
    variationFilter['per_page'] = 100;
    final response = await wc_api.getAsync("products/" +
        id.toString() +
        "/variations" +
        getQueryString(variationFilter));
    variationProducts = productVariationFromJson(response.body);
    _vendorVariationProductsFetcher.sink.add(variationProducts);
  }

  Future<ProductVariation> addVariationProduct(int id, ProductVariation variationProduct) async {
    final response = await wc_api.postAsync(
        "products/" + id.toString() + "/variations", variationProduct.toJson());
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ProductVariation.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add product');
    }
  }

  Future<ProductVariation> editVariationProduct(int productId, ProductVariation variationProduct) async {

    final response = await wc_api.putAsync("products/" + productId.toString() + "/variations/" + variationProduct.id.toString(), variationProduct.toJson());
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ProductVariation.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to edit product');
    }
  }

  Future<ProductVariation> deleteVariationProduct(int id, int variationId) async {
    final response = await wc_api.deleteAsync("products/" + id.toString() + "/variations/" + variationId.toString() + '?force=true');

    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ProductVariation.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to delete product');
    }
  }

  dispose() {
    _vendorProductsFetcher.close();
    _ordersFetcher.close();
    _vendorVariationProductsFetcher.close();
    _vendorOrderFormFetcher.close();
  }
}

String getQueryString(Map params,
    {String prefix: '&', bool inRecursion: false}) {
  String query = '?';

  params['flutter_app'] = '1';

  params.forEach((key, value) {
    if (inRecursion) {
      key = '[$key]';
    }

    if (value is String || value is int || value is double || value is bool) {
      query += '$prefix$key=$value';
    } else if (value is List || value is Map) {
      if (value is List) value = value.asMap();
      value.forEach((k, v) {
        query +=
            getQueryString({k: v}, prefix: '$prefix$key', inRecursion: false);
      });
    }
  });

  return query;
}
