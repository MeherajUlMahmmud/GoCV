import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String btnText;
  final onClick;

  Button({this.btnText, this.onClick});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onClick,
      child: Container(
        height: 60.0,
        width: width - 10,
        child: Material(
          borderRadius: BorderRadius.circular(30.0),
          color: Theme.of(context).accentColor,
          child: Center(
            child: Text(
              "$btnText",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
