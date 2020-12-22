import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:naylors_client/repositories/repositories.dart';
import 'package:naylors_client/models/models.dart';
import 'package:naylors_client/blocs/blocs.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;

  CategoryBloc({@required this.categoryRepository})
      : assert(categoryRepository != null),
        super(CategoryInitial());

  @override
  Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
    if (event is CategoryReset) {
      yield CategoryInitial();
    }
    if (event is CategoryEditEvent) {
      yield CategoryEditLoading();
      switch (event.step) {
        case ModifyStep.Initialize:
          try {
            final Category category =
                await categoryRepository.getCategory(event.id);
            yield CategoryEditInitial(id: event.id, category: category);
          } catch (_) {
            yield CategoryEditInitial(id: event.id);
          }
          break;
        case ModifyStep.Create:
          yield CategoryEditLoading();
          try {
            final Category category =
                await categoryRepository.createCategory(event.category);
            yield CategoryEditSuccess(id: category.id);
          } catch (_) {
            yield CategoryEditFailure(error: _);
          }
          break;
        case ModifyStep.Update:
          yield CategoryEditLoading();
          try {
            final Category category =
                await categoryRepository.updateCategory(event.category);
            yield CategoryEditSuccess(id: category.id);
          } catch (_) {
            yield CategoryEditFailure(error: _);
          }
          break;
        case ModifyStep.Delete:
          yield CategoryEditLoading();
          try {
            final Category category =
                await categoryRepository.deleteCategory(event.category);
            yield CategoryEditSuccess(id: category.id);
          } catch (_) {
            yield CategoryEditFailure(error: _);
          }
          break;
        default:
          yield CategoryEditFailure(error: "Foreign ModifyStep Given");
          break;
      }
    }
    if (event is CategoryRequested) {
      yield CategoryLoadInProgress();
      try {
        final Category category =
            await categoryRepository.getCategory(event.id);
        yield CategoryLoadSuccess(category: category);
      } catch (_) {
        yield CategoryLoadFailure();
      }
    }
  }
}

class CategoryListBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;

  CategoryListBloc({@required this.categoryRepository})
      : assert(categoryRepository != null),
        super(CategoryListInitial());

  @override
  Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
    if (event is CategoryListRequested) {
      yield CategoryListLoadInProgress();
      try {
        final CategoryList categoryList = await categoryRepository.getCategories();
        yield CategoryListLoadSuccess(categoryList: categoryList);
      } catch (_) {
        yield CategoryListLoadFailure(error: _);
      }
    }
  }
}
