import 'package:flutter/material.dart';
import 'package:walking_track/shared/filled_button.dart';

class BackNavigations extends StatelessWidget {
  const BackNavigations({
    super.key,
    this.pageTitle,
  });

  final String? pageTitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          Visibility(
            visible: Navigator.canPop(context),
            child: Align(
              alignment: Alignment.centerLeft,
              child: CustomFilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                buttonColor: Theme.of(context).primaryColorLight,
                textColor: Theme.of(context).secondaryHeaderColor,
                width: 60,
                height: 50,
                child: const Icon(Icons.arrow_back_ios),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
