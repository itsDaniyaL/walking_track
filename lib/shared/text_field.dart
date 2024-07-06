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

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  final TextEditingController _controller = TextEditingController();
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _validate() {
    setState(() {
      _errorText = widget.validator?.call(_controller.text);
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
                enabled: widget.disabled ?? false ? false : true,
                controller: _controller,
                focusNode: _focusNode,
                onChanged: (text) {
                  widget.onChanged(text);
                  _validate();
                },
                obscureText: (widget.isPassword ?? false),
                cursorColor: Theme.of(context).primaryColorLight,
                maxLines: widget.maxLines != null ? 4 : 1,
                style: TextStyle(
                    color: _focusNode.hasFocus
                        ? Theme.of(context).primaryColorLight
                        : Colors.black),
                decoration: InputDecoration(
                  prefixIcon: CustomIcon(
                    icon: widget.prefixIcon,
                    iconColor: Colors.black,
                  ),
                  suffixIcon: CustomIcon(
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

//Work on this later
// suffixIcon: Visibility(
//                     visible: _controller.text.isNotEmpty,
//                     child: IconButton(
//                         icon: const Icon(Icons.clear),
//                         onPressed: () => _controller.text = ""),
//                   ),