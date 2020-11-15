import './../models/WalletModel.dart';

import './../resources/api_provider.dart';
import 'package:rxdart/rxdart.dart';
import '../models/product_model.dart';

class WalletBloc {
  List<WalletModel> transaction;
  var filter = new Map<String, dynamic>();
  int page = 1;
  bool hasMoreItems = true;

  final apiProvider = ApiProvider();
  final _walletFetcher = PublishSubject<List<WalletModel>>();

  Observable<List<WalletModel>> get allTransactions => _walletFetcher.stream;

  load([String query]) async {
    page = 1;
    filter['page'] = page.toString();
    dynamic response = await apiProvider.postWithCookies('/wp-admin/admin-ajax.php?action=mstore_flutter_wallet', filter);
    if (response.statusCode == 200) {
      transaction = walletModelFromJson(response.body);
      _walletFetcher.sink.add(transaction);
    } else {
      throw Exception('Failed to load wallet');
    }
  }

  loadMore() async {
    page = page + 1;
    filter['page'] = page.toString();
    if(hasMoreItems) {
      dynamic response = await apiProvider.postWithCookies('/wp-admin/admin-ajax.php?action=mstore_flutter_wallet', filter);
      if (response.statusCode == 200) {
        List<WalletModel> moreData = walletModelFromJson(response.body);
        transaction.addAll(moreData);
        hasMoreItems = moreData.length == 0;
      } else {
        throw Exception('Failed to load wallet');
      }
    }
  }

  dispose() {
    _walletFetcher.close();
  }

  addBalance(Map<String, dynamic> data) async {
    print(data);
    dynamic response = await apiProvider.postWithCookies('/wp-admin/admin-ajax.php', data);
    return true;
  }
}
