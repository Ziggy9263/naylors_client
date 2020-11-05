import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naylors_client/models/models.dart';
import 'package:naylors_client/blocs/blocs.dart';

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({
    Key key,
    @required this.product,
    @required this.quantity,
  }) : super(key: key);

  final ProductDetail product;
  final TextEditingController quantity;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
        child: Ink(
          decoration: const ShapeDecoration(
            color: Colors.lightGreen,
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: Icon(Icons.add_shopping_cart),
            color: Colors.white,
            onPressed: () {
              var _p = int.parse(product.tag);
              var _q = int.parse(quantity.text);
              BlocProvider.of<CartBloc>(context)
                  .add(CartModify(product: _p, quantity: _q));
            },
          ),
        ),
      );
    });
  }
}