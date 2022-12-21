import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pbs_app/utils/constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.boxLabel,
    required this.name,
  });

  final String boxLabel;
  final String name;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          width: size.width,
          height: size.height * kFormHeight,
          child: FormBuilderTextField(
            decoration: InputDecoration(
              border: InputBorder.none,
                hintStyle: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.black54),
                hintText: 'Enter your name',
            ),
            name: name,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Field is empty";
              }
              return null;
            },
            style: Theme.of(context).textTheme.displaySmall,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ),
      ],
    );
  }
}
