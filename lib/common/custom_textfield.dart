import 'package:firstinternshipproject/Constraints/constraints.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class customTextField extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? showLine;
  final TextInputType? keyboardType;
  const customTextField({
    super.key,
    required this.textController,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.showLine = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          offset: const Offset(12, 26),
          blurRadius: 50,
          spreadRadius: 0,
          color: Colors.grey.withOpacity(.1),
        ),
      ]),
      child: TextField(
        cursorColor: Colors.white,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w500,
          decorationThickness: 0,
        ),
        controller: textController,
        onChanged: (value) {
          // Do something with the value
        },
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          filled: true,
          fillColor: primaryColor, // Ensure primaryColor is defined
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white70),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          prefixIcon: showLine == true
              ? Row(
                  mainAxisSize:
                      MainAxisSize.min, // Use min to prevent stretching
                  children: [
                    prefixIcon!, // Your original prefixIcon
                    Container(
                      height: 20, // Adjust the height according to your UI
                      width: 1, // This will be the width of the line
                      color: Colors.white, // Line color
                      margin: const EdgeInsets.only(
                          right: 15), // Space before and after the line
                    ),
                  ],
                )
              : null, // Use prefixIcon here
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
