import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pbs_app/animations/fade_in_animation.dart';
import 'package:pbs_app/state/simple_providers.dart';
import '../../models/avatar_image.dart';
import '../../models/student.dart';

class AvatarImage extends ConsumerStatefulWidget {
  const AvatarImage({Key? key, required this.student, this.present = true})
      : super(key: key);

  final Student student;
  final bool present;

  @override
  ConsumerState<AvatarImage> createState() => _AvatarImageState();
}

class _AvatarImageState extends ConsumerState<AvatarImage> {
  late final String _avatarKey;
  Uint8List? _bytes;
  late final Future<Uint8List?> _firebaseStorageFuture;

  @override
  void initState() {
    _avatarKey = '${widget.student.classroom}_${widget.student.name}';
    _firebaseStorageFuture =
        FirebaseStorage.instance.ref().child('avatars/$_avatarKey').getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final avatarState = ref.watch(avatarProvider);

    for (var a in avatarState) {
      if (a.avatarKey == _avatarKey) {
        _bytes = a.bytes;
      }
    }

    return Stack(
      children: [
        _bytes == null
            ? FutureBuilder(
                future: _firebaseStorageFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return ImageBox(bytes: null, present: widget.present);
                  }
                  if (snapshot.hasData) {
                    _bytes = snapshot.data;
                    avatarState.addAll(
                        [SavedAvatar(avatarKey: _avatarKey, bytes: _bytes!)]);

                    return ImageBox(
                      bytes: _bytes,
                      present: widget.present,
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                })
            : ImageBox(
                bytes: _bytes,
                present: widget.present,
              ),
        //CrownWidget(student: widget.student)
      ],
    );
  }
}

class ImageBox extends StatelessWidget {
  const ImageBox({
    Key? key,
    required Uint8List? bytes,
    required this.present,
  })  : _bytes = bytes,
        super(key: key);

  final bool present;
  final Uint8List? _bytes;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FadeInAnimation(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Container(
            width: size.width * 0.15,
            height: size.width * 0.15,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
              shape: BoxShape.circle,
              image: _bytes != null && present
                  ? DecorationImage(
                      image: MemoryImage(
                        _bytes!,
                      ),
                      fit: BoxFit.contain)
                  : null,
            ),
            child: _bytes == null
                ? present
                    ? Icon(
                        Icons.person_outline,
                        size: 30,
                      )
                    : Icon(
                        Icons.home_outlined,
                        size: 30,
                      )
                : present
                    ? SizedBox()
                    : Icon(
                        Icons.home_outlined,
                        size: 30,
                      )),
      ),
    );
  }
}
