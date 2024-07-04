import 'package:flutter/material.dart';

class CustomTimePickerField extends StatefulWidget {
  const CustomTimePickerField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    required this.onChanged,
  });

  final String hintText;
  final IconData? prefixIcon;
  final ValueChanged<TimeOfDay> onChanged;

  @override
  State<CustomTimePickerField> createState() => _CustomTimePickerFieldState();
}

class _CustomTimePickerFieldState extends State<CustomTimePickerField> {
  late FocusNode _focusNode;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != TimeOfDay.now()) {
      setState(() {
        _controller.text = picked.format(context);
      });
      widget.onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          SizedBox(
            child: SizedBox(
              width: 300.0,
              child: TextField(
                readOnly: true,
                controller: _controller,
                focusNode: _focusNode,
                onTap: () => _selectTime(context),
                cursorColor: Theme.of(context).primaryColorLight,
                style: TextStyle(
                    color: _focusNode.hasFocus
                        ? Theme.of(context).primaryColorLight
                        : Colors.white),
                decoration: InputDecoration(
                  prefixIcon: Icon(widget.prefixIcon, color: Colors.white),
                  labelText: widget.hintText,
                  floatingLabelStyle:
                      TextStyle(color: Theme.of(context).primaryColorLight),
                  hintStyle: const TextStyle(color: Colors.white),
                  labelStyle: const TextStyle(color: Colors.white),
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
