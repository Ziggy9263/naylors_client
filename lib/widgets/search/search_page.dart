import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:naylors_client/blocs/blocs.dart';
import 'package:naylors_client/models/models.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController searchBar = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchBar,
            autofocus: true,
            autocorrect: true,
            decoration: InputDecoration(
              filled: true,
              contentPadding: EdgeInsets.all(12.0),
              fillColor: Colors.white,
            ),
            onSubmitted: (_) => BlocProvider.of<SearchBloc>(context)
                .add(SearchRequested(data: _)),
          ),
        ),
        Expanded(
          child: BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
            if (state is SearchInitial) {
              return Center(
                  child: Text("Search for Products",
                      style: style.copyWith(color: Colors.white)));
            }
            if (state is SearchLoadInProgress) {
              return Center(
                  child:
                      CircularProgressIndicator(backgroundColor: Colors.white));
            }
            if (state is SearchLoadSuccess) {
              ProductList products = state.productList;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: products.list.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0.5,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("${products.list[index].name}",
                              style: style.copyWith(fontSize: 18)),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            if (state is SearchLoadFailure) {
              return Center(
                  child: Text(
                    "Could not find ${state.request}, error: ${state.error}",
                      textAlign: TextAlign.center,
                      style: style.copyWith(fontSize: 14, color: Colors.white)));
            }
            return Center(
                child: CircularProgressIndicator(backgroundColor: Colors.white));
          }),
        ),
      ],
    );
  }
}
