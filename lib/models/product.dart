import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ModifyStep used in (Product|Category|Department)EditEvent in blocs/product_bloc.dart
enum ModifyStep { Initialize, Create, Update, Delete }

class Department extends Equatable {
  final String id;
  final int code;
  final String name;

  Department({@required this.id, @required this.code, @required this.name})
      : assert(id != null && code != null && name != null);

  factory Department.fromJSON(Map<String, dynamic> json) {
    return Department(
      id: json['_id'].toString(),
      code: json['code'],
      name: json['name'].toString(),
    );
  }

  @override
  List<Object> get props => [id, code, name];
}

class Category extends Equatable {
  final String id;
  final int code;
  final String name;
  final Department department;

  Category(
      {@required this.id,
      @required this.code,
      @required this.name,
      @required this.department})
      : assert(
            id != null && code != null && name != null && department != null);

  factory Category.fromJSON(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      code: json['code'],
      name: json['name'],
      department: Department.fromJSON(json['department']),
    );
  }

  @override
  List<Object> get props => [id, code, name, department];
}

class CategoryList {
  List<Category> list;

  CategoryList({this.list});

  factory CategoryList.fromJSON(String j) {
    Map<String, dynamic> json = jsonDecode(j);
    List<dynamic> dynamicList = json['categories'] as List;
    List<Category> categories = List<Category>();
    dynamicList.forEach((f) {
      Category c = Category.fromJSON(f);
      categories.add(c);
    });
    return CategoryList(list: categories);
  }
}

class ProductDetail extends Equatable {
  final String tag;
  final String name;
  final String description;
  final Category category;
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
        category: Category.fromJSON(json['category']),
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

class ProductEditFocus {
  var tag = new FocusNode();
  var name = new FocusNode();
  var description = new FocusNode();
  var price = new FocusNode();
  var taxExempt = new FocusNode();
  var root = new FocusNode();
  var department = new FocusNode();
  var category = new FocusNode();

  ProductEditFocus(
      {tag, name, description, price, taxExempt, root, department, category});

  void dispose() {
    tag.dispose();
    name.dispose();
    description.dispose();
    price.dispose();
    taxExempt.dispose();
    root.dispose();
    department.dispose();
    category.dispose();
  }
}

class ProductEditFields {
  TextEditingController tag;
  TextEditingController name;
  TextEditingController description;
  TextEditingController price;
  bool taxExempt = false;
  bool root = false;
  TextEditingController department;
  TextEditingController category;
  TextEditingController sizeTag;
  TextEditingController sizeSize;
  List<dynamic> sizes;
  int sizeSelected;

  set size(int index) {
    sizeSelected = index;
    sizeTag.value = TextEditingValue(text: sizes[index]['tag']);
    sizeSize.value = TextEditingValue(text: sizes[index]['size']);
  }

  ProductEditFields(
      {tag,
      name,
      description,
      price,
      taxExempt,
      root,
      department,
      category,
      sizes,
      sizeSelected});

  init() {
    this.tag = new TextEditingController();
    this.name = new TextEditingController();
    this.description = new TextEditingController();
    this.price = new TextEditingController();
    this.department = new TextEditingController();
    this.category = new TextEditingController();
    this.sizes = new List<dynamic>();
    this.sizeTag = new TextEditingController();
    this.sizeSize = new TextEditingController();
  }

  dispose() {
    this.tag.dispose();
    this.name.dispose();
    this.description.dispose();
    this.price.dispose();
    this.department.dispose();
    this.category.dispose();
    this.sizeTag.dispose();
    this.sizeSize.dispose();
  }

  set product(ProductDetail product) {
    this.tag.value = TextEditingValue(text: product.tag);
    this.name.value = TextEditingValue(text: product.name);
    this.description.value = TextEditingValue(text: product.description);
    this.price.value = TextEditingValue(text: product.price.toString());
    this.taxExempt = product.taxExempt ?? false;
    this.root = product.root ?? false;
    this.department.value =
        TextEditingValue(text: product.category.department.name);
    this.category.value = TextEditingValue(text: product.category.name);
    this.sizes = product.sizes;
  }
}
