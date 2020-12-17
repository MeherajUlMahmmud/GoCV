import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final String valueText;
  final Icon iconText;
  final double ratio;
  final double height;
  final int maxLength;
  final bool enabled;

  CustomTextField(
      {this.labelText,
      this.hintText,
      this.valueText,
      this.iconText,
      this.ratio,
      this.height,
      this.enabled,
      this.maxLength});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: height,
      width: (width - 10) / ratio,
      child: Theme(
        child: TextFormField(
          maxLength: maxLength,
          maxLines: null,
          enabled: enabled,
          controller: TextEditingController()..text = valueText,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: iconText,
            labelText: labelText,
            labelStyle: TextStyle(
              color: Colors.grey,
            ),
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
          ),
          keyboardType: TextInputType.text,
        ),
        data: Theme.of(context).copyWith(
          primaryColor: Colors.blueAccent,
        ),
      ),
    );
  }
}
