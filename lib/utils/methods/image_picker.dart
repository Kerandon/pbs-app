import 'dart:io';
import 'dart:developer' as developer;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pbs_app/state/database_manager.dart';
import 'package:pbs_app/state/simple_providers.dart';

import '../../models/avatar_image.dart';
import '../../models/student.dart';

Future<File?> pickImage() async {
  try {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 30);
    if (image != null) {
      print('image not null ${image.path}');
      return File(image.path);
    }
  } on PlatformException catch (e) {
    print('Failed to pick image ${e.message}');
  }
  return null;
}

Future<int?> saveFileImage(
    {required File file,
    required Student student,
    required WidgetRef ref}) async {
  final bytes = await file.readAsBytes();
  TaskSnapshot? taskSnapshot;
  final avatarKey = '${student.classRoom}_${student.name}';
  final avatarState = ref.read(avatarProvider);
  avatarState.addAll([SavedAvatar(avatarKey: avatarKey, bytes: bytes)]);

  try {
    taskSnapshot = await FirebaseStorage.instance
        .ref('${student.classRoom}_${student.name}')
        .putData(bytes);
  } on FirebaseException catch (e) {
    developer.log(e.message!);
  }

  if (taskSnapshot != null) {
    return await DatabaseManager().insertAvatars(
        avatars: [SavedAvatar(avatarKey: avatarKey, bytes: bytes)]);
  } else {
    return null;
  }
}
