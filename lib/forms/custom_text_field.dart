import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.name,
    this.hintText,
    this.initialValue,
    this.newValueEntered,
    this.isValidated,
  });

  final String? hintText;
  final String? initialValue;
  final String name;
  final Function(bool)? newValueEntered;
  final Function(bool)? isValidated;

  @override
  Widget build(BuildContext context) {
    int maxLength = 25;

    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: size.height * 0.01),
          child: FormBuilderTextField(
              onChanged: (value) {
                if (value != initialValue) {
                  newValueEntered?.call(true);
                } else {
                  newValueEntered?.call(false);
                }
                if (value!.isNotEmpty && value.length < 12) {
                  isValidated?.call(true);
                } else {
                  isValidated?.call(false);
                }
              },
              initialValue: initialValue,
              maxLength: maxLength,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 16),
                counterText: "",
                hintStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: Colors.black54,
                    ),
                hintText: hintText,
              ),
              name: name,
              style: Theme.of(context).textTheme.displaySmall,
              autovalidateMode: AutovalidateMode.onUserInteraction),
        ),
      ],
    );
  }
}
