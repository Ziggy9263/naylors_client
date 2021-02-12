import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naylors_client/blocs/blocs.dart';
import 'package:naylors_client/widgets/widgets.dart';

class ProductListBody extends StatelessWidget {
  final NaylorsHomePageState parent;
  ProductListBody(this.parent);
  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 2 : 2);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductListBloc, ProductState>(
        builder: (context, state) {
      if (state is ProductListInitial) {
        BlocProvider.of<ProductListBloc>(context).add(ProductListRequested());
      }
      if (state is ProductListLoadInProgress) {
        return Center(
            child: CircularProgressIndicator(backgroundColor: Colors.white));
      }
      if (state is ProductListLoadSuccess) {
        final productList = state.productList.list;
        final category = state.category;
        if (productList.length == 0)
          return RefreshIndicator(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Whoops!",
                        style: style.copyWith(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      "Looks like the server sent back 0 products.",
                      style: style.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    RaisedButton(
                        color: Colors.lightBlue[50],
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.refresh,
                              color: Colors.lightBlue,
                              size: 40.0,
                            ),
                            Text(
                              "Try Again",
                              style: style.copyWith(
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () async {
                          BlocProvider.of<ProductListBloc>(context)
                              .add(ProductListRequested());
                        }),
                  ],
                ),
              ),
              onRefresh: () async {
                BlocProvider.of<ProductListBloc>(context)
                    .add(ProductListRequested());
              });

        return RefreshIndicator(
            child: Column(
              children: [
                (category != null)
                    ? Material(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.elliptical(32, 16),
                          topRight: Radius.elliptical(32, 16),
                        ),
                        clipBehavior: Clip.antiAlias,
                        type: MaterialType.transparency,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.lightBlue[600],
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          alignment: Alignment.center,
                          child: Text(
                              "${productList.length} Product${(productList.length > 1) ? 's' : ''} in ${category.name}",
                              style: style.copyWith(color: Colors.white)),
                        ),
                      )
                    : Container(),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.lightBlue[600],
                  ),
                  child: ListView.builder(
                    itemCount: productList.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final item = productList[index];
                      var priceChildren = <Widget>[
                        Text(
                          "\$${format(item.price)}",
                          style: style.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: Text((item.taxExempt) ? '' : '+Tax',
                              style: style.copyWith(
                                fontWeight: FontWeight.w200,
                                fontSize: 12,
                              )),
                        ),
                      ];

                      return Card(
                        child: InkWell(
                          onTap: () {
                            BlocProvider.of<NavigatorBloc>(context).add(
                                NavigatorToProduct(
                                    product: int.parse(item.tag)));
                            BlocProvider.of<ProductBloc>(context)
                                .add(ProductReset());
                            // ignore: invalid_use_of_protected_member
                            this.parent.setState(() {});
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            child: LimitedBox(
                              maxHeight: category == null ? 48 : 48,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    /*child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[*/
                                    child: Text(item.name,
                                        style: style.copyWith(
                                            fontWeight: FontWeight.w500)),
                                    /*category == null
                                            ? Expanded(
                                                child: Align(
                                                  alignment: FractionalOffset
                                                      .centerLeft,
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            8, 2, 8, 2),
                                                    decoration: BoxDecoration(
                                                      color: Colors.blue[400],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                    child: Text(
                                                      "> ${item.category.name}",
                                                      style: style.copyWith(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      softWrap: false,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(),*/
                                    //],
                                    //),
                                  ),
                                  category == null
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: priceChildren,
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: priceChildren,
                                        ),
                                  BlocProvider.of<AuthBloc>(context).isAdmin
                                      ? IconButton(
                                          icon: Icon(Icons.edit),
                                          padding: EdgeInsets.all(2),
                                          onPressed: () {
                                            BlocProvider.of<ProductBloc>(
                                                    context)
                                                .add(ProductReset());
                                            BlocProvider.of<NavigatorBloc>(
                                                    context)
                                                .add(NavigatorToProductEdit(
                                                    product:
                                                        int.parse(item.tag)));
                                            // ignore: invalid_use_of_protected_member
                                            parent.setState(() {
                                              parent.headerTitle =
                                                  "Naylor's Online: Product Edit";
                                            });
                                          })
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                category != null
                    ? Material(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.elliptical(32, 16),
                          bottomRight: Radius.elliptical(32, 16),
                        ),
                        clipBehavior: Clip.antiAlias,
                        type: MaterialType.transparency,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.lightBlue[600],
                          ),
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          child: FlatButton(
                            padding: EdgeInsets.all(8.0),
                            color: Colors.lightBlue[700],
                            child: Text(
                              'Return to Categories',
                              style: style.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {},
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
            onRefresh: () async {
              BlocProvider.of<ProductListBloc>(context)
                  .add(ProductListRequested());
            });
      }
      if (state is ProductListLoadFailure) {
        return Center(
          child: Text('Something went wrong! ${state.error}',
              style: style.copyWith(color: Colors.red)),
        );
      }
      return Center(child: Text('???'));
    });
  }
}
