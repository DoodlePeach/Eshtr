import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../assets/presentation/m_store_icons_icons.dart';
import 'models/category_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'models/app_state_model.dart';
import 'ui/accounts/account/account7.dart';
import 'ui/checkout/cart/cart4.dart';
import 'ui/home/home.dart';
import 'ui/categories/categories.dart';
import 'ui/products/product_detail/product_detail.dart';
import './ui/vendor/ui/stores/stores.dart';

class App extends StatefulWidget {
  //final ProductsBloc productsBloc = ProductsBloc();

  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with TickerProviderStateMixin {
  AppStateModel model = AppStateModel();
  int _currentIndex = 0;
  List<Category> mainCategories;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onChangePageIndex(int index) {
    print(model.blocks.localeText.account);
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = [
      Home(),
      Categories(),
      //Deals(),
      Stores(),
      CartPage(hideArrowButton: true),
      UserAccount(),
    ];

    return Scaffold(
      drawerDragStartBehavior: DragStartBehavior.start,
      floatingActionButton: ScopedModelDescendant<AppStateModel>(
          builder: (context, child, model) {
        if (model.blocks?.settings?.enableHomeChat == 1 && _currentIndex == 0) {
          return FloatingActionButton(
            onPressed: () =>
                _openWhatsApp(model.blocks.settings.whatsappNumber.toString()),
            tooltip: 'Chat',
            child: Icon(Icons.chat_bubble),
          );
        } else {
          return Container();
        }
      }),
      body: _children[_currentIndex],
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }


  onProductClick(product) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ProductDetail(product: product);
    }));
  }

  Future _openWhatsApp(String number) async {
    final url = 'https://wa.me/' + number;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  BottomNavigationBar buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: onChangePageIndex,
      backgroundColor: Theme.of(context).appBarTheme.color,
      type: BottomNavigationBarType.fixed,
      //showSelectedLabels: false,
      //showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
          backgroundColor: Theme.of(context).appBarTheme.color,
          icon: Icon(MStoreIcons.home_line),
          activeIcon: Icon(MStoreIcons.home_fill),
          title: Text(
            model.blocks.localeText.home,
            //style: TextStyle(fontSize: 12),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(MStoreIcons.layout_2_line),
          activeIcon: Icon(MStoreIcons.layout_2_fill),
          title: Text(
            model.blocks.localeText.category,
            //style: TextStyle(fontSize: 12),
          ),
        ),
        /*BottomNavigationBarItem(
          icon: const Icon(IconData(0xf3e5,
              fontFamily: CupertinoIcons.iconFont,
              fontPackage: CupertinoIcons.iconFontPackage)),
          title: Text('Deals',
          ),
        ),*/
        BottomNavigationBarItem(
            icon: Icon(MStoreIcons.store_2_line),
            activeIcon: Icon(MStoreIcons.store_2_fill),
          title: Text(model.blocks.localeText.stores,)
        ),
        BottomNavigationBarItem(
          icon: Stack(children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: Icon(MStoreIcons.shopping_basket_2_line),
            ),
            new Positioned(
              top: 0.0,
              right: 0.0,
              child: ScopedModelDescendant<AppStateModel>(
                  builder: (context, child, model) {
                if (model.count != 0) {
                  return Card(
                      elevation: 0,
                      clipBehavior: Clip.antiAlias,
                      shape: StadiumBorder(),
                      color: Colors.red,
                      child: Container(
                          padding: EdgeInsets.all(2),
                          constraints: BoxConstraints(minWidth: 20.0),
                          child: Center(
                              child: Text(
                            model.count.toString(),
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                backgroundColor: Colors.red),
                          ))));
                } else
                  return Container();
              }),
            ),
          ]),
          activeIcon: Stack(children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: Icon(MStoreIcons.shopping_basket_2_fill),
            ),
            new Positioned(
              top: 0.0,
              right: 0.0,
              child: ScopedModelDescendant<AppStateModel>(
                  builder: (context, child, model) {
                    if (model.count != 0) {
                      return Card(
                          elevation: 0,
                          clipBehavior: Clip.antiAlias,
                          shape: StadiumBorder(),
                          color: Colors.red,
                          child: Container(
                              padding: EdgeInsets.all(2),
                              constraints: BoxConstraints(minWidth: 20.0),
                              child: Center(
                                  child: Text(
                                    model.count.toString(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        backgroundColor: Colors.red),
                                  ))));
                    } else
                      return Container();
                  }),
            ),
          ]),
          title: Text(
            model.blocks.localeText.cart,
            //style: TextStyle(fontSize: 12),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(MStoreIcons.account_circle_line),
          activeIcon: Icon(MStoreIcons.account_circle_fill),
          title: Text(
            model.blocks.localeText.account,
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  Future<void> initPlatformState() async {

    if(model.blocks.settings.onesignalAppId.isNotEmpty) {
      var settings = {
        OSiOSSettings.autoPrompt: false,
        OSiOSSettings.promptBeforeOpeningPushUrl: true
      };

      OneSignal.shared.setRequiresUserPrivacyConsent(true);

      OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {

        print("Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}");

      });

      await OneSignal.shared
          .init(model.blocks.settings.onesignalAppId, iOSSettings: settings);

      var status = await OneSignal.shared.getPermissionSubscriptionState();

      model.playerId = status.subscriptionStatus.userId;
      print('model.playerId' + model.playerId);
      model.apiProvider.post('mstore_flutter_update_user_notification', {'onesignal_user_id': model.playerId});
    }

  }


}