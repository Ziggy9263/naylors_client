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
      yield CartModificationInProgress();
      try {
        await cartRepository
            .modify(CartItem(product: event.product, quantity: event.quantity));
        final List<CartItem> cartDetail = await cartRepository.populate();
        if (cartDetail.isNotEmpty) yield CartNotEmpty(cart: cartDetail);
        if (cartDetail.isEmpty) yield CartEmpty();
      } catch (_) {
        yield CartLoadFailure();
      }
    }
    if (event is CartRemove) {
      yield CartModificationInProgress();
      try {
        await cartRepository.remove(event.product.toString());
        final List<CartItem> cartDetail = await cartRepository.populate();
        if (cartDetail.isNotEmpty) yield CartNotEmpty(cart: cartDetail);
        if (cartDetail.isEmpty) yield CartEmpty();
          
      } catch (_) {
        yield CartLoadFailure();
      }
    }
    if (event is CartRequested) {
      try {
        final List<CartItem> cartDetail = await cartRepository.populate();
        if (cartDetail.isNotEmpty) yield CartNotEmpty(cart: cartDetail);
        if (cartDetail.isEmpty) yield CartEmpty();
      } catch (_) {
        yield CartLoadFailure();
      }
    }
  }
}
