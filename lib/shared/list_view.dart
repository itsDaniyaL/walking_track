import 'package:flutter/material.dart';
import 'package:walking_track/shared/filled_button.dart';

class CustomListView extends StatefulWidget {
  final List<String> list;
  final Function(String) onSelect;
  final Color? selectedButtonColor;
  final Color? unselectedButtonColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;

  const CustomListView({
    super.key,
    required this.list,
    required this.onSelect,
    this.selectedButtonColor,
    this.unselectedButtonColor,
    this.selectedTextColor,
    this.unselectedTextColor,
  });

  @override
  CustomListViewState createState() => CustomListViewState();
}

class CustomListViewState extends State<CustomListView> {
  late String selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = "";
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 50,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: widget.list
              .map((item) => Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: CustomFilledButton(
                      onPressed: () {
                        setState(() {
                          selectedOption = item;
                        });
                        widget.onSelect(item);
                      },
                      buttonColor: selectedOption == item
                          ? (widget.selectedButtonColor ??
                              Theme.of(context).primaryColorLight)
                          : (widget.unselectedButtonColor ??
                              Theme.of(context).secondaryHeaderColor),
                      textColor: selectedOption == item
                          ? (widget.selectedTextColor ??
                              Theme.of(context).secondaryHeaderColor)
                          : (widget.unselectedTextColor ??
                              Theme.of(context).primaryColorLight),
                      child: Text(item,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16)),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
