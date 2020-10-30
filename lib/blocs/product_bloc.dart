import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:naylors_client/repositories/repositories.dart';
import 'package:naylors_client/models/models.dart';
import 'package:naylors_client/blocs/blocs.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc({@required this.productRepository})
      : assert(productRepository != null),
        super(ProductInitial());

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is ProductRequested) {
      yield ProductLoadInProgress();
      try {
        final ProductDetail product =
            await productRepository.getProduct(event.tag);
        yield ProductLoadSuccess(product: product);
      } catch (_) {
        yield ProductLoadFailure();
      }
    }
  }
}

class ProductListBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductListBloc({@required this.productRepository})
      : assert(productRepository != null),
        super(ProductListInitial());
  
  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is ProductListRequested) {
      yield ProductListLoadInProgress();
      try {
        final ProductList productList =
            await productRepository.getProducts();
        yield ProductListLoadSuccess(productList: productList);
      } catch (_) {
        yield ProductListLoadFailure();
      }
    }
  }
}
