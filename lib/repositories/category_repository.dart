import 'package:meta/meta.dart';
import 'package:naylors_client/repositories/repositories.dart';
import 'package:naylors_client/models/models.dart';

class CategoryRepository {
  final CategoryApiClient categoryApiClient;

  CategoryRepository({@required this.categoryApiClient})
      : assert(categoryApiClient != null);

  Future<CategoryList> getCategories() async {
    return categoryApiClient.fetchCategories();
  }

  Future<CategoryList> searchCategories(String query) async {
    return categoryApiClient.searchCategories(query);
  }

  Future<Category> getCategory(String id) async {
    return categoryApiClient.getCategory(id);
  }

  Future<Category> createCategory(Category category) async {
    return (category);
  }

  Future<Category> updateCategory(Category category) async {
    return (category);
  }

  Future<Category> deleteCategory(Category category) async {
    return (category);
  }
}
