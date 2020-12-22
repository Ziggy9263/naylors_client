import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'package:naylors_client/models/models.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

/// Category (Singular)
class CategoryInitial extends CategoryState {}

class CategoryLoadInProgress extends CategoryState {}

class CategoryLoadSuccess extends CategoryState {
  final Category category;

  const CategoryLoadSuccess({@required this.category}) : assert(category != null);

  @override
  List<Object> get props => [category];
}

class CategoryLoadFailure extends CategoryState {}

/// Category (List)
class CategoryListInitial extends CategoryState {}

class CategoryListLoadInProgress extends CategoryState {}

class CategoryListLoadSuccess extends CategoryState {
  final CategoryList categoryList;

  const CategoryListLoadSuccess({@required this.categoryList})
      : assert(categoryList != null);

  @override
  List<Object> get props => [categoryList];
}

class CategoryListLoadFailure extends CategoryState {
  final dynamic error;
  CategoryListLoadFailure({this.error});

  @override
  List<Object> get props => [error];
}

/// Category (Edit/Create)
class CategoryEditInitial extends CategoryState {
  final String id;
  final Category category;
  const CategoryEditInitial({this.id, this.category});

  @override
  List<Object> get props => [id, category];
}

class CategoryEditSuccess extends CategoryState {
  final String id;
  const CategoryEditSuccess({@required this.id}) : assert(id != null);

  @override
  List<Object> get props => [id];
}

class CategoryEditFailure extends CategoryState {
  final String error;
  const CategoryEditFailure({@required this.error}) : assert(error != null);
}

class CategoryEditLoading extends CategoryState {}
