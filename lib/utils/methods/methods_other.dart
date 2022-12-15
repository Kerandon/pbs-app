import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pbs_app/enums/platforms.dart';

import '../../app/state/simple_providers.dart';

void checkAppPlatform(WidgetRef ref) {
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    if (kIsWeb) {
      ref.read(platformProvider.notifier).state = AppPlatform.web;
    }
    if (Platform.isAndroid) {
      ref.read(platformProvider.notifier).state = AppPlatform.android;
    }
  });
}
