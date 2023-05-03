import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final double width;
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final TextCapitalization textCapitalization;
  final double borderRadius;
  final TextInputType keyboardType;
  final Function onChanged;
  const CustomTextFormField({
    Key? key,
    required this.width,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    required this.textCapitalization,
    required this.borderRadius,
    required this.keyboardType,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      width: widget.width,
      child: TextFormField(
        maxLines: null,
        textCapitalization: widget.textCapitalization,
        controller: widget.controller,
        decoration: InputDecoration(
          prefixIcon: Icon(widget.prefixIcon),
          labelText: widget.labelText,
          hintText: widget.hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        ),
        keyboardType: widget.keyboardType,
        onChanged: (value) {
          widget.onChanged(value);
        },
      ),
    );
  }
}
