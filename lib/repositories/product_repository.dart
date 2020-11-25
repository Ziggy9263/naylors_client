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

  Future<ProductDetail> getProduct(String tag) async {
    return productApiClient.getProduct(tag);
  }

  Future<ProductList> searchProducts(String query) async {
    return productApiClient.searchProducts(query);
  }
}
