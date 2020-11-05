import 'package:flutter/material.dart';

class NothingInCartYet extends StatelessWidget {
  const NothingInCartYet({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white70,
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Center(child: Text('Nothing in your cart yet.')),
      ),
    );
  }
}
