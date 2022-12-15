import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pbs_app/app/state/simple_providers.dart';
import 'package:pbs_app/utils/constants.dart';

class AvatarImage extends ConsumerStatefulWidget {
  const AvatarImage({Key? key, required this.avatarKey}) : super(key: key);

  final String avatarKey;

  @override
  ConsumerState<AvatarImage> createState() => _AvatarImageState();
}

class _AvatarImageState extends ConsumerState<AvatarImage> {
  Uint8List? _bytes;
  late final Future _firebaseStorageFuture;

  @override
  void initState() {
    _firebaseStorageFuture = FirebaseStorage.instance
        .ref('$kAvatarsBucket/${widget.avatarKey}')
        .getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final avatarState = ref.read(avatarProvider);
    final avatarNotifier = ref.read(avatarProvider.notifier);

    if (avatarState.containsKey(widget.avatarKey)) {
      _bytes = avatarState.entries
          .firstWhere((element) => element.key == widget.avatarKey)
          .value;
    }

    return _bytes == null
        ? FutureBuilder(
            future: _firebaseStorageFuture,
            builder: (context, snapshot) {
              if(snapshot.hasError){
                return Icon(Icons.person);
              }
              if(snapshot.hasData) {
                avatarNotifier.state.addAll({widget.avatarKey : snapshot.data});
                /// FIX BELOW
                _bytes = snapshot.data;
                /////////////////////////////////////////////////
                return ImageBox(bytes: _bytes);
              }
              return Center(child: CircularProgressIndicator());
            })
        : ImageBox(bytes: _bytes);
  }
}

class ImageBox extends StatelessWidget {
  const ImageBox({
    Key? key,
    required Uint8List? bytes,
  })  : _bytes = bytes,
        super(key: key);

  final Uint8List? _bytes;

  @override
  Widget build(BuildContext context) {
    return _bytes != null
        ? SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.memory(_bytes!),
          )
        : const Icon(Icons.person);
  }
}
