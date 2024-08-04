import 'package:flutter/material.dart';
import 'icon.dart';

class CustomDropdownTextField extends StatefulWidget {
  final String hintText;
  final IconData? prefixIcon;
  final String Function(String?)? validator;
  final ValueChanged<String> onChanged;
  final List<String> items;

  const CustomDropdownTextField({
    Key? key,
    required this.hintText,
    this.prefixIcon,
    this.validator,
    required this.onChanged,
    required this.items,
  }) : super(key: key);

  @override
  _CustomDropdownTextFieldState createState() =>
      _CustomDropdownTextFieldState();
}

class _CustomDropdownTextFieldState extends State<CustomDropdownTextField> {
  final TextEditingController _controller = TextEditingController();
  String selectedValue = '';

  Future<void> _showCountryPicker(BuildContext context) async {
    TextEditingController searchController = TextEditingController();
    List<String> filteredItems = List.from(widget.items);

    await showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 100, 100),
      items: [
        PopupMenuItem<String>(
          // enabled: false,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        labelText: 'Search for country',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setState(() {
                          filteredItems = widget.items
                              .where((country) => country
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 300.0,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Column(
                        children: filteredItems.map((country) {
                          return ListTile(
                            title: Text(country),
                            onTap: () {
                              Navigator.pop(context, country);
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    ).then((selectedCountry) {
      if (selectedCountry != null) {
        setState(() {
          selectedValue = selectedCountry;
          _controller.text = selectedCountry;
          widget.onChanged(selectedCountry);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCountryPicker(context),
      child: AbsorbPointer(
        child: DropdownTextField(
          hintText: widget.hintText,
          prefixIcon: widget.prefixIcon,
          validator: widget.validator,
          onChanged: widget.onChanged,
          controller: _controller,
        ),
      ),
    );
  }
}

class DropdownTextField extends StatefulWidget {
  const DropdownTextField({
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
    required this.controller,
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
  final TextEditingController controller;

  @override
  State<DropdownTextField> createState() => _DropdownTextFieldState();
}

class _DropdownTextFieldState extends State<DropdownTextField> {
  late FocusNode _focusNode;
  String? _errorText;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _obscureText = widget.isPassword ?? false;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _validate() {
    setState(() {
      _errorText = widget.validator?.call(widget.controller.text);
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
                controller: widget.controller,
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
