import 'package:meta/meta.dart';
import 'package:naylors_client/repositories/product_api_client.dart';
import 'package:naylors_client/models/product.dart';

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
}
