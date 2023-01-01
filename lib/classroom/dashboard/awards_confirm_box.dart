import 'package:flutter/material.dart';
import 'package:pbs_app/app/components/loading_helper.dart';
import 'package:pbs_app/utils/methods/awards_methods.dart';
import 'package:pbs_app/utils/methods/route_methods.dart';

import '../../models/student.dart';

class AwardsConfirmBox extends StatelessWidget {
  const AwardsConfirmBox({Key? key, required this.award, required this.student})
      : super(key: key);

  final MapEntry<String, String> award;
  final Student student;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: SizedBox(
        width: size.width * 0.90,
        height: size.height * 0.60,
        child: Stack(
          children: [
            AlertDialog(
              insetPadding: EdgeInsets.zero,
              title: Text(
                award.key,
                textAlign: TextAlign.center,
              ),
              content: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(award.value),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                      child: Padding(
                    padding: EdgeInsets.all(18.0),
                    child: Center(
                      child: Text(
                        'This award is given to students who role model excellent behaviours',
                      ),
                    ),
                  )),
                ],
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        pushRoute(
                          context,
                          LoadingHelper(
                            future:
                                giveAward(student: student, award: award.key),
                          ),
                        );
                      },
                      child: const Text('Award!'),
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              left: size.width * 0.75,
              child: Material(
                child: IconButton(
                  onPressed: () async {
                    await Navigator.of(context).maybePop();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
