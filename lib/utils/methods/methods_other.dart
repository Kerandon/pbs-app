import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:pbs_app/enums/platforms.dart';

AppPlatform checkAppPlatform() {
  if (kIsWeb) {
    return AppPlatform.web;
  } else {
    return AppPlatform.android;
  }
}
