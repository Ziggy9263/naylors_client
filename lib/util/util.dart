export 'format.dart';
export 'card_utils.dart';
export 'currency.dart';

import 'package:naylors_client/models/models.dart';

double getSubtotal(List<CartItem> cart) {
  double subtotal = 0;
  for (int i = 0; i < cart.length; i++) {
    subtotal = subtotal + (cart[i].quantity * cart[i].detail.price);
  }
  return subtotal;
}

double getTax(List<CartItem> cart) {
  double tax = 0;
  for (int i = 0; i < cart.length; i++) {
    double subtotal = (cart[i].quantity * cart[i].detail.price);
    tax = (tax + (!cart[i].detail.taxExempt == false ? subtotal * 0.0825 : 0));
  }
  return tax;
}

double getTotal(List<CartItem> cart) {
  double total = getSubtotal(cart) + getTax(cart);
  return total;
}
