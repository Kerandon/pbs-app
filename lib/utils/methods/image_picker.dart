import 'dart:io';
import 'dart:developer' as developer;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pbs_app/state/simple_providers.dart';
import 'package:pbs_app/utils/enums/task_result.dart';
import 'package:pbs_app/utils/firebase_properties.dart';

import '../../models/avatar_image.dart';
import '../../models/student.dart';

Future<File?> pickImage() async {
  try {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 30);
    if (image != null) {
      return File(image.path);
    }
  } on PlatformException catch (e) {
    developer.log(e.message!);
  }
  return null;
}

Future<TaskResult> saveFileImage(
    {required File file,
    required Student student,
    required WidgetRef ref}) async {
  final bytes = await file.readAsBytes();
  final avatarKey = '${student.classroom}_${student.name}';
  final avatarState = ref.read(avatarProvider);
  avatarState.addAll([SavedAvatar(avatarKey: avatarKey, bytes: bytes)]);

  try {
    await FirebaseStorage.instance
        .ref('${FirebaseProperties.avatarsBucket}/$avatarKey')
        .putData(bytes);
  } on FirebaseException catch (e) {
    developer.log(e.message!);
    return TaskResult.failFirebase;
  }

  return TaskResult.success;
}
