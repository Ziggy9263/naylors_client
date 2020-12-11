import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

/// ProductModify used in ProductEditEvent in blocs/product_bloc.dart
enum ProductModify { Initialize, Create, Update, Delete }

class ProductDetail extends Equatable {
  final String tag;
  final String name;
  final String description;
  final String category;
  final double price;
  final List images;
  final List sizes;
  final bool taxExempt;
  final bool root;

  ProductDetail(
      {this.tag,
      this.name,
      this.description,
      this.category,
      this.price,
      this.images,
      this.sizes,
      this.taxExempt,
      this.root});

  @override
  List<Object> get props =>
      [tag, name, description, category, price, images, sizes, taxExempt, root];

  factory ProductDetail.fromJSON(Map<String, dynamic> json) {
    return ProductDetail(
        tag: json['tag'].toString(),
        name: json['name'] as String,
        description: json['description'] as String,
        category: json['category'] as String,
        price: json['price'].toDouble(),
        images: json['images'],
        sizes: json['sizes'],
        taxExempt: json['taxExempt'] as bool,
        root: json['root'] as bool);
  }
}

class ProductList {
  List<ProductDetail> list;

  ProductList({this.list});

  factory ProductList.fromJSON(String j) {
    Map<String, dynamic> json = jsonDecode(j);
    List<dynamic> dynamicList = json['products'] as List;
    List<ProductDetail> products = List<ProductDetail>();
    dynamicList.forEach((f) {
      ProductDetail p = ProductDetail.fromJSON(f);
      products.add(p);
    });
    return ProductList(list: products);
  }
}
