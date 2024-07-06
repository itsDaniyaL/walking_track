import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SwitchQuestion extends StatefulWidget {
  const SwitchQuestion({
    super.key,
    required this.question,
    required this.switchState,
    required this.onChanged,
  });

  final String question;
  final bool switchState;
  final ValueChanged<bool> onChanged;
  @override
  State<SwitchQuestion> createState() => _SwitchQuestionState();
}

class _SwitchQuestionState extends State<SwitchQuestion> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.question),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Switch(
              value: widget.switchState,
              onChanged: (bool value) => widget.onChanged(value),
              activeColor: Theme.of(context).primaryColorLight,
            ),
          ),
        ),
      ],
    );
  }
}
