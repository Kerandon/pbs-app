import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

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
        SizedBox(
          width: size.width,
          height: size.height * 0.06,
          child: FormBuilderTextField(
            name: name,
            decoration: InputDecoration(
                hintStyle: Theme.of(context).textTheme.displaySmall,
                hintText: boxLabel,
                contentPadding: EdgeInsets.only(top: size.height * 0.021),
                isDense: true,
                border: InputBorder.none),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Field is blank";
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
