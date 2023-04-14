import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    Key? key,
    required this.labelText,
    required this.prefixIcon,
    required this.obscureText,
    required this.onSaved,
    required this.validator,
  }) : super(key: key);

  final bool obscureText;
  final String labelText;
  final Icon prefixIcon;
  final FormFieldSetter onSaved;
  final FormFieldValidator validator;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool isVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    isVisible = !widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: TextFormField(
        obscureText: !isVisible,
        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.obscureText
              ? IconButton(
            onPressed: () {
              setState(() {
                isVisible = !isVisible;
              });
            },
            icon: isVisible
                ? Icon(Icons.visibility_off)
                : Icon(Icons.visibility),
          )
              : null,
          labelText: widget.labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onSaved: widget.onSaved,
        validator: widget.validator,
      ),
    );
  }
}
