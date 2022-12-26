import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.name,
    this.hintText,
    this.initialValue,
  });

  final String? hintText;
  final String? initialValue;
  final String name;

  @override
  Widget build(BuildContext context) {

    int maxLength = 25;

    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: size.height * 0.01),
          child: FormBuilderTextField(
            initialValue: initialValue,
            maxLength: maxLength,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 16),
              counterText: "",
              border: const OutlineInputBorder(),
              hintStyle: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(color: Colors.black54,
              ),
              hintText: hintText,
              errorStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: Colors.red,
                fontSize: 10
                  ),
            ),
            name: name,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Field is empty";
              }
              if(value.length > maxLength){
                return 'Max. number of characters';
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
