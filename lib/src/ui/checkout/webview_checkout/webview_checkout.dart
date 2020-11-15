// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import '../../../config.dart';
import './../../../models/app_state_model.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../order_summary.dart';

class WebViewCheckout extends StatefulWidget {

  WebViewCheckout({
    Key key,
    @required this.redirect,
  }) : super(key: key);

  final String redirect;

  @override
  _WebViewCheckoutState createState() => _WebViewCheckoutState();
}

class _WebViewCheckoutState extends State<WebViewCheckout> {

  final Completer<WebViewController> _controller = Completer<WebViewController>();

  WebViewController _webViewController;

  bool cookiesSet = true;

  AppStateModel appStateModel = AppStateModel();

  String orderId;

  Config config = Config();

  Map<String, String> headers = {
    "content-type": "application/x-www-form-urlencoded; charset=utf-8"
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Builder(builder: (BuildContext context) {
        /*_controller.future.then((controller) {
          _webViewController = controller;

          if (appStateModel.user?.id != null && appStateModel.user.id != 0) {
            headers['user_id'] = appStateModel.user.id.toString();
            _webViewController.loadUrl(
                config.url +
                    '/wp-admin/admin-ajax.php?action=mstore_flutter-set_user_cart',
                headers: headers);
          } else {
            //TODO NEED TO SUBMIT ALL DATA FROM CART
            _webViewController.loadUrl(config.url +
                '/wp-admin/admin-ajax.php?action=mstore_flutter-add_all_products_cart');
          }
        });*/

        if (cookiesSet) {
          return WebView(
            initialUrl: 'https://foodyano.com/checkout',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            javascriptChannels: <JavascriptChannel>[].toSet(),
            navigationDelegate: (NavigationRequest request) {
              _webViewController.currentUrl().then(onValue);
              if (request.url.startsWith('url_to_be_prevented')) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {
              if (url.contains('set_user_cart') ||
                  url.contains('add_all_products_cart')) {
                _webViewController.loadUrl(config.url + '/checkout/');
              }
            },
            gestureNavigationEnabled: false,
          );
        } else
          return CircularProgressIndicator();
      }),
      //floatingActionButton: favoriteButton(),
    );
  }

  Future onValue(String url) {
    if (url.contains('/order-received/')) {
      orderSummary(url);
    }

    if (url.contains('/order-received/') &&
        url.contains('key=wc_order_') &&
        orderId != null) {
      navigateOrderSummary(url);
    }

    if (url.contains('type=success') && orderId != null) {
      navigateOrderSummary(url);
    }
  }

  void navigateOrderSummary(String url) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderSummary(
                  id: orderId,
                )));
  }

  void orderSummary(String url) {
    var str = url;
    var pos1 = str.lastIndexOf("/order-received/");
    var pos2 = str.lastIndexOf("/?key=wc_order");
    orderId = str.substring(pos1 + 16, pos2);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderSummary(
                  id: orderId,
                )));
  }
}
