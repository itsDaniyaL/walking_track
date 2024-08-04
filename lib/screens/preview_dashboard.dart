import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walking_track/models/preview_data.dart';
import 'package:walking_track/providers/user_data_provider.dart';
import 'package:walking_track/services/api_service.dart';
import 'package:walking_track/shared/filled_button.dart';
import 'package:walking_track/shared/left_menu.dart';
import 'package:walking_track/shared/right_menu.dart';

class PreviewDashboardPage extends StatefulWidget {
  const PreviewDashboardPage({super.key});

  @override
  State<PreviewDashboardPage> createState() => _PreviewDashboardPageState();
}

class _PreviewDashboardPageState extends State<PreviewDashboardPage> {
  late PreviewData? previewData;
  bool isSixMinuteEnabled = false;

  @override
  void initState() {
    super.initState();
    checkSixMinuteEnabled();
    final userDataProvider =
        Provider.of<UserDataProvider>(context, listen: false);
    setState(() {
      previewData = userDataProvider.previewData;
    });
  }

  Future<void> checkSixMinuteEnabled() async {
    ApiService apiService = ApiService();
    final userDataProvider =
        Provider.of<UserDataProvider>(context, listen: false);
    final username = userDataProvider.phone;
    if (username != null) {
      final response = await apiService.test6MinWalkingData(username);
      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        setState(() {
          isSixMinuteEnabled = jsonResponse['data']['enabled'] ?? false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> previewItems = [
      {
        'title': 'Claudication Time',
        'value': previewData?.claudicationTime ?? 'N/A',
      },
      {
        'title': 'Walk to Rest',
        'value': previewData?.walkToRest ?? 'N/A',
      },
      {
        'title': 'Walk no Rest',
        'value': previewData?.walkNoRest ?? 'N/A',
      },
      {
        'title': 'Time at Rest',
        'value': previewData?.timeAtRest ?? 'N/A',
      },
      {
        'title': 'Actual Walking',
        'value': previewData?.actualWalking ?? 'N/A',
      },
      {
        'title': 'Total Steps',
        'value': previewData?.totalSteps.toString() ?? 'N/A',
      },
    ];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Preview Dashboard',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => showLeftMenu(context, isSixMinuteEnabled),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => showRightMenu(context),
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate((previewItems.length / 2).ceil(), (index) {
              int firstIndex = index * 2;
              int secondIndex = firstIndex + 1;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomFilledButton(
                    onPressed: () {},
                    width: 150,
                    height: 150,
                    buttonColor: const Color(0xFF554EEB),
                    borderRadius: BorderRadius.circular(60),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          previewItems[firstIndex]['value'],
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        const Divider(
                          height: 5,
                          thickness: 2,
                          color: Colors.white,
                        ),
                        Text(
                          previewItems[firstIndex]['title'],
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  if (secondIndex < previewItems.length)
                    CustomFilledButton(
                      onPressed: () {},
                      width: 150,
                      height: 150,
                      buttonColor: const Color(0xFF554EEB),
                      borderRadius: BorderRadius.circular(60),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            previewItems[secondIndex]['value'],
                            style: const TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                          const Divider(
                            height: 5,
                            thickness: 2,
                            color: Colors.white,
                          ),
                          Text(
                            previewItems[secondIndex]['title'],
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  else
                    SizedBox(
                      width: 150,
                      height: 150,
                    ), // This ensures that the layout remains consistent even if there is an odd number of items
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
