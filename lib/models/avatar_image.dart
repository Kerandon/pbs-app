import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class SavedAvatar extends Equatable {
  final String avatarKey;
  final Uint8List bytes;

  const SavedAvatar({required this.avatarKey, required this.bytes});

  Map<String, dynamic> toMap() {
    return {'avatarKey': avatarKey, 'bytes': bytes};
  }

  factory SavedAvatar.fromMap({required Map<String, dynamic> map}) {
    return SavedAvatar(avatarKey: map['avatarKey'], bytes: map['bytes']);
  }

  @override
  List<Object> get props => [avatarKey];

}
