import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naylors_client/models/models.dart';
import 'package:naylors_client/blocs/blocs.dart';
import 'package:naylors_client/widgets/widgets.dart';

class DepartmentCategoryDropdowns extends StatefulWidget {
  final ProductEditState parent;
  final ProductEditFields fields;
  final ProductEditFocus focus;
  final TextStyle style;

  const DepartmentCategoryDropdowns({
    @required this.parent,
    @required this.fields,
    @required this.focus,
    @required this.style,
  }) : assert(
            parent != null && fields != null && focus != null && style != null);

  @override
  _DepartmentCategoryDropdownsState createState() =>
      _DepartmentCategoryDropdownsState(
          parent: parent, fields: fields, focus: focus, style: style);
}

class _DepartmentCategoryDropdownsState
    extends State<DepartmentCategoryDropdowns> {
  _DepartmentCategoryDropdownsState({
    @required this.parent,
    @required this.fields,
    @required this.focus,
    @required this.style,
  }) : assert(
            parent != null && fields != null && focus != null && style != null);

  final ProductEditState parent;
  final ProductEditFields fields;
  final ProductEditFocus focus;
  final TextStyle style;
  int departmentSelectionIndex = 0;
  int categorySelectionIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DepartmentListBloc, DepartmentState>(
        builder: (context, state) {
      List<Department> departments;
      if (state is DepartmentListInitial) {
        BlocProvider.of<DepartmentListBloc>(context)
            .add(DepartmentListRequested());
      }
      if (state is DepartmentListLoadInProgress) {
        return Center(
            child: CircularProgressIndicator(backgroundColor: Colors.white));
      }
      if (state is DepartmentListLoadSuccess) {
        departments = state.departmentList.list;
        if (fields.department == null && fields.category != null)
          for (int i = 0; i < departments.length; i++) {
            if (departments[i].categories.list.indexOf(fields.category) != -1)
              fields.department = departments[i];
          }
        if (fields.department.id == '' && fields.category.id == '') {
          fields.department = departments[0];
          fields.category = departments[0].categories.list[0];
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: DropdownButton(
                isExpanded: true,
                value: departments[departmentSelectionIndex],
                items: departments.map<DropdownMenuItem<dynamic>>((item) {
                  return DropdownMenuItem<dynamic>(
                    value: item,
                    child: Text('${item.code} - ${item.name}',
                        style: style, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (value) {
                  SchedulerBinding.instance.addPostFrameCallback((t) {
                    parent.setState(() {
                      departmentSelectionIndex = departments.indexOf(value);
                      fields.department = value;
                      fields.category = departments[departmentSelectionIndex]
                          .categories
                          .list[0];
                      categorySelectionIndex = 0;
                    });
                  });
                },
              ),
            ),
            SizedBox(width: 4.0),
            Expanded(
              child: DropdownButton(
                isExpanded: true,
                value: departments[departmentSelectionIndex]
                    .categories
                    .list[categorySelectionIndex],
                items: departments[departmentSelectionIndex]
                    .categories
                    .list
                    .map<DropdownMenuItem<dynamic>>((item) {
                  return DropdownMenuItem<dynamic>(
                    value: item,
                    child: Text('${item.code} - ${item.name}',
                        style: style, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (value) {
                  SchedulerBinding.instance.addPostFrameCallback((t) {
                    parent.setState(() {
                      categorySelectionIndex =
                          departments[departmentSelectionIndex]
                              .categories
                              .list
                              .indexOf(value);
                      fields.category = value;
                    });
                  });
                },
              ),
            ),
          ],
        );
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          CircularProgressIndicator(backgroundColor: Colors.lightBlue),
        ],
      );
    });
  }
}
