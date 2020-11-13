import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:naylors_client/models/models.dart';
import 'package:naylors_client/repositories/repositories.dart';

class CartRepository {
  List<CartItem> detail;
  final ProductRepository productRepository = ProductRepository(
      productApiClient: ProductApiClient(
    httpClient: http.Client(),
  ));

  CartRepository({@required this.detail}) : assert(detail != null);

  Future<List<CartItem>> modify(CartItem i) async {
    bool done = false;
    for (int index = 0; index < detail.length; index++) {
      if (detail[index].product == i.product) {
        detail[index].quantity = detail[index].quantity + i.quantity;
        done = true;
      }
    }
    if (!done) detail.add(i);
    return detail;
  }

  Future<List<CartItem>> populate() async {
    for (int index = 0; index < detail.length; index++) {
      if (detail[index].detail == null) {
        detail[index].detail = await productRepository
            .getProduct(detail[index].product.toString());
      }
    }
    return detail;
  }

  Future<List<CartItem>> remove(String tag) async {
    detail.removeWhere((element) => (element.product == int.parse(tag)));
    return detail;
  }

  Future<List<CartItem>> clear() async {
    detail.clear();
    return detail;
  }
}
