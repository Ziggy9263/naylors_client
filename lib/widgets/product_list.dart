import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naylors_client/blocs/blocs.dart';
import 'package:naylors_client/widgets/widgets.dart';

class ProductListBody extends StatelessWidget {
  NaylorsHomePageState parent;
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
        return Center(child: CircularProgressIndicator());
      }
      if (state is ProductListLoadSuccess) {
        final productList = state.productList.list;

        return RefreshIndicator(
            child: ListView.builder(
              itemCount: productList.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = productList[index];

                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed('/product', arguments: item)
                          .then((_) {
                        this.parent.setState(() {});
                      });
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: LimitedBox(
                        maxHeight: 64,
                        child: Row(
                          children: <Widget>[
                            AspectRatio(
                                aspectRatio: 487 / 451,
                                child: Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  alignment: FractionalOffset.center,
                                  image: AssetImage((item.images.isNotEmpty)
                                      ? item.images[0]
                                      : 'no-image.png'),
                                )))),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(item.name,
                                      style: style.copyWith(
                                          fontWeight: FontWeight.w500)),
                                  Expanded(
                                    child: Align(
                                      alignment: FractionalOffset.centerLeft,
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(8, 2, 8, 2),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[400],
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: Text(
                                          item.category,
                                          style: style.copyWith(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          softWrap: false,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
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
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            onRefresh: () async {
              BlocProvider.of<ProductListBloc>(context)
                  .add(ProductListRequested());
            });
      }
      if (state is ProductListLoadFailure) {
        return Center(
          child: Text('Something went wrong!',
              style: style.copyWith(color: Colors.red)),
        );
      }
      return Center(child: Text('???'));
    });
  }
}
