import 'dart:typed_data';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/avatar_image.dart';

final avatarProvider = Provider<List<SavedAvatar>>((ref) => []);
