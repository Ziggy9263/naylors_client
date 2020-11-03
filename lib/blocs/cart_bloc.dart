import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:naylors_client/repositories/repositories.dart';
import 'package:naylors_client/models/models.dart';
import 'package:naylors_client/blocs/blocs.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;

  CartBloc({@required this.cartRepository})
      : assert(cartRepository != null),
        super(CartInitial());

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is CartModify) {
      try {
        final List<CartItem> cartDetail =
            await cartRepository.modify(
              CartItem(product: event.product, quantity: event.quantity));
        yield CartNotEmpty(cart: cartDetail);
      } catch (_) {
        yield CartLoadFailure();
      }
    }
  }
}