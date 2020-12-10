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
    if (event is ProductReset) {
      yield ProductInitial();
    }
    if (event is ProductEditEvent) {
      yield ProductEditLoading();
      switch (event.step) {
        case ProductModify.Initialize:
          try {
            final ProductDetail product =
                await productRepository.getProduct(event.tag);
            yield ProductEditInitial(tag: event.tag, product: product);
          } catch (_) {
            yield ProductEditInitial(tag: event.tag);
          }
          break;
        case ProductModify.Create:
          yield ProductEditLoading();
          try {
            final ProductDetail product =
                await productRepository.createProduct(event.product);
            yield ProductEditSuccess(tag: product.tag);
          } catch (_) {
            yield ProductEditFailure(error: _);
          }
          break;
        case ProductModify.Update:
          yield ProductEditLoading();
          try {
            final ProductDetail product =
                await productRepository.updateProduct(event.product);
            yield ProductEditSuccess(tag: product.tag);
          } catch (_) {
            yield ProductEditFailure(error: _);
          }
          break;
        case ProductModify.Delete:
          yield ProductEditLoading();
          try {
            final ProductDetail product =
                await productRepository.deleteProduct(event.product);
            yield ProductEditSuccess(tag: product.tag);
          } catch (_) {
            yield ProductEditFailure(error: _);
          }
          break;
        default:
          yield ProductEditFailure(error: "Foreign ProductModify Given");
          break;
      }
    }
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
        final ProductList productList = await productRepository.getProducts();
        yield ProductListLoadSuccess(productList: productList);
      } catch (_) {
        yield ProductListLoadFailure();
      }
    }
  }
}
