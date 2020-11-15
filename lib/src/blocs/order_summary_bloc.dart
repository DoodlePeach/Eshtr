import 'dart:convert';
import './../models/orders_model.dart';
import './../resources/api_provider.dart';
import 'package:rxdart/rxdart.dart';


class OrderSummaryBloc {
  final _orderFetcher = BehaviorSubject<Order>();
  final apiProvider = ApiProvider();

  Observable<Order> get order => _orderFetcher.stream;

  getOrder(String id) async {
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-order', {'id': id});
    Order newOrder = Order.fromJson(json.decode(response.body));
    _orderFetcher.sink.add(newOrder);
  }

  dispose() {
    _orderFetcher.close();
  }

  Future<void> clearCart() async {
    final response = await apiProvider.get(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-clearCart');
  }
}