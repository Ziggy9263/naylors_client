import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naylors_client/blocs/blocs.dart';
import 'package:naylors_client/models/models.dart';

class CartBadge extends StatelessWidget {
  const CartBadge({
    Key key,
    @required this.style,
    @required this.onPressed,
  }) : super(key: key);

  final TextStyle style;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    List<CartItem> cart =
        BlocProvider.of<CartBloc>(context).cartRepository.detail;
    int badgeContent = 0;
    bool cartToggle = BlocProvider.of<NavigatorBloc>(context).cartToggle;
    cart.forEach((val) => badgeContent += val.quantity);
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        Material(
          shape: CircleBorder(),
          color: (cartToggle) ? Colors.white : Colors.transparent,
          child: Badge(
            badgeContent: Text(
              badgeContent.toString(),
              style: style.copyWith(
                color: Colors.white,
                fontSize: 11,
              ),
            ),
            showBadge: (badgeContent > 0 && !cartToggle) ? true : false,
            position: BadgePosition.topEnd(top: 2, end: 2),
            child: IconButton(
              onPressed: onPressed,
              icon: Icon(
                Icons.shopping_cart,
                size: 36,
                color: (cartToggle) ? Colors.black54 : Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
