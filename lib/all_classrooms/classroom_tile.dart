import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pbs_app/animations/fade_in_animation.dart';
import 'package:pbs_app/classroom/classroom_main.dart';

class ClassroomTile extends StatelessWidget {
  const ClassroomTile({
    super.key,
    required this.classroom,
  });

  final String classroom;

  @override
  Widget build(BuildContext context) {
    return FadeInAnimation(
      child: Material(
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ClassroomMain(classroom: classroom),
              ),
            );
          },
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: FaIcon(FontAwesomeIcons.graduationCap, color: Theme.of(context).primaryColorDark,),
              ),
              Expanded(
                child: Text(classroom),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
