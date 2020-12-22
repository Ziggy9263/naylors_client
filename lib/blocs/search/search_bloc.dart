import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:naylors_client/repositories/repositories.dart';
import 'package:naylors_client/models/models.dart';
import 'package:naylors_client/blocs/blocs.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ProductRepository productRepository;

  SearchBloc({@required this.productRepository})
      : assert(productRepository != null),
        super(SearchInitial());

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchInit) {
      yield SearchInitial();
    }
    if (event is SearchRequested) {
      yield SearchLoadInProgress();
      try {
        final ProductList productList = await productRepository.searchProducts(event.data);
        yield SearchLoadSuccess(productList: productList);
      } catch (_) {
        yield SearchLoadFailure(request: event.data, error: _);
      }
    }
  }
}
