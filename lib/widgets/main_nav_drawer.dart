import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:naylors_client/blocs/blocs.dart';
import 'package:naylors_client/widgets/widgets.dart';

class MainNavDrawer extends StatelessWidget {
  final NaylorsHomePageState parent;
  const MainNavDrawer({Key key, this.parent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
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
                  child: Text(BlocProvider.of<AuthBloc>(context).email ??
                      "Not Available"),
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.store, color: Colors.blueGrey),
            title: Text('Products'),
            onTap: () {
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
            title: Text('Categories'),
            onTap: () {
              parent.setState(() {
                parent.headerTitle = "Naylor's Online: Categories";
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.credit_card, color: Colors.blueGrey),
            title: Text('Orders'),
            onTap: () {
              BlocProvider.of<NavigatorBloc>(context).add(NavigatorToOrders());
              BlocProvider.of<OrderBloc>(context).add(OrderReset());
              parent.setState(() {
                parent.headerTitle = "Naylor's Online: Your Orders";
              });
              Navigator.pop(context);
            },
          ),
          Divider(
            color: Colors.grey,
            height: 20,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          ListTile(
            leading: Icon(Icons.account_box, color: Colors.blueGrey),
            title: Text('Profile'),
            onTap: () {
              BlocProvider.of<NavigatorBloc>(context).add(NavigatorToProfile());
              parent.setState(() {
                parent.headerTitle = "Naylor's Online: Your Profile";
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.blueGrey),
            title: Text('Logout'),
            onTap: () {
              BlocProvider.of<AuthBloc>(context).add(AuthLogout());
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
    );
  }
}
