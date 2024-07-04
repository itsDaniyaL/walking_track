import 'package:flutter/material.dart';

class ToggleButton extends StatefulWidget {
  late String selectedMode;
  final Function(String) onModeChanged;

  ToggleButton({super.key, required this.selectedMode, required this.onModeChanged});

  @override
  ToggleButtonState createState() => ToggleButtonState();
}

const double width = 150.0;
const double height = 40.0;
const double loginAlign = -1;
const double signInAlign = 1;
const Color selectedColor = Colors.white;
const Color normalColor = Color(0xFF31363F);

class ToggleButtonState extends State<ToggleButton> {
  late double xAlign;
  late Color loginColor;
  late Color signInColor;

  @override
  void initState() {
    super.initState();
    xAlign = loginAlign;
    loginColor = selectedColor;
    signInColor = normalColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        color: Color(0xFFEEEEEE),
        borderRadius: BorderRadius.all(
          Radius.circular(50.0),
        ),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: Alignment(xAlign, 0),
            duration: const Duration(milliseconds: 300),
            child: Padding(
              padding: const EdgeInsets.all(1.5),
              child: Container(
                width: width * 0.5,
                height: height,
                decoration: BoxDecoration(
                  color: Theme.of(context).secondaryHeaderColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(50.0),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                xAlign = loginAlign;
                loginColor = selectedColor;
                widget.onModeChanged("sign_in");
                signInColor = normalColor;
              });
            },
            child: Align(
              alignment: const Alignment(-1, 0),
              child: Container(
                width: width * 0.5,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  'Sign In',
                  style: TextStyle(
                      color: loginColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                xAlign = signInAlign;
                signInColor = selectedColor;
                widget.onModeChanged("sign_up");
                loginColor = normalColor;
              });
            },
            child: Align(
              alignment: const Alignment(1, 0),
              child: Container(
                width: width * 0.5,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                      color: signInColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
