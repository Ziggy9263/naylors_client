import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naylors_client/blocs/blocs.dart';
import 'package:naylors_client/widgets/widgets.dart';

class CategoryPage extends StatelessWidget {
  final NaylorsHomePageState parent;

  CategoryPage(this.parent);

  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  String formatCat(int n) {
    // Meow
    return n.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryListBloc, CategoryState>(
        builder: (context, state) {
      if (state is CategoryListInitial) {
        BlocProvider.of<CategoryListBloc>(context).add(CategoryListRequested());
      }
      if (state is CategoryListLoadInProgress) {
        return Center(
            child: CircularProgressIndicator(backgroundColor: Colors.white));
      }
      if (state is CategoryListLoadSuccess) {
        final categoryList = state.categoryList.list;

        return RefreshIndicator(
            child: ListView.builder(
              itemCount: categoryList.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = categoryList[index];

                return Card(
                  child: InkWell(
                    onTap: () {
                      /*BlocProvider.of<NavigatorBloc>(context).add(
                          NavigatorToProduct(product: int.parse(item.tag)));
                      BlocProvider.of<ProductBloc>(context).add(ProductReset());
                      this.parent.setState(() {});*/
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: LimitedBox(
                        maxHeight: 60,
                        child: Row(
                          children: <Widget>[
                            Text(
                              "${item.department.name} ${formatCat(item.department.code)}-${formatCat(item.code)}",
                              style: style.copyWith(
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  item.name,
                                  style: style.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            /*Container(
                                padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue[400],
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Text(
                                  "Department: ${item.department.name}",
                                  style: style.copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: false,
                                )),*/
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            onRefresh: () async {
              BlocProvider.of<CategoryListBloc>(context)
                  .add(CategoryListRequested());
            });
      }
      if (state is CategoryListLoadFailure) {
        return Center(
          child: Text('Something went wrong! ${state.error}',
              style: style.copyWith(color: Colors.red)),
        );
      }
      return Center(child: Text('???'));
    });
  }
}
