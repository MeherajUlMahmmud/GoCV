import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final double width;
  bool? autofocus;
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  IconData? suffixIcon;
  final TextCapitalization textCapitalization;
  final double borderRadius;
  final TextInputType keyboardType;
  bool? isObscure;
  Function()? suffixIconOnPressed;
  final Function onChanged;
  String? Function(String?)? validator;

  CustomTextFormField({
    Key? key,
    required this.width,
    this.autofocus,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    required this.textCapitalization,
    required this.borderRadius,
    required this.keyboardType,
    this.isObscure,
    this.suffixIconOnPressed,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      width: widget.width,
      child: TextFormField(
        maxLines: widget.isObscure ?? false ? 1 : null,
        autofocus: widget.autofocus ?? false,
        textCapitalization: widget.textCapitalization,
        controller: widget.controller,
        decoration: InputDecoration(
          prefixIcon: Icon(widget.prefixIcon),
          suffixIcon: widget.suffixIcon != null
              ? IconButton(
                  onPressed: () {
                    widget.suffixIconOnPressed!();
                  },
                  icon: Icon(widget.suffixIcon))
              : const SizedBox.shrink(),
          labelText: widget.labelText,
          hintText: widget.hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        ),
        keyboardType: widget.keyboardType,
        obscureText: widget.isObscure ?? false,
        onChanged: (value) {
          widget.onChanged(value);
        },
        validator: widget.validator,
      ),
    );
  }
}
