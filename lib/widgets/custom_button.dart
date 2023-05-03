import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  IconData? icon;
  bool? isLoading = false;
  bool? isDisabled = false;
  final Function() onPressed;
  CustomButton({
    Key? key,
    required this.text,
    this.icon,
    this.isLoading,
    this.isDisabled,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () => isDisabled != null && isDisabled == true
            ? null
            : isLoading != null && isLoading == true
                ? null
                : onPressed(),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled != null && isDisabled == true
              ? Colors.grey
              : Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: isLoading != null && isLoading == true
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white),
              )
            : SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) Icon(icon, color: Colors.white),
                    SizedBox(width: icon != null ? 10 : 0),
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
