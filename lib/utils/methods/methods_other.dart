import 'package:flutter/foundation.dart' show kIsWeb;
import '../enums/platforms.dart';

AppPlatform checkAppPlatform() {
  if (kIsWeb) {
    return AppPlatform.web;
  } else {
    return AppPlatform.android;
  }
}
