import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/features/home/screens/Riverpod_files/api_service.dart';
import 'package:crud/features/home/screens/Riverpod_files/api_usermodel.dart';
import 'package:crud/features/home/screens/Riverpod_files/counter_demo.dart';
import 'package:crud/features/home/screens/Riverpod_files/riverpod_api.dart';
import 'package:crud/features/home/screens/Riverpod_files/state_noti.dart';
import 'package:crud/features/home/screens/Riverpod_files/stfl_riverpod.dart';
import 'package:crud/features/home/screens/Riverpod_files/stream_provider.dart';
import 'package:crud/features/home/screens/notifaction/noti_service.dart';
import 'package:crud/features/home/screens/Riverpod_files/riverpod_test.dart';
import 'package:crud/features/home/screens/splashscreen.dart';
import 'package:crud/firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'features/home/screens/Riverpod_files/state_provider.dart';

var height;
var width;
String? currentUserName;

final nameProvider = Provider(
  (ref) {
    return "Hello Jamheed";
  },
);

final counterProvider = StateProvider<int>(
  (ref) => 0,
);

final countProvider = StateNotifierProvider<CounterDemo, int>(
  (ref) => CounterDemo(),
);

final apiProvider = Provider<ApiService>(
  (ref) => ApiService(),
);

final userDataProvider = FutureProvider<List<UserModelApi>>(
  (ref) {
    return ref.read(apiProvider).getUser();
  },
);

final streamProvider = StreamProvider<int>(((ref) {
  return Stream.periodic(
      const Duration(seconds: 1), ((computationCount) => computationCount));
}));
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notifications
  NotiService().initNotification();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Activate Firebase App Check (Optional: Can be disabled for testing)
    await FirebaseAppCheck.instance.activate();

    runApp(ProviderScope(child: MyApp()));
  } catch (e) {
    print("🔥 Firebase Initialization Error: $e");
  }
}

class MyApp extends StatelessWidget {
  var auth = FirebaseAuth.instance;

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;

        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: MaterialApp(
            theme: ThemeData(
              textTheme: GoogleFonts.poppinsTextTheme(),
            ),
            debugShowCheckedModeBanner: false,
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}
