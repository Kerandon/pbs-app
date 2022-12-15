import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../enums/platforms.dart';

final avatarProvider = StateProvider<Map>((ref) => {});

final platformProvider = StateProvider<AppPlatform>((ref){
  return AppPlatform.android;
});