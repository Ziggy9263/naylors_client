import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:naylors_client/blocs/blocs.dart';
import 'package:naylors_client/models/models.dart';
import 'package:naylors_client/widgets/widgets.dart';

class MainNavDrawer extends StatelessWidget {
  final NaylorsHomePageState parent;
  const MainNavDrawer({Key key, this.parent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('old_naylors.jpg'), fit: BoxFit.cover),
              ),
              child: Align(
                alignment: FractionalOffset.bottomLeft,
                child: Material(
                  elevation: 1.0,
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white70,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5.0, 3.0, 5.0, 3.0),
                    child: Text(
                        BlocProvider.of<AuthBloc>(context).email ??
                            "Not Available",
                        style: parent.style.copyWith(fontSize: 14)),
                  ),
                ),
              ),
            ),
            ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              addRepaintBoundaries: false,
              children: [
                ListTile(
                  leading: Icon(Icons.store, color: Colors.blueGrey),
                  title: Text('Products',
                      style: parent.style.copyWith(fontSize: 16)),
                  onTap: () {
                    BlocProvider.of<ProductBloc>(context).add(ProductReset());
                    BlocProvider.of<ProductListBloc>(context)
                        .add(ProductListRequested());
                    BlocProvider.of<NavigatorBloc>(context)
                        .add(NavigatorToProducts());
                    parent.setState(() {
                      parent.headerTitle = "Naylor's Online: Products";
                    });
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.filter_list, color: Colors.blueGrey),
                  title: Text('Categories',
                      style: parent.style.copyWith(fontSize: 16)),
                  onTap: () {
                    BlocProvider.of<NavigatorBloc>(context)
                        .add(NavigatorToCategories());
                    parent.setState(() {
                      parent.headerTitle = "Naylor's Online: Categories";
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.credit_card, color: Colors.blueGrey),
                  title: Text('Orders',
                      style: parent.style.copyWith(fontSize: 16)),
                  onTap: () {
                    BlocProvider.of<NavigatorBloc>(context)
                        .add(NavigatorToOrders());
                    BlocProvider.of<OrderBloc>(context).add(OrderReset());
                    parent.setState(() {
                      parent.headerTitle = "Naylor's Online: Your Orders";
                    });
                    Navigator.pop(context);
                  },
                ),
                BlocProvider.of<AuthBloc>(context).isAdmin
                    ? Divider(
                        color: Colors.grey,
                        height: 20,
                        thickness: 1,
                        indent: 20,
                        endIndent: 20,
                      )
                    : Container(),
                BlocProvider.of<AuthBloc>(context).isAdmin
                    ? ListTile(
                        dense: true,
                        leading: Icon(Icons.edit, color: Colors.blueGrey[50]),
                        title: Text('Manage Products',
                            style: parent.style
                                .copyWith(fontSize: 16, color: Colors.white)),
                        tileColor: Colors.blueGrey,
                        onTap: () {
                          BlocProvider.of<ProductBloc>(context)
                              .add(ProductReset());
                          BlocProvider.of<ProductBloc>(context).add(
                              ProductEditEvent(
                                  step: ModifyStep.Initialize, tag: null));
                          BlocProvider.of<NavigatorBloc>(context)
                              .add(NavigatorToProductEdit());

                          parent.setState(() {
                            parent.headerTitle =
                                "Naylor's Online: Product Edit";
                          });
                          Navigator.of(context).pop();
                        })
                    : Container(),
                BlocProvider.of<AuthBloc>(context).isAdmin
                    ? ListTile(
                        dense: true,
                        leading: Icon(Icons.edit, color: Colors.blueGrey[50]),
                        title: Text('Manage Categories',
                            style: parent.style
                                .copyWith(fontSize: 16, color: Colors.white)),
                        tileColor: Colors.blueGrey,
                        onTap: () {
                          BlocProvider.of<NavigatorBloc>(context)
                              .add(NavigatorToProductEdit());
                          parent.setState(() {
                            parent.headerTitle =
                                "Naylor's Online: Category Edit";
                          });
                          Navigator.of(context).pop();
                        })
                    : Container(),
                BlocProvider.of<AuthBloc>(context).isAdmin
                    ? ListTile(
                        dense: true,
                        leading: Icon(Icons.edit, color: Colors.blueGrey[50]),
                        title: Text('Manage Orders',
                            style: parent.style
                                .copyWith(fontSize: 16, color: Colors.white)),
                        tileColor: Colors.blueGrey,
                        onTap: () {
                          BlocProvider.of<NavigatorBloc>(context)
                              .add(NavigatorToProductEdit());
                          parent.setState(() {
                            parent.headerTitle =
                                "Naylor's Online: Manage Orders";
                          });
                          Navigator.of(context).pop();
                        })
                    : Container(),
                BlocProvider.of<AuthBloc>(context).isAdmin
                    ? ListTile(
                        dense: true,
                        leading: Icon(Icons.edit, color: Colors.blueGrey[50]),
                        title: Text('Manage Users',
                            style: parent.style
                                .copyWith(fontSize: 16, color: Colors.white)),
                        tileColor: Colors.blueGrey,
                        onTap: () {
                          BlocProvider.of<NavigatorBloc>(context)
                              .add(NavigatorToProductEdit());
                          parent.setState(() {
                            parent.headerTitle =
                                "Naylor's Online: Manage Users";
                          });
                          Navigator.of(context).pop();
                        })
                    : Container(),
                /*BlocProvider.of<AuthBloc>(context).isAdmin
                ? ListTile(
                    leading: Icon(Icons.edit, color: Colors.blueGrey[50]),
                    title: Text('Debugging Tools',
                        style: parent.style
                            .copyWith(fontSize: 16, color: Colors.white)),
                    tileColor: Colors.blueGrey,
                    onTap: () {
                      BlocProvider.of<NavigatorBloc>(context)
                          .add(NavigatorToDebug());
                      parent.setState(() {
                        parent.headerTitle = "Naylor's Online: Debugging Tools";
                      });
                      Navigator.of(context).pop();
                    })
                : Container(),*/
                Divider(
                  color: Colors.grey,
                  height: 20,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                ListTile(
                  dense: true,
                  leading: Icon(Icons.account_box, color: Colors.blueGrey),
                  title: Text('Profile',
                      style: parent.style.copyWith(fontSize: 16)),
                  onTap: () {
                    BlocProvider.of<NavigatorBloc>(context)
                        .add(NavigatorToProfile());
                    parent.setState(() {
                      parent.headerTitle = "Naylor's Online: Your Profile";
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  dense: true,
                  leading: Icon(Icons.exit_to_app, color: Colors.blueGrey),
                  title: Text('Logout',
                      style: parent.style.copyWith(fontSize: 16)),
                  onTap: () {
                    BlocProvider.of<AuthBloc>(context).add(AuthLogout());
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                ),
              ],
            ),
            Expanded(child: SizedBox()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  height: 60.0,
                  child: Image.asset(
                    "assets/logo.jpg",
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                    colorBlendMode: BlendMode.lighten,
                  ),
                ),
                Text("Naylor's Farm \& Ranch Supply",
                    style: parent.style.copyWith(fontSize: 16)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                  ),
                  child: Text(
                    "Terms of Service",
                    style: parent.style.copyWith(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  onPressed: () {},
                ),
                TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                  ),
                  child: Text(
                    "Privacy Policy",
                    style: parent.style.copyWith(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
