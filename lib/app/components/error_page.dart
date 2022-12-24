import 'package:flutter/material.dart';
import 'package:pbs_app/main.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).primaryColorLight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Something went wrong...\n\nPlease check your internet connection',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 100,),
          ElevatedButton(onPressed: (){

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const PBSApp()),
                    (route) => false);

          }, child: const Text('Restart'))
        ],
      ),
    );
  }
}
