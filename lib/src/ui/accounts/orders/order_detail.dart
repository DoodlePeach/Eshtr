import 'package:flutter/material.dart';
import './../../../models/app_state_model.dart';
import './../../../models/orders_model.dart';
import 'package:intl/intl.dart';

class OrderDetail extends StatefulWidget {

  AppStateModel appStateModel = AppStateModel();

  final Order order;

  OrderDetail({this.order});

  @override
  _OrderDetailState createState() => _OrderDetailState(order: order);
}

class _OrderDetailState extends State<OrderDetail> {
  final Order order;

  _OrderDetailState({this.order});

  final TextStyle _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.currency(
        decimalDigits: widget.order.decimals, locale: Localizations.localeOf(context).toString(), name: widget.order.currency);
    return Scaffold(
        appBar: AppBar(

          title: Text(widget.appStateModel.blocks.localeText.order),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            buildOrderDetails(context, formatter),
            buildItemDetails(context, formatter),
            buildTotalDetails(context, formatter),
          ],
        ));
  }

  Widget buildOrderDetails(BuildContext context, NumberFormat formatter) {
    return SliverList(
        delegate: SliverChildListDelegate([
      Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10.0),
            Text(
              widget.appStateModel.blocks.localeText.order.toUpperCase() + ' - ' + order.number.toString(),
              style: Theme.of(context).textTheme.title,
            ),
            Divider(),
            SizedBox(height: 10.0),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.appStateModel.blocks.localeText.billing.toUpperCase(),
                    style: Theme.of(context).textTheme.subtitle,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                      '''${order.billing.firstName} ${order.billing.lastName} ${order.billing.address1} ${order.billing.address2} ${order.billing.city} ${order.billing.country} ${order.billing.postcode}'''),
                ]),
            Divider(),
            SizedBox(height: 10.0),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.appStateModel.blocks.localeText.shipping.toUpperCase(),
                    style: Theme.of(context).textTheme.subtitle,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                      '''${order.shipping.firstName} ${order.shipping.lastName} ${order.shipping.address1} ${order.shipping.address2} ${order.shipping.city} ${order.shipping.country} ${order.shipping.postcode}'''),
                ]),
            Divider(),
            SizedBox(height: 10.0),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.appStateModel.blocks.localeText.payment.toUpperCase(),
                    style: Theme.of(context).textTheme.subtitle,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(order.paymentMethodTitle),
                ]),
            Divider(),
            SizedBox(height: 10.0),
            order.lineItems != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                        Text(
                          widget.appStateModel.blocks.localeText.products.toUpperCase(),
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                      ])
                : Container(),
          ],
        ),
      )
    ]));
  }

  buildTotalDetails(BuildContext context, NumberFormat formatter) {
    return SliverList(
        delegate: SliverChildListDelegate([
      Container(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Divider(),
          SizedBox(height: 10.0),
          Text(
            widget.appStateModel.blocks.localeText.total.toUpperCase(),
            style: Theme.of(context).textTheme.subtitle,
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(widget.appStateModel.blocks.localeText.shipping,),
              ),
              Text(formatter.format((double.parse('${order.shippingTotal}')))),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(widget.appStateModel.blocks.localeText.tax,),
              ),
              Text(formatter.format((double.parse('${order.totalTax}')))),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(widget.appStateModel.blocks.localeText.discount),
              ),
              Text(formatter.format((double.parse('${order.discountTotal}')))),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  widget.appStateModel.blocks.localeText.total,
                  style: Theme.of(context).textTheme.title,
                ),
              ),
              Text(
                formatter.format(
                  double.parse(order.total),
                ),
                style: Theme.of(context).textTheme.title,
              ),
            ],
          ),
        ]),
      )
    ]));
  }

  buildItemDetails(BuildContext context, NumberFormat formatter) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(order.lineItems[index].name +
                              ' x ' +
                              order.lineItems[index].quantity.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(formatter.format(
                            (double.parse('${order.lineItems[index].total}')))),
                      ],
                    )),
              ],
            );
          },
          childCount: order.lineItems.length,
        ),
      ),
    );
  }
}
