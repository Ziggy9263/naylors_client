import 'package:meta/meta.dart';
import 'package:naylors_client/repositories/repositories.dart';
import 'package:naylors_client/models/models.dart';

class ProductRepository {
  final ProductApiClient productApiClient;

  ProductRepository({@required this.productApiClient})
      : assert(productApiClient != null);

  Future<ProductList> getProducts() async {
    return productApiClient.fetchProducts();
  }

  Future<ProductList> getProductsByCategory(Category category) async {
    return productApiClient.fetchByCategory(category);
  }

  Future<ProductList> searchProducts(String query) async {
    return productApiClient.searchProducts(query);
  }

  Future<ProductDetail> getProduct(String tag) async {
    return productApiClient.getProduct(tag);
  }

  Future<ProductDetail> createProduct(ProductDetail product) async {
    return productApiClient.createProduct(product);
  }

  Future<ProductDetail> updateProduct(String tag, ProductDetail product) async {
    return productApiClient.updateProduct(tag, product);
  }

  Future<ProductDetail> deleteProduct(String tag, ProductDetail product) async {
    return productApiClient.deleteProduct(tag, product);
  }
}
