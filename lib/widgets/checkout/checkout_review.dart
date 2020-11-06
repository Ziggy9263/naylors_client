import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naylors_client/blocs/blocs.dart';
import 'package:naylors_client/widgets/widgets.dart';
import 'package:naylors_client/models/models.dart';
import 'package:naylors_client/util/util.dart';

class CheckoutReview extends StatelessWidget {
  const CheckoutReview({
    Key key,
    @required this.cart,
    @required this.style,
    @required this.quantityList,
    @required this.parent,
  }) : super(key: key);

  final List<CartItem> cart;
  final TextStyle style;
  final List<TextEditingController> quantityList;
  final CheckoutPageState parent;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      itemCount: cart.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        _deleteItemFromCart() {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            parent.setState(() {
              BlocProvider.of<CartBloc>(context)
                  .add(CartRemove(product: cart[index].product));
            });
          });
        }

        _setQuantity(String value) {
          FocusScope.of(context).unfocus();
          if (value != null) {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              parent.setState(() {
                cart[index].quantity = int.parse(value);
              });
            });
          } else
            return;
        }

        final item = cart[index];
        String size;
        item.detail.sizes.forEach((val) {
          if (val['tag'] == item.product.toString()) size = val['size'];
        });
        return Container(
          decoration: (item.detail.images.isNotEmpty)
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  color: Colors.blue,
                  image: DecorationImage(
                    colorFilter:
                        ColorFilter.mode(Colors.white24, BlendMode.lighten),
                    fit: BoxFit.fitWidth,
                    alignment: FractionalOffset.center,
                    image: AssetImage(item.detail.images[0]),
                  ),
                )
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  color: Colors.blue[100],
                ),
          child: LimitedBox(
            maxHeight: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                /** PRODUCT DETAIL */
                Expanded(
                  child: Container(
                    constraints: BoxConstraints.expand(),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.white70,
                        Colors.white,
                      ]),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              item.detail.name,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: style.copyWith(
                                  fontWeight: FontWeight.w400, fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                            child: SizedBox(
                              width: 40,
                              child: TextField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.all(0),
                                  border: OutlineInputBorder(),
                                ),
                                textAlign: TextAlign.right,
                                style:
                                    style.copyWith(fontWeight: FontWeight.bold),
                                autofocus: false,
                                showCursor: false,
                                controller: quantityList[index],
                                autocorrect: true,
                                onChanged: (_) {
                                  parent.refreshWithFocus();
                                },
                                onSubmitted: _setQuantity,
                                onEditingComplete: parent.refreshQuantities,
                                enableInteractiveSelection: false,
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: false,
                                  signed: false,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 90,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                    text: "\$${format(item.detail.price)}",
                                    style: style.copyWith(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "\/$size",
                                        style: style.copyWith(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  (item.detail.taxExempt)
                                      ? 'Tax Exempt'
                                      : '+Tax',
                                  style: style.copyWith(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12,
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      "\$${(format(item.detail.price * item.quantity))}",
                                      style: style.copyWith(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                /** DELETE ICONBUTTON */
                Container(
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.red[600],
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(6),
                    ),
                    gradient: LinearGradient(
                      colors: <Color>[
                        Colors.red[400],
                        Colors.red[600],
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment(0.8, 0.0),
                      tileMode: TileMode.clamp,
                    ),
                  ),
                  child: SizedBox(
                    height: 70,
                    child: Material(
                      type: MaterialType.transparency,
                      child: IconButton(
                        color: Colors.black54,
                        icon: Icon(
                          Icons.delete,
                          size: 32,
                        ),
                        onPressed: _deleteItemFromCart,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
