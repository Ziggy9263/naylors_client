import 'package:meta/meta.dart';
import 'package:naylors_client/models/models.dart';

class CartRepository {
  List<CartItem> detail;

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

  Future<List<CartItem>> remove(String tag) async {
    detail.removeWhere((element) => (element.product == int.parse(tag)));
    return detail;
  }
}
