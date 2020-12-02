import 'package:flutter/material.dart';

class OrderStatusIcon extends StatelessWidget {
  final String status;
  const OrderStatusIcon({
    Key key,
    @required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;

    switch (status) {
      case "Placed":
      case "Edited":
        color = Colors.lightBlue;
        icon = Icons.check;
        break;
      case "Completed":
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case "Cancelled":
      case "Partial Refund":
        color = Colors.grey;
        icon = Icons.cancel;
        break;
      default:
        color = Colors.grey;
        icon = Icons.fiber_manual_record;
        break;
    }

    return Material(
      color: color,
      shape: CircleBorder(),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(
          icon,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
