import 'package:crud/features/home/screens/notifaction/noti_service.dart';

import 'package:flutter/material.dart';

class NotiPage extends StatefulWidget {
  const NotiPage({super.key});

  @override
  State<NotiPage> createState() => _NotiPageState();
}

class _NotiPageState extends State<NotiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            NotiService().showNotification(
              title: "Tittle",
              body: "Body",
            );
          },
          child: const Text("Send Notifications"),
        ),
      ),
    );
  }
}
