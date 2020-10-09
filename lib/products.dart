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

  Future<ProductList> getProductList() async {
    return await getProducts();
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
          List<Widget> productListTextWidgets = List<Widget>();
          snapshot.data.list.forEach((v) {
            productListTextWidgets.add(Text(v.name));
          });
          return ListView(
            children: productListTextWidgets,
          );
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        return Center(
          child: Text(snapshot.data.toString()),
        );
      },
    );
  }
}
