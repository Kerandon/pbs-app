import 'package:flutter/material.dart';
import '../../app/components/loading_page.dart';
import '../../models/student.dart';
import '../../utils/methods/awards_methods.dart';
import 'awards_confirm_box.dart';

class AwardsMenu extends StatefulWidget {
  const AwardsMenu({Key? key, required this.student}) : super(key: key);

  final Student student;

  @override
  State<AwardsMenu> createState() => _AwardsMenuState();
}

class _AwardsMenuState extends State<AwardsMenu> {
  late final Future<Map<String, String>> _awardsFuture;

  @override
  void initState() {
    _awardsFuture = getAllAwardImages();
    super.initState();
  }

  Map<String, String> awards = {};

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AlertDialog(
      title: const Text(
        'Awards Menu',
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        width: size.width * 0.90,
        height: size.height * 0.40,
        child: FutureBuilder<Map<String, String>>(
          future: _awardsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              for (var d in snapshot.data!.entries) {
                awards.addAll({d.key: d.value});
              }

              return GridView.builder(
                itemCount: awards.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: size.width * 0.03,
                    crossAxisSpacing: size.width * 0.03,
                    mainAxisExtent: size.height * 0.10),
                itemBuilder: (context, index) => AwardTile(
                  award: awards.entries.elementAt(index),
                  student: widget.student,
                ),
              );
            }
            return const LoadingPage();
          },
        ),
      ),
    );
  }
}

class AwardTile extends StatelessWidget {
  const AwardTile({
    super.key,
    required this.award,
    required this.student,
  });

  final MapEntry<String, String> award;
  final Student student;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AwardsConfirmBox(
            award: award,
            student: student,
          ),
        );
      },
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(award.value),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                award.key,
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
          )
        ],
      ),
    );
  }
}
