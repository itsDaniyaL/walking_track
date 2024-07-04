import 'package:flutter/material.dart';
import 'package:walking_track/shared/filled_button.dart';
import 'package:walking_track/shared/icon_button.dart';

class BottomSheetContent extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final Color cardColor;

  const BottomSheetContent({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 70.0,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        color: cardColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    CustomIconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.edit_outlined),
                      buttonColor: const Color(0xFFD9D9D9),
                      iconColor: const Color(0xFF263238),
                    ),
                  ]),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              height: 60,
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 13.0,
                  color: Color(0xFF000000),
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                time,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(),
            Center(
              child: CustomFilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                buttonColor: const Color(0xFF76ABAE),
                textColor: const Color(0xFFFFFFFF),
                width: 250,
                borderRadius: BorderRadius.circular(15.0),
                child: const Text("Mark as Completed"),
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
