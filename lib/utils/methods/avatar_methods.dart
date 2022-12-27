import 'dart:math';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:pbs_app/state/database_manager.dart';
import 'package:pbs_app/models/avatar_image.dart';
import 'package:pbs_app/configs/constants.dart';
import 'dart:developer' as developer;

import '../../state/simple_providers.dart';
import '../globals.dart';
import '../../models/student.dart';
import '../enums/platforms.dart';

Future<Uint8List?> generateAvatar(
    {required Student student, required WidgetRef ref}) async {
  final String avatarKey = '${student.classRoom}_${student.name}';
  final avatarState = ref.read(avatarProvider);

  final randomID = Random().nextInt(99999999);
  final response =
      await http.get(Uri.parse('https://robohash.org/$avatarKey$randomID'));
  final bytes = response.bodyBytes;
  try {
    avatarState.addAll([SavedAvatar(avatarKey: avatarKey, bytes: bytes)]);
    final uploadTask = await FirebaseStorage.instance
        .ref('$kAvatarsBucket/$avatarKey')
        .putData(bytes);
    if (appPlatform != AppPlatform.web) {
      DatabaseManager().insertAvatars(
        avatars: [
          SavedAvatar(avatarKey: avatarKey, bytes: bytes),
        ],
      );
    }
    if (uploadTask.state == TaskState.success) {
      return bytes;
    }
  } on FirebaseException catch (e) {
    developer
        .log('Cloud Firestore avatar image upload task failed ${e.message}');
  }
  return null;
}

Future<int> saveImageData(
    {required Uint8List bytes,
    required String avatarKey,
    required WidgetRef ref}) async {
  try {
    await FirebaseStorage.instance
        .ref('$kAvatarsBucket/$avatarKey')
        .putData(bytes);
  } on FirebaseException catch (e) {
    developer.log(e.message!);
    return 400;
  }
  if (appPlatform != AppPlatform.web) {
    await DatabaseManager().insertAvatars(
        avatars: [SavedAvatar(avatarKey: avatarKey, bytes: bytes)]);
  }

  ref
      .read(avatarProvider)
      .addAll([SavedAvatar(avatarKey: avatarKey, bytes: bytes)]);
  return 200;
}

Future<int> removeImageData(
    {required Uint8List bytes,
    required String avatarKey,
    required WidgetRef ref}) async {
  try {
    await FirebaseStorage.instance.ref('$kAvatarsBucket/$avatarKey').delete();
  } on FirebaseException catch (e) {
    developer.log(e.message!);
    return 400;
  }
  if (appPlatform != AppPlatform.web) {
    await DatabaseManager().deleteAvatar(avatarKey: avatarKey);
  }

  ref
      .read(avatarProvider)
      .removeWhere((element) => element.avatarKey == avatarKey);
  return 200;
}
