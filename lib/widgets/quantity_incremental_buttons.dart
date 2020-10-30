import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuantityIncrementalButtons extends StatelessWidget {
  const QuantityIncrementalButtons(
      {Key key,
      @required this.quantity,
      @required this.style,
      @required this.onDecrement,
      @required this.onIncrement,
      @required this.onSubmitted,
    }) : super(key: key);

  final TextEditingController quantity;
  final TextStyle style;
  final Function onDecrement;
  final Function onIncrement;
  final Function(String) onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 32,
          child: Material(
            borderRadius: BorderRadius.only(
              topLeft: Radius.elliptical(32, 16),
              bottomLeft: Radius.elliptical(32, 16),
            ),
            clipBehavior: Clip.antiAlias,
            type: MaterialType.transparency,
            child: MaterialButton(
              padding: EdgeInsets.zero,
              color: Colors.red,
              disabledColor: Colors.grey,
              child: Icon(Icons.remove_circle, color: Colors.white),
              onPressed: onDecrement,
            ),
          ),
        ),
        SizedBox(
          width: 32,
          child: TextField(
            textAlign: TextAlign.center,
            autofocus: false,
            controller: quantity,
            autocorrect: true,
            onSubmitted: onSubmitted,
            style: style.copyWith(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: EdgeInsets.all(0),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
            keyboardType: TextInputType.numberWithOptions(
              decimal: false,
              signed: false,
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ),
        SizedBox(
          width: 32,
          child: Material(
            borderRadius: BorderRadius.only(
              topRight: Radius.elliptical(32, 16),
              bottomRight: Radius.elliptical(32, 16),
            ),
            type: MaterialType.transparency,
            clipBehavior: Clip.antiAlias,
            child: MaterialButton(
              padding: EdgeInsets.zero,
              color: Colors.green,
              disabledColor: Colors.grey,
              child: Icon(Icons.add_circle, color: Colors.white),
              onPressed: onIncrement,
            ),
          ),
        ),
      ],
    );
  }
}
