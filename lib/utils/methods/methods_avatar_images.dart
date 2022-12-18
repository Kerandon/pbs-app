import 'dart:math';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:pbs_app/app/state/database_service.dart';
import 'package:pbs_app/enums/platforms.dart';
import 'package:pbs_app/models/avatar_image.dart';
import 'package:pbs_app/utils/constants.dart';
import '../../app/state/simple_providers.dart';
import '../../models/student.dart';
import 'dart:developer' as developer;

Future<Uint8List?> generateAvatar(
    {required Student student, required WidgetRef ref}) async {
  final String avatarKey = '${student.classRoom}_${student.name}';
  final provider = ref.read(avatarProvider);

  if (provider.containsKey(avatarKey)) {
    return provider.entries
        .firstWhere((element) => element.key == avatarKey)
        .value;
  } else {
    final randomID = Random().nextInt(99999999);
    final response =
        await http.get(Uri.parse('https://robohash.org/$avatarKey$randomID'));
    final bytes = response.bodyBytes;
    try {
      final uploadTask = await FirebaseStorage.instance
          .ref('$kAvatarsBucket/$avatarKey')
          .putData(bytes);
      if (uploadTask.state == TaskState.success) {
        print('bytes to add $bytes');
        ref.read(avatarProvider).addAll({avatarKey: bytes});

        if(appPlatform != AppPlatform.web) {
          DatabaseService().insertAvatars(
            avatars: [
              SavedAvatar(avatarKey: avatarKey, bytes: bytes),
            ],
          );
        }
        return bytes;
      }
    } on FirebaseException catch (e) {
      developer
          .log('Cloud Firestore avatar image upload task failed ${e.message}');
    }
    return null;
  }
}
