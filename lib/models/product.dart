import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naylors_client/util/util.dart';

/// ModifyStep used in (Product|Category|Department)EditEvent in blocs/product_bloc.dart
enum ModifyStep { Initialize, Create, Update, Delete }

class Category extends Equatable {
  final String id;
  final int code;
  final String name;

  Category({@required this.id, @required this.code, @required this.name})
      : assert(id != null && code != null && name != null);

  factory Category.fromJSON(Map<String, dynamic> json) {
    return Category(id: json['_id'], code: json['code'], name: json['name']);
  }

  factory Category.empty() {
    return Category(id: '', code: 0, name: '');
  }

  factory Category.idOnly(String id) {
    return Category(id: id, code: 0, name: '');
  }

  @override
  String toString() {
    return 'Category: {id: $id, code: $code, name: \"$name\" }';
  }

  String catToJSONString() {
    return '{id: $id, code: $code, name: \"$name\" }';
  }

  @override
  List<Object> get props => [id, code, name];
}

class CategoryList {
  List<Category> list;

  CategoryList({this.list});

  factory CategoryList.fromJSON(Map<String, dynamic> json) {
    List<dynamic> dynamicList = json as List;
    List<Category> categories = List<Category>.empty(growable: true);
    dynamicList.forEach((f) => {categories.add(Category.fromJSON(f))});
    return CategoryList(list: categories);
  }

  factory CategoryList.empty() {
    return CategoryList(list: new List<Category>.empty(growable: true));
  }

  factory CategoryList.fromList(List<dynamic> list) {
    List<Category> categories = List<Category>.empty(growable: true);
    list.forEach((f) {
      Category c = Category.fromJSON(f);
      categories.add(c);
    });
    return CategoryList(list: categories);
  }

  factory CategoryList.fromString(String j) {
    Map<String, dynamic> json = jsonDecode(j);
    List<dynamic> dynamicList = json['categories'] as List;
    List<Category> categories = List<Category>.empty(growable: true);
    dynamicList.forEach((f) {
      Category c = Category.fromJSON(f);
      categories.add(c);
    });
    return CategoryList(list: categories);
  }
}

class Department extends Equatable {
  final String id;
  final int code;
  final String name;
  final CategoryList categories;

  Department(
      {@required this.id,
      @required this.code,
      @required this.name,
      @required this.categories})
      : assert(
            id != null && code != null && name != null && categories != null);

  factory Department.fromJSON(Map<String, dynamic> json) {
    return Department(
        id: json['_id'].toString(),
        code: json['code'],
        name: json['name'].toString(),
        categories: CategoryList.fromList(json['categories']));
  }

  factory Department.empty() {
    return Department(
        id: '', code: 0, name: '', categories: new CategoryList.empty());
  }

  @override
  String toString() {
    return 'Department: {id: $id, code: $code, name: \"$name\", categories: [${categories.list.length}] }';
  }

  String deptToJSONString() {
    return '{id: $id, code: $code, name: \"$name\", categories: [${categories.list.length}] }';
  }

  @override
  List<Object> get props => [id, code, name, categories];
}

class DepartmentList {
  List<Department> list;

  DepartmentList({this.list});

  factory DepartmentList.fromJSON(String j) {
    Map<String, dynamic> json = jsonDecode(j);
    List<dynamic> dynamicList = json['departments'] as List;
    List<Department> departments = List<Department>.empty(growable: true);
    dynamicList.forEach((f) {
      Department c = Department.fromJSON(f);
      departments.add(c);
    });
    return DepartmentList(list: departments);
  }
}

class ProductDetail extends Equatable {
  final String tag;
  final String name;
  final String description;
  final Department department;
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
      this.department,
      this.category,
      this.price,
      this.images,
      this.sizes,
      this.taxExempt,
      this.root});

  @override
  List<Object> get props => [
        tag,
        name,
        description,
        department,
        category,
        price,
        images,
        sizes,
        taxExempt,
        root
      ];

  factory ProductDetail.fromJSON(Map<String, dynamic> json) {
    return ProductDetail(
        tag: json['tag'].toString(),
        name: json['name'] as String,
        description: json['description'] as String,
        category: (json['category'] != null &&
                json['category'] is Map<String, dynamic>)
            ? Category.fromJSON(json['category'])
            : (json['category'] is String)
                ? Category.idOnly(json['category'])
                : Category.empty(),
        price: json['price'].toDouble(),
        images: json['images'],
        sizes: json['sizes'],
        taxExempt: json['taxExempt'] as bool,
        root: json['root'] as bool);
  }

  String toJSON() {
    Map<String, dynamic> mapped = {
      "tag": this.tag,
      "name": this.name,
      "description": this.description,
      "category": this.category.id,
      "price": this.price,
      "images": this.images.toList() ?? null,
      "sizes": this.sizes.toList() ?? null,
      "taxExempt": this.taxExempt,
      "root": this.root,
    };
    String json = jsonEncode(mapped);
    return json;
  }

  @override
  String toString() {
    return "{tag: ${this.tag}, name: \"${this.name}\", description: \"${this.description}\", price: ${this.price}, taxExempt: ${this.taxExempt}, root: ${this.root}, department: ${this.department.deptToJSONString()}, category: ${this.category.catToJSONString()}, sizes: ${this.sizes.toString()} }";
  }
}

class ProductList {
  List<ProductDetail> list;

  ProductList({this.list});

  factory ProductList.fromJSON(String j) {
    Map<String, dynamic> json = jsonDecode(j);
    List<dynamic> dynamicList = json['products'] as List;
    List<ProductDetail> products = List<ProductDetail>.empty(growable: true);
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
  Department department;
  Category category;
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
    this.price = new TextEditingController(text: "0.00");
    this.department = new Department.empty();
    this.category = new Category.empty();
    this.sizes = new List<dynamic>.empty(growable: true);
    this.sizeTag = new TextEditingController();
    this.sizeSize = new TextEditingController();
  }

  dispose() {
    this.tag.dispose();
    this.name.dispose();
    this.description.dispose();
    this.price.dispose();
    this.sizeTag.dispose();
    this.sizeSize.dispose();
  }

  ProductDetail get product {
    ProductDetail product = new ProductDetail(
        tag: this.tag.text,
        name: this.name.text,
        description: this.description.text,
        price: double.parse(this.price.text.substring(1)),
        taxExempt: this.taxExempt,
        root: this.root,
        images: new List<dynamic>.empty(growable: true),
        department: this.department,
        category: this.category,
        sizes: this.sizes);
    return product;
  }

  set product(ProductDetail product) {
    if (product == null) {
      this.tag.value = TextEditingValue(text: '');
      this.name.value = TextEditingValue(text: '');
      this.description.value = TextEditingValue(text: '');
      this.price.value = TextEditingValue(text: '\$${format(0.0)}');
      this.taxExempt = true;
      this.root = true;
      this.department = new Department.empty();
      this.category = new Category.empty();
      this.sizes = new List<dynamic>.empty(growable: true);
    } else {
      this.tag.value = TextEditingValue(text: product.tag);
      this.name.value = TextEditingValue(text: product.name);
      this.description.value = TextEditingValue(text: product.description);
      this.price.value = TextEditingValue(text: '\$${format(product.price)}');
      this.taxExempt = product.taxExempt ?? true;
      this.root = product.root ?? true;
      this.department = product.department;
      this.category = product.category;
      this.sizes = product.sizes;
    }
  }

  set tagless(ProductDetail product) {
    this.name.value = TextEditingValue(text: product.name);
    this.description.value = TextEditingValue(text: product.description);
    this.price.value = TextEditingValue(text: '\$${format(product.price)}');
    this.taxExempt = product.taxExempt ?? false;
    this.root = product.root ?? false;
    this.department = product.department;
    this.category = product.category;
    this.sizes = product.sizes;
  }

  @override
  String toString() {
    return 'Fields: {tag: ${tag.text}, name: \"${name.text}\", description: \"${description.text}\", price: ${price.text}, taxExempt: $taxExempt, root: $root, department: ${department.toString()}, category: ${category.toString()}, sizes: $sizes }';
  }
}
