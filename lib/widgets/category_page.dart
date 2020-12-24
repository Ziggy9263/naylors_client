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
    return BlocBuilder<DepartmentListBloc, DepartmentState>(
        builder: (context, state) {
      if (state is DepartmentListInitial) {
        BlocProvider.of<DepartmentListBloc>(context)
            .add(DepartmentListRequested());
      }
      if (state is DepartmentListLoadInProgress) {
        return Center(
            child: CircularProgressIndicator(backgroundColor: Colors.white));
      }
      if (state is DepartmentListLoadSuccess) {
        final departmentList = state.departmentList.list;

        return Container(
          height: MediaQuery.of(context).size.height,
          child: RefreshIndicator(
              child: ListView.builder(
                itemCount: departmentList.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  final item = departmentList[index];

                  return ExpansionTile(
                    backgroundColor: Colors.lightBlue[400],
                    title: Text(
                      "${formatCat(item.code)} ${item.name} ",
                      style: style.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    children: [
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: item.categories.list.length,
                        shrinkWrap: true,
                        itemBuilder: (builder, index) {
                          var category = item.categories.list[index];
                          return Card(
                            child: InkWell(
                              onTap: () {
                                BlocProvider.of<NavigatorBloc>(context)
                                    .add(NavigatorToProducts());
                                BlocProvider.of<ProductListBloc>(context).add(
                                    ProductListRequested(
                                        category: category));
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                child: LimitedBox(
                                  maxHeight: 60,
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "${item.code}-${formatCat(category.code)}",
                                        style: style.copyWith(
                                          color: Colors.lightBlue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            category.name,
                                            style: style.copyWith(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  );
                },
              ),
              onRefresh: () async {
                BlocProvider.of<DepartmentListBloc>(context)
                    .add(DepartmentListRequested());
              }),
        );
      }
      if (state is DepartmentListLoadFailure) {
        return Center(
          child: Text('Something went wrong! ${state.error}',
              style: style.copyWith(color: Colors.red)),
        );
      }
      return Center(child: Text('???'));
    });
  }
}
