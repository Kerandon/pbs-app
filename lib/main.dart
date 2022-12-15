import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pbs_app/app/state/simple_providers.dart';
import 'package:pbs_app/enums/platforms.dart';
import 'package:pbs_app/utils/methods/methods_other.dart';

import 'classroom/class_room_main.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const ProviderScope(child: PBSApp()));
}

class PBSApp extends ConsumerWidget {
  const PBSApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    checkAppPlatform(ref);


    return const MaterialApp(home: ClassRoomMain());
  }
}
