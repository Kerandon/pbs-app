import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pbs_app/configs/app_theme.dart';
import 'package:pbs_app/home_page.dart';
import 'package:pbs_app/state/database_manager.dart';
import 'package:pbs_app/state/simple_providers.dart';
import 'package:pbs_app/utils/enums/platforms.dart';
import 'app/components/error_page.dart';
import 'app/components/loading_page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'utils/globals.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseOptions? options;

  if (kIsWeb) {
    appPlatform = AppPlatform.web;
    options = const FirebaseOptions(
        apiKey: "AIzaSyCi67qBQTR_E2aaGB-Oxeh4-EozNhkrLBk",
        authDomain: "pbs-app-d73fc.firebaseapp.com",
        projectId: "pbs-app-d73fc",
        storageBucket: "pbs-app-d73fc.appspot.com",
        messagingSenderId: "815682859282",
        appId: "1:815682859282:web:6c9d266e23a582fdc4c3cb",
        measurementId: "G-WF2D389QEV");
  }

  await Firebase.initializeApp(options: options);

  runApp(
    const ProviderScope(
      child: PBSApp(),
    ),
  );
}

class PBSApp extends ConsumerWidget {
  const PBSApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: appPlatform != AppPlatform.web ?
          FutureBuilder(
              future: DatabaseManager().getAllAvatars(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final avatarState = ref.read(avatarProvider);
                  avatarState.addAll(snapshot.data!);
                  return const HomePage();
                }
                if (snapshot.hasError) {
                  return const ErrorPage();
                } else {
                  return const LoadingPage(text1: 'Preparing the classroom',);
                }
              }
          ) : const HomePage()
    );
  }
}
