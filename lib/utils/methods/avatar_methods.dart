import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:pbs_app/utils/firebase_properties.dart';
import 'package:pbs_app/state/database_manager.dart';
import 'package:pbs_app/models/avatar_image.dart';
import 'package:pbs_app/utils/enums/task_result.dart';
import 'dart:developer' as developer;

import '../../state/simple_providers.dart';
import '../globals.dart';
import '../../models/student.dart';
import '../enums/platforms.dart';

Future<TaskResult> generateAvatar(
    {required Student student, required WidgetRef ref}) async {
  final String avatarKey = '${student.classroom}_${student.name}';

  Uint8List? bytes;
  try {
    final randomID = Random().nextInt(9999999);
    final response =
        await http.get(Uri.parse('https://robohash.org/$avatarKey$randomID'));
    bytes = response.bodyBytes;
  } on HttpException catch (e) {
    developer.log(e.message);
    return TaskResult.failHttp;
  }

  try {
    await FirebaseStorage.instance
        .ref('${FirebaseProperties.avatarsBucket}/$avatarKey')
        .putData(bytes);
  } on FirebaseException catch (e) {
    developer.log('ERROR!! ${e.message!}');
    return TaskResult.failFirebase;
  }
  if (appPlatform != AppPlatform.web) {
    await DatabaseManager().insertAvatars(
      avatars: [
        SavedAvatar(avatarKey: avatarKey, bytes: bytes),
      ],
    );
  }
  ref.read(avatarProvider).addAll(
    [
      SavedAvatar(avatarKey: avatarKey, bytes: bytes),
    ],
  );

  return TaskResult.success;
}

Future<TaskResult> saveImageData(
    {required Uint8List bytes,
    required String avatarKey,
    required WidgetRef ref}) async {
  try {
    await FirebaseStorage.instance
        .ref('${FirebaseProperties.avatarsBucket}/$avatarKey')
        .putData(bytes);
  } on FirebaseException catch (e) {
    developer.log(e.message!);
    return TaskResult.failFirebase;
  }
  if (appPlatform != AppPlatform.web) {
    await DatabaseManager().insertAvatars(
        avatars: [SavedAvatar(avatarKey: avatarKey, bytes: bytes)]);
  }

  ref
      .read(avatarProvider)
      .addAll([SavedAvatar(avatarKey: avatarKey, bytes: bytes)]);

  return TaskResult.success;
}

Future<TaskResult> removeImageData(
    {required String avatarKey, required WidgetRef ref}) async {
  try {
    await FirebaseStorage.instance
        .ref('${FirebaseProperties.avatarsBucket}/$avatarKey')
        .delete();
  } on FirebaseException catch (e) {
    developer.log(e.message!);
    return TaskResult.failFirebase;
  }
  if (appPlatform != AppPlatform.web) {
    await DatabaseManager().deleteAvatar(avatarKey: avatarKey);
  }

  ref
      .read(avatarProvider)
      .removeWhere((element) => element.avatarKey == avatarKey);
  return TaskResult.success;
}
