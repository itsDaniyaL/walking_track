import 'icon.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    this.isPassword,
    this.isVisible,
    this.disabled,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
    this.padding,
    this.maxLines,
    required this.onChanged,
    this.validator,
    this.maxLength,
    this.initialValue,
  });

  final String hintText;
  final bool? isPassword;
  final bool? isVisible;
  final bool? disabled;
  final double? width;
  final double? padding;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool? maxLines;
  final ValueChanged<String> onChanged;
  final String? Function(String?)? validator;
  final int? maxLength;
  final String? initialValue;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  late TextEditingController _controller;
  String? _errorText;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _obscureText = widget.isPassword ?? false;
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _validate() {
    setState(() {
      _errorText = widget.validator?.call(_controller.text);
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      child: Column(
        children: [
          SizedBox(
            child: SizedBox(
              width: (widget.width ?? 300.0),
              child: TextField(
                maxLength: widget.maxLength,
                enabled: widget.disabled ?? false ? false : true,
                controller: _controller,
                focusNode: _focusNode,
                onChanged: (text) {
                  widget.onChanged(text);
                  _validate();
                },
                obscureText: widget.isPassword == true ? _obscureText : false,
                cursorColor: Theme.of(context).primaryColorLight,
                maxLines: widget.maxLines != null ? 4 : 1,
                style: TextStyle(
                  color: _focusNode.hasFocus
                      ? Theme.of(context).primaryColorLight
                      : Colors.black,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  prefixIcon: CustomIcon(
                    icon: widget.prefixIcon,
                    iconColor: Colors.black,
                  ),
                  suffixIcon: widget.isPassword == true
                      ? GestureDetector(
                          onTap: _togglePasswordVisibility,
                          child: CustomIcon(
                            icon: _obscureText
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            iconColor: Colors.black,
                          ),
                        )
                      : CustomIcon(
                          icon: widget.suffixIcon,
                          iconColor: Colors.black,
                        ),
                  labelText: widget.hintText,
                  floatingLabelStyle:
                      TextStyle(color: Theme.of(context).primaryColorLight),
                  helperStyle: const TextStyle(color: Colors.red),
                  hintStyle: const TextStyle(color: Colors.black),
                  labelStyle: const TextStyle(color: Colors.black),
                  focusColor: Theme.of(context).primaryColorLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  isDense: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColorLight),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  errorText: _errorText,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
