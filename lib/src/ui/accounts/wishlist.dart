import '../../functions.dart';
import '../../models/app_state_model.dart';
import './../../blocs/wishlist_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../products/product_detail/product_detail.dart';
import 'package:intl/intl.dart';

class WishList extends StatefulWidget {
  final appStateModel = AppStateModel();
  final wishListBloc = WishListBloc();
  WishList({Key key}) : super(key: key);
  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  int index;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    widget.wishListBloc.getWishList();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.wishListBloc.loadMoreWishList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appStateModel.blocks.localeText.wishlist),
      ),
      body: StreamBuilder(
          stream: widget.wishListBloc.wishList,
          builder: (context, AsyncSnapshot<List<Product>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length == 0) {
                return Center(
                  child: Text(widget.appStateModel.blocks.localeText.noWishlist+'!'),
                );
              } else {
                return CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      buildList(snapshot),
                      buildLoadMore(),
                    ]);
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Widget buildList(AsyncSnapshot<List<Product>> snapshot) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Card(
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.all(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            child: InkWell(
              onTap: () {
                openDetail(snapshot.data, index);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 120,
                    height: 120,
                    child: CachedNetworkImage(
                      imageUrl: snapshot.data[index].images[0].src,
                      imageBuilder: (context, imageProvider) => Container(
                        child: Ink.image(
                          child: InkWell(
                              //  onTap: () {openDetail(snapshot.data, index,);},
                              ),
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                      placeholder: (context, url) => Container(
                        width: 120,
                        height: 120,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      errorWidget: (context, url, error) => Container(color: Colors.black12),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0.0, 0, 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                child: Text(parseHtmlString(snapshot.data[index].name),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15)),
                              ),
                              IconButton(
                                onPressed: () => {
                                  widget.wishListBloc.removeItemFromWishList(
                                      snapshot.data[index].id)
                                },
                                icon: Icon(
                                  Icons.remove_circle_outline,
                                  size: 22,
                                  color: Theme.of(context).hintColor,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 2),
                          Text(parseHtmlString(snapshot.data[index].shortDescription),
                              maxLines: 2,
                              style: TextStyle(
                                  color: Theme.of(context).textTheme.caption.color.withOpacity(0.5),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                  letterSpacing: 0.07)),
                          SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: <Widget>[
                              Text(
                                  (snapshot.data[index].price != null &&
                                          snapshot.data[index].price
                                              != 0)
                                      ? parseHtmlString(snapshot.data[index].formattedPrice)
                                      : '',
                                  style: TextStyle(
                                      //color: Theme.of(context).textTheme.caption.color,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      letterSpacing: -0.24)),
                              SizedBox(width: 8.0),
                              Text(
                                  (snapshot.data[index].formattedSalesPrice != null &&
                                          snapshot
                                              .data[index].salePrice != 0)
                                      ? parseHtmlString(snapshot.data[index].formattedSalesPrice)
                                      : '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Theme.of(context)
                                              .textTheme.caption.color.withOpacity(0.5),
                                          fontSize: 11,
                                          letterSpacing: -0.24)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        childCount: snapshot.data.length,
      ),
    );
  }

  openDetail(List<Product> data, int index) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ProductDetail(product: data[index]);
    }));
  }

  buildLoadMore() {
    return SliverPadding(
        padding: EdgeInsets.all(0.0),
        sliver: SliverList(
            delegate: SliverChildListDelegate([
          Container(
              height: 60,
              child: StreamBuilder(
                  stream: widget.wishListBloc.hasMoreWishlistItems,
                  builder: (context, AsyncSnapshot<bool> snapshot) {
                    return snapshot.hasData && snapshot.data == false
                        ? Center(child: Text(widget.appStateModel.blocks.localeText.noMoreWishlist+'!'))
                        : Center(child: CircularProgressIndicator());
                  }
                  //child: Center(child: CircularProgressIndicator())
                  ))
        ])));
  }
}