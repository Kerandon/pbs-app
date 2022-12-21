import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pbs_app/app/state/simple_providers.dart';

class AvatarImage extends ConsumerStatefulWidget {
  const AvatarImage({Key? key, required this.avatarKey, this.present = true})
      : super(key: key);

  final String avatarKey;
  final bool present;

  @override
  ConsumerState<AvatarImage> createState() => _AvatarImageState();
}

class _AvatarImageState extends ConsumerState<AvatarImage> {
  Uint8List? _bytes;
  late final Future<Uint8List?> _firebaseStorageFuture;

  @override
  void initState() {
    _firebaseStorageFuture = FirebaseStorage.instance
        .ref()
        .child('avatars/${widget.avatarKey}')
        .getData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final avatarState = ref.watch(avatarProvider);
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
              if (snapshot.hasError) {
                return const Icon(Icons.person);
              }
              if (snapshot.hasData) {
                avatarNotifier.state.addAll({widget.avatarKey: snapshot.data!});

                //TODO - fix
                /// FIX BELOW
                _bytes = snapshot.data;
                /////////////////////////////////////////////////
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
          );
  }

  // bool checkIfHighestPoint(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
  //   List<int> allPoints = [];
  //   final docs = snapshot.data!.docs;
  //   for (var d in docs) {
  //     allPoints.add(d.get('points'));
  //   }
  //   final highestPoint = allPoints.reduce(max);
  //   if (_points != 0 && _points >= highestPoint) {
  //     setState(() {});
  //
  //     return true;
  //   } else {
  //     setState(() {});
  //     return false;
  //   }
  // }

}

class ImageBox extends StatelessWidget {
  const ImageBox({
    Key? key,
    required Uint8List? bytes,
    required this.present,
  })  : _bytes = bytes,
        super(key: key);

  final present;
  final Uint8List? _bytes;

  @override
  Widget build(BuildContext context) {
    return _bytes != null
        ? SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: present ? Image.memory(_bytes!) : Image.memory(_bytes!, color: Colors.grey,),
          )
        : const Icon(Icons.person);
  }
}
