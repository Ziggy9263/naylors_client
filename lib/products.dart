import 'package:flutter/material.dart';
import 'dart:async';
import 'package:naylors_client/api.dart';

class ProductsBody extends StatefulWidget {
  @override
  _ProductsBodyState createState() => _ProductsBodyState();

  ProductsBody({Key key}) : super(key: key);
}

class _ProductsBodyState extends State<ProductsBody> {
  Future<ProductList> products;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  Future<ProductList> getProductList() async {
    return await getProducts();
  }

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      products = getProductList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProductList>(
      future: products,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data.list.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final item = snapshot.data.list[index];
                return Card(
                  child: InkWell(
                    onTap: () {
                      // Open item detail, TODO: Write item detail screen
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                                    image: AssetImage((item.images.isNotEmpty) ? item.images[0] : 'no-image.png'),
                                  )
                                )
                              )
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(item.name, style: style.copyWith(fontWeight: FontWeight.w500)),
                                  Expanded(
                                    child: Align(
                                      alignment: FractionalOffset.centerLeft,
                                      child: Container(
                                        padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[400],
                                          borderRadius: BorderRadius.circular(15.0),
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
                                ]
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text("\$${format(item.price)}",
                                  style: style.copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 32,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                                  child: Text(
                                    (item.taxExempt) ? '' : '+Tax',
                                    style: style.copyWith(
                                      fontWeight: FontWeight.w200,
                                      fontSize: 12,
                                    )
                                  ),
                                ),
                              ]
                            ),
                          ]
                        )
                      ),
                    ),
                  ),
                );
              });
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        return Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 15.0),
            Text('Loading Products...'),
          ],
        ));
      },
    );
  }
}
