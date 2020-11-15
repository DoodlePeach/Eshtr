import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:share/share.dart';
import '../../../functions.dart';
import '../../../models/app_state_model.dart';
import '../../../models/releated_products.dart';
import '../../../models/review_model.dart';
import '../../../blocs/product_detail_bloc.dart';
import '../../../models/product_model.dart';
import '../product_grid/product_item.dart';
import '../../checkout/cart/cart.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

double expandedAppBarHeight = 350;

class ProductDetail extends StatefulWidget {
  final ProductDetailBloc productDetailBloc = ProductDetailBloc();
  Product product;
  final appStateModel = AppStateModel();
  ProductDetail({this.product});

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  var saved;
  ScrollController _scrollController = new ScrollController();

  List<ReviewModel> reviews;

  var addingToCart = false;

  @override
  void initState() {
    super.initState();
    if(widget.product.description == null) {
      getProduct();
    }
    widget.productDetailBloc.getProductsDetails(widget.product.id);
    widget.productDetailBloc.getReviews(widget.product.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: widget.product.description != null ? buildBody()
      : CustomScrollView(
        slivers: <Widget>[
          _buildDBackgroundImage(),
          _buildDBackgroundCircleIndicator()
        ],
      ),
      floatingActionButton: ScopedModelDescendant<AppStateModel>(
          builder: (context, child, model) {
            if (model.blocks?.settings?.enableProductChat == 1) {
              return FloatingActionButton(
                onPressed: () => _openWhatsApp(
                    model.blocks?.settings?.whatsappNumber.toString()),
                tooltip: 'Chat',
                child: Icon(Icons.chat_bubble),
              );
            } else {
              return Container();
            }
          }),
    );
  }

  List<Widget> buildSliverList() {
    List<Widget> list = new List<Widget>();
    String key;
    list.add(_buildProductImages(key));
    list.add(buildNamePrice());

    if (widget.product.availableVariations != null &&
        widget.product.availableVariations?.length != 0) {
      for (var i = 0; i < widget.product.variationOptions.length; i++) {
        if (widget.product.variationOptions[i].options.length != 0) {
          list.add(buildOptionHeader(widget.product.variationOptions[i].name));
          list.add(buildProductVariations(widget.product.variationOptions[i]));
        }
      }
    }
    list.add(buildProductDetail());
    list.add(buildProductSortDescriptoion());
    list.add(buildProductDescriptoion());
    list.add(buildLisOfReleatedProducts());
    list.add(buildLisOfCrossSellProducts());
    list.add(buildLisOfUpSellProducts());
    list.add(buildReviews());
    return list;
  }

  Widget buildNamePrice() {

    bool onSale = false;

    if(widget.product.salePrice != null && widget.product.salePrice != 0) {
      onSale = true;
    }

    return SliverList(
        delegate: SliverChildListDelegate([
          Container(
            height: 90,
            child: Column(
              children: <Widget>[
                Expanded(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text(
                                widget.product.name,
                                maxLines: 1,
                                style: Theme.of(context).textTheme.body1,
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: <Widget>[
                                  Text(
                                      (widget.product.formattedSalesPrice != null &&
                                          widget.product.formattedSalesPrice.isNotEmpty)
                                          ? parseHtmlString(widget.product.formattedSalesPrice)
                                          : '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Theme.of(context).textTheme.title.color,
                                      )),
                                  SizedBox(width: 4.0),
                                  Text(
                                      (widget.product.formattedPrice != null &&
                                          widget.product.formattedPrice.isNotEmpty)
                                          ? parseHtmlString(widget.product.formattedPrice)
                                          : '',
                                      style: TextStyle(
                                        fontWeight: onSale ? FontWeight.w400 : FontWeight.w600,
                                        fontSize: onSale ? 12 : 16,
                                        color: onSale ? Colors.blueGrey : Theme.of(context).textTheme.title.color,
                                        decoration: onSale ? TextDecoration.lineThrough : TextDecoration.none,
                                      )),
                                ],
                              ),
                            ]))),
              ],
            ),
          ),
        ]));
  }

  Widget buildProductDetail() {
    return SliverList(
        delegate: SliverChildListDelegate([
          Wrap(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            RaisedButton(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(2.0)),
                              ),
                              padding: EdgeInsets.all(14.0),
                              onPressed: widget.product.stockStatus != 'outofstock'
                                  ? () {
                                addToCart();
                              }
                                  : null,
                              child: addingToCart ? Container(
                                  width: 17,
                                  height: 17,
                                  child: CircularProgressIndicator(
                                      valueColor: new AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                      strokeWidth: 2.0)) : Text(widget.appStateModel.blocks.localeText.
                                  addToCart),
                            ),
                            SizedBox(height: 16.0),
                            widget.product.stockStatus == 'outofstock'
                                ? Container(
                              padding: EdgeInsets.only(bottom: 10.0),
                              child: Center(
                                  child: Text(widget.appStateModel.blocks.localeText.outOfStock,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle
                                          .copyWith(
                                          color: Theme.of(context)
                                              .errorColor))),
                            )
                                : Container(),
                          ])),
                ],
              ),
            ],
          ),
        ]));
  }

  Widget buildLisOfReleatedProducts() {
    String title = widget.appStateModel.blocks.localeText.relatedProducts.toUpperCase();
    return StreamBuilder<ReleatedProductsModel>(
        stream: widget.productDetailBloc.relatedProducts,
        builder: (context, AsyncSnapshot<ReleatedProductsModel> snapshot) {
          if (snapshot.hasData) {
            return buildProductList(snapshot.data.relatedProducts, context, title);
          } else {
            return SliverToBoxAdapter();
          }
        });
  }

  Widget buildLisOfCrossSellProducts() {
    String title = widget.appStateModel.blocks.localeText.justForYou.toUpperCase();
    return StreamBuilder<ReleatedProductsModel>(
        stream: widget.productDetailBloc.relatedProducts,
        builder: (context, AsyncSnapshot<ReleatedProductsModel> snapshot) {
          if (snapshot.hasData) {
            return buildProductList(snapshot.data.crossProducts, context, title);
          } else {
            return SliverToBoxAdapter();
          }
        });
  }

  Widget buildLisOfUpSellProducts() {
    String title = widget.appStateModel.blocks.localeText.youMayAlsoLike.toUpperCase();
    return StreamBuilder<ReleatedProductsModel>(
        stream: widget.productDetailBloc.relatedProducts,
        builder: (context, AsyncSnapshot<ReleatedProductsModel> snapshot) {
          if (snapshot.hasData) {
            return buildProductList(snapshot.data.upsellProducts, context, title);
          } else {
            return SliverToBoxAdapter();
          }
        });
  }

  Widget buildReviews() {
    return StreamBuilder<List<ReviewModel>>(
        stream: widget.productDetailBloc.allReviews,
        builder: (context, AsyncSnapshot<List<ReviewModel>> snapshot) {
          if (snapshot.hasData) {
            return buildReviewsList(snapshot, context);
          } else {
            return SliverToBoxAdapter();
          }
        });
  }


  buildListTile(context, ReviewModel comment) {
    return Container(
      padding: EdgeInsets.fromLTRB(22.0, 16.0, 16.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 20.0,
                backgroundImage: NetworkImage(comment.avatar),
              ),
              SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(comment.author,
                            style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w400)
                          ),
                          /*SmoothStarRating(
                              allowHalfRating: false,
                              starCount: 5,
                              rating: double.parse(comment.rating),
                              size: 20.0,
                              color: Colors.amber,
                              borderColor: Theme.of(context).hintColor,
                              spacing:0.0
                          )*/
                        ],
                      ),
                      Text(timeago.format(comment.date),
                        style: TextStyle(
                              fontSize: 12.0,
                              color: Theme.of(context).textTheme.caption.color)
                      )
                    ]),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Html(data: comment.content),
        ],
      ),
    );
  }


  Widget buildReviewsList(AsyncSnapshot<List<ReviewModel>> snapshot, BuildContext context){
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildListTile(context, snapshot.data[index] ),
              Divider(height: 0.0,),
            ]
        );
      },
          childCount: snapshot.data.length
      ),
    );
  }

  Container buildProductList(List<Product> products, BuildContext context, String title) {
    if(products.length > 0) {
      return Container(
        child: SliverList(
          delegate: SliverChildListDelegate(
            [
              products.length != null
                  ? Container(
                  height: 20,
                  padding: EdgeInsets.symmetric(horizontal: 18.0),
                  child: Text(title,
                      style: Theme.of(context)
                          .textTheme
                          .body2
                          .copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600)))
                  : Container(),
              Container(
                  height: 270,
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 14.0),
                  decoration: new BoxDecoration(
                    //color: Colors.pink,
                  ),
                  child: ListView.builder(
                      padding: EdgeInsets.all(12.0),
                      scrollDirection: Axis.horizontal,
                      itemCount: products.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            padding: EdgeInsets.symmetric(horizontal: 2.0),
                            width: 160,
                            child: ProductItem(
                                product: products[index],
                                onProductClick: onProductClick));
                      })),
            ],
          ),
        ),
      );
    } else {
      return Container(child: SliverToBoxAdapter(),);
    }
  }

  onProductClick(data) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ProductDetail(
        product: data,
      );
    }));
  }

  _buildProductImages(String key) {
    return SliverAppBar(
      floating: false,
      pinned: true,
      snap: false,
      
      actions: <Widget>[
        Container(
          child: IconButton(
              icon: Icon(Icons.share,
                semanticLabel: 'Share',
              ),
              onPressed: () {
                Share.share('check out product ' + widget.product.permalink);
              }),
        ),
        Container(
          child: ScopedModelDescendant<AppStateModel>(
              builder: (context, child, model) {
                return IconButton(
              icon: Icon(
                model.wishListIds.contains(widget.product.id)
                    ? Icons.favorite
                    : Icons.favorite_border,
                semanticLabel: 'WishList',
              ),
              onPressed: () => model.updateWishList(widget.product.id),
          );}),
        ),
        Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.shopping_basket,
                semanticLabel: 'Cart',
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => CartPage(
                      ),
                      fullscreenDialog: true,
                    ));
              },
            ),
            Positioned(
              // draw a red marble
              top: 2,
              right: 2.0,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => CartPage(),
                        fullscreenDialog: true,
                      ));
                },
                child: ScopedModelDescendant<AppStateModel>(builder: (context, child, model) {
                  if (model.count != 0) {
                    return Card(
                        elevation: 0,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        color: Colors.redAccent,
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
                                      backgroundColor: Colors.redAccent),
                                ))));
                  } else
                    return Container();
                }),
              ),
            )
          ],
        ),
      ],
      expandedHeight: expandedAppBarHeight,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: InkWell(
                  onTap: () => null,
                  child: Swiper(
                    //control: new SwiperControl(),
                    //viewportFraction: 0.8,
                    //scale: 0.9,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        splashColor: Theme.of(context).hintColor,
                        onTap: () => null,
                        child: Card(
                          margin: EdgeInsets.all(0.0),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(0.0)),
                          ),
                          elevation: 0.0,
                          clipBehavior: Clip.antiAlias,
                          child: CachedNetworkImage(
                            imageUrl: widget.product.images[index].src,
                            imageBuilder: (context, imageProvider) => Ink.image(
                              child: InkWell(
                                splashColor: Theme.of(context).hintColor,
                                onTap: () {
                                  //null;
                                },
                              ),
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                            placeholder: (context, url) =>
                                Container(color: Colors.black12),
                            errorWidget: (context, url, error) =>
                                Container(color: Colors.black12),
                          ),
                        ),
                      );
                    },
                    itemCount: widget.product.images.length,
                    pagination: new SwiperPagination(),
                    autoplay: true,
                  ),
                ))
          ],
        ),
      ),
    );
  }

  buildProductVariations(VariationOption variationOption) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 10.0),
      sliver: SliverGrid(
        gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 80.0,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 3,
        ),
        delegate: new SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                setState(() {
                  variationOption.selected = variationOption.options[index];
                  widget.product.stockStatus = 'instock';
                });
                if (widget.product.variationOptions
                    .every((option) => option.selected != null)) {
                  var selectedOptions = new List<String>();
                  var matchedOptions = new List<String>();
                  for (var i = 0; i < widget.product.variationOptions.length; i++) {
                    selectedOptions.add(widget.product.variationOptions[i].selected);
                  }
                  for (var i = 0; i < widget.product.availableVariations.length; i++) {
                    matchedOptions = new List<String>();
                    for (var j = 0;
                    j < widget.product.availableVariations[i].option.length;
                    j++) {
                      if (selectedOptions.contains(
                          widget.product.availableVariations[i].option[j].value) || widget.product.availableVariations[i].option[j].value.isEmpty) {
                        matchedOptions.add(
                            widget.product.availableVariations[i].option[j].value);
                      }
                    }
                    if (matchedOptions.length == selectedOptions.length) {
                      setState(() {
                        widget.product.variationId = widget.product
                            .availableVariations[i].variationId
                            .toString();
                        widget.product.regularPrice = widget.product
                            .availableVariations[i].displayPrice.toDouble();
                        widget.product.formattedPrice = widget.product
                            .availableVariations[i].formattedPrice;
                        widget.product.formattedSalesPrice = widget.product
                            .availableVariations[i].formattedSalesPrice;
                        if (widget.product
                            .availableVariations[i].displayRegularPrice !=
                            widget.product.availableVariations[i].displayPrice)
                          widget.product.salePrice = widget.product
                              .availableVariations[i].displayRegularPrice
                              .toDouble();
                        else
                          widget.product.salePrice = null;
                      });
                      if (!widget.product.availableVariations[i].isInStock) {
                        setState(() {
                          widget.product.stockStatus = 'outofstock';
                        });
                      }
                      break;
                    }
                  }
                  if (matchedOptions.length != selectedOptions.length) {
                    setState(() {
                      widget.product.stockStatus = 'outofstock';
                    });
                  }
                }
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:
                  variationOption.selected == variationOption.options[index]
                      ? Theme.of(context).accentColor
                      : Theme.of(context).scaffoldBackgroundColor,
                  border: Border.all(color: Theme.of(context).accentColor, width: 0.4),
                  borderRadius: BorderRadius.all(Radius.circular(
                      1.0) //                 <--- border radius here
                  ),
                ),
                child: Text(
                  variationOption.options[index].toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: variationOption.selected ==
                        variationOption.options[index]
                        ? Theme.of(context).accentTextTheme.title.color
                        : Theme.of(context).textTheme.title.color,
                  ),
                ),
              ),
            );
          },
          childCount: variationOption.options.length,
        ),
      ),
    );
  }

  Widget buildOptionHeader(String name) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            Container(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.title,
                )),
          ],
        ),
      ),
    );
  }

  Widget buildBody() {
    return CustomScrollView(
        controller: _scrollController, slivers: buildSliverList());
  }

  Future _openWhatsApp(String number) async {
    final url = 'https://wa.me/' + number;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget buildProductSortDescriptoion() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 24.0),
        child: Html(data: widget.product.shortDescription, defaultTextStyle: Theme.of(context).textTheme.body1,),
      ),
    );
  }

  Widget buildProductDescriptoion() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 24.0),
        child: Html(data: widget.product.description, defaultTextStyle: Theme.of(context).textTheme.body1,),
      ),
    );
  }

  _buildDBackgroundImage() {
    return SliverAppBar(
      floating: true,
      pinned: true,
      snap: true,
      
      backgroundColor: Colors.black12,
      actions: <Widget>[
        Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.shopping_basket,
                semanticLabel: 'Cart',
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => CartPage(),
                      fullscreenDialog: true,
                    ));
              },
            ),
            Positioned(
              // draw a red marble
              top: 2,
              right: 2.0,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => CartPage(),
                        fullscreenDialog: true,
                      ));
                },
                child: ScopedModelDescendant<AppStateModel>(builder: (context, child, model) {
                      if (model.count != 0) {
                        return Card(
                            elevation: 0,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            color: Colors.redAccent,
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
                                          backgroundColor: Colors.redAccent),
                                    ))));
                      } else
                        return Container();
                    }),
              ),
            )
          ],
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              color: Colors.black12,
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              child: Container(),
            )
          ],
        ),
      ),
      expandedHeight: expandedAppBarHeight,
    );
  }

  _buildDBackgroundCircleIndicator() {
    return SliverList(
        delegate: SliverChildListDelegate([
          Container(
            padding: EdgeInsets.all(60.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        ]));
  }

  getProduct() async {
    Product product = await widget.productDetailBloc.getProduct(widget.product.id);
    if(product.id != null) {
      setState(() {
        widget.product = product;
      });
    }
  }

  Future<void> addToCart() async {
    setState(() {
      addingToCart = true;
    });
    var data = new Map<String, dynamic>();
    data['product_id'] = widget.product.id.toString();
    var doAdd = true;
    if (widget.product.type == 'variable' && widget.product.variationOptions != null) {
      for (var i = 0; i < widget.product.variationOptions.length; i++) {
        if (widget.product.variationOptions[i].selected != null) {
          data['variation[attribute_' +
              widget.product.variationOptions[i].attribute +
              ']'] = widget.product.variationOptions[i].selected;
        } else if (widget.product.variationOptions[i].selected == null &&
            widget.product.variationOptions[i].options.length != 0) {
          doAdd = false;
          break;
        } else if (widget.product.variationOptions[i].selected == null &&
            widget.product.variationOptions[i].options.length == 0) {
          setState(() {
            widget.product.stockStatus = 'outofstock';
          });
          doAdd = false;
          break;
        }
      }
      if (widget.product.variationId != null) {
        data['variation_id'] = widget.product.variationId;
      }
    }
    if (doAdd) {
      await widget.appStateModel.addToCart(data);
    }
    setState(() {
      addingToCart = false;
    });
  }

}