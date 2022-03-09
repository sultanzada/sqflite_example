import 'package:flutter/material.dart';

const kInActiveColor = Colors.black54;
const activeCardColor = Color(0x70e1e7e7);

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    @required this.label,
    this.textInputAction,
    this.obscureText = false,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputType,
    this.validator,
    this.onChanged,
  });

  final String label;
  final TextInputAction textInputAction;
  final bool obscureText;
  final TextEditingController controller;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final TextInputType textInputType;
  final Function validator;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 3,
          ),
          child: Text(
            '$label',
            style: TextStyle(
              color: kInActiveColor,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          textInputAction: textInputAction,
          keyboardType: textInputType,
          validator: validator,
          onChanged: onChanged,
          decoration: InputDecoration(
            fillColor: activeCardColor,
            filled: true,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 0.0,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Colors.blue,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
