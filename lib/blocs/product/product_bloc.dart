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
        case ModifyStep.Initialize:
          try {
            final ProductDetail product =
                await productRepository.getProduct(event.tag);
            yield ProductEditInitial(
                tag: event.tag,
                product: product,
                modifyStep: ModifyStep.Update);
          } catch (_) {
            yield ProductEditInitial(
                tag: event.tag, modifyStep: ModifyStep.Create);
          }
          break;
        case ModifyStep.Create:
          yield ProductEditLoading();
          try {
            final ProductDetail product =
                await productRepository.createProduct(event.product);
            yield ProductEditSuccess(tag: product.tag, step: ModifyStep.Create);
          } catch (_) {
            yield ProductEditFailure(error: '$_');
          }
          break;
        case ModifyStep.Update:
          yield ProductEditLoading();
          try {
            final ProductDetail product =
                await productRepository.updateProduct(event.tag, event.product);
            yield ProductEditSuccess(tag: product.tag, step: ModifyStep.Update);
          } catch (_) {
            yield ProductEditFailure(error: '$_');
          }
          break;
        case ModifyStep.Delete:
          yield ProductEditLoading();
          try {
            final ProductDetail product =
                await productRepository.deleteProduct(event.tag, event.product);
            yield ProductEditSuccess(tag: product.tag, step: ModifyStep.Delete);
          } catch (_) {
            yield ProductEditFailure(error: '$_');
          }
          break;
        default:
          yield ProductEditFailure(error: "Foreign ModifyStep Given");
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
        yield ProductLoadFailure(error: _);
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
        final ProductList productList = (event.category != null)
            ? await productRepository.getProductsByCategory(event.category)
            : await productRepository.getProducts();
        yield ProductListLoadSuccess(
            productList: productList, category: event.category);
      } catch (_) {
        yield ProductListLoadFailure(error: _);
      }
    }
  }
}
