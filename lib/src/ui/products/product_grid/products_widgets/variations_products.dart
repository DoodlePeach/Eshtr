import '../../../../functions.dart';
import './../../../../models/app_state_model.dart';
import './../../../../models/product_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class VariationProduct extends StatefulWidget {

  VariationProduct({
    Key key,
    @required this.id,
    @required this.variation,
  }) : super(key: key);

  final int id;
  final AvailableVariation variation;
  final model = AppStateModel();

  @override
  _VariationProductState createState() => _VariationProductState();
}

class _VariationProductState extends State<VariationProduct> {

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leadingIcon(),
      title: Text(parseHtmlString(getTitle())),
      trailing: (getQty() != 0 || isLoading) ? SizedBox(
        width: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(
              padding: EdgeInsets.all(0.0),
              icon: Icon(Icons.add_circle_outline, color: Theme.of(context).textTheme.bodyText1.color.withOpacity(0.6)),
              //tooltip: 'Increase quantity by 1',
              onPressed: () {
                increaseQty();
              },
            ),
            isLoading ? SizedBox(
              child: CircularProgressIndicator(strokeWidth: 2),
              height: 20.0,
              width: 20.0,
            ) :  SizedBox(
              width: 20.0,
              child: Text(getQty().toString(), textAlign: TextAlign.center,),
            ),
            IconButton(
              padding: EdgeInsets.all(0.0),
              icon: Icon(Icons.remove_circle_outline, color: Theme.of(context).textTheme.bodyText1.color.withOpacity(0.6)),
              //tooltip: 'Decrease quantity by 1',
              onPressed: () {
                decreaseQty();
              },
            ),
          ],
        ),
      ) : SizedBox(
        width: 120,
        height: 35,
        child: RaisedButton(
          elevation: 0,
          shape: StadiumBorder(),
          child: Text(widget.model.blocks.localeText.add),
          onPressed: () => addToCart(),
        ),
      ),
    );
  }

  getTitle() {
    var name = '';
    widget.variation.option.forEach((atr) => {
      name = name + atr.value + ' '
    });
    return name;
  }

  Container leadingIcon() {
    return Container(
      width: 30,
      height: 30,
      child: CachedNetworkImage(
        imageUrl: widget.variation.image.url != null ? widget.variation.image.url : '',
        imageBuilder: (context, imageProvider) => Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0.0,
          margin: EdgeInsets.all(0.0),
          //shape: StadiumBorder(),
          child: Ink.image(
            child: InkWell(
              onTap: () {
                //onCategoryClick(category);
              },
            ),
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
        placeholder: (context, url) => Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0.0,
          //shape: StadiumBorder(),
        ),
        errorWidget: (context, url, error) => Card(
          elevation: 0.0,
          color: Colors.white,
          //shape: StadiumBorder(),
        ),
      ),
    );
  }

  addToCart() async {
    var data = new Map<String, dynamic>();
    data['product_id'] = widget.id.toString();
    data['variation_id'] = widget.variation.variationId.toString();
    data['quantity'] = '1';
    setState(() {
      isLoading = true;
    });
    await widget.model.addToCart(data);
    setState(() {
      isLoading = false;
    });
  }

  decreaseQty() async {
    if (widget.model.shoppingCart?.cartContents != null) {
      if (widget.model.shoppingCart.cartContents
          .any((cartContent) => cartContent.variationId == widget.variation.variationId)) {
        final cartContent = widget.model.shoppingCart.cartContents
            .singleWhere((cartContent) => cartContent.variationId == widget.variation.variationId);
        setState(() {
          isLoading = true;
        });
        await widget.model.decreaseQty(cartContent.key, cartContent.quantity);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  increaseQty() async {
    if (widget.model.shoppingCart?.cartContents != null) {
      if (widget.model.shoppingCart.cartContents
          .any((cartContent) => cartContent.variationId == widget.variation.variationId)) {
        final cartContent = widget.model.shoppingCart.cartContents
            .singleWhere((cartContent) => cartContent.variationId == widget.variation.variationId);
        setState(() {
          isLoading = true;
        });
        await widget.model.increaseQty(cartContent.key, cartContent.quantity);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  getQty() {
    if(widget.model.shoppingCart.cartContents.any((element) => element.variationId == widget.variation.variationId)) {
      return widget.model.shoppingCart.cartContents.firstWhere((element) => element.variationId == widget.variation.variationId).quantity;
    } else return 0;
  }
}