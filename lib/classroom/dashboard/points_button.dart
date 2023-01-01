
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pbs_app/configs/ui_constants.dart';

import '../../utils/methods/points_methods.dart';

class PointsButton extends StatelessWidget {
  const PointsButton({
    super.key, required this.documentRef,
  });

  final DocumentReference<Map<String, dynamic>> documentRef;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(kBorderRadius),
        child: Material(
          color: Colors.deepPurple,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: InkWell(
                onTap: () async {
                  await awardStudentOnePoint(
                      documentRef:
                      documentRef);
                },
                child: Column(
                  children: [
                    Expanded(
                      child: FittedBox(
                        child: Icon(
                          Icons.celebration_outlined,
                          size: 100,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Award a Point!', style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white)),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
