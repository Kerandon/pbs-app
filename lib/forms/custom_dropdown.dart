import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    super.key,
    required this.name,
    required this.values,
    this.hintText,
    this.initialValue,
    this.leading,
    this.newValueEntered,
    this.isValidated,
  });

  final String name;
  final List<String> values;
  final String? hintText;
  final dynamic initialValue;
  final String? leading;
  final Function(bool newValue)? newValueEntered;
  final Function(bool isValid)? isValidated;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      children: [
        leading != null
            ? Expanded(
                child: Text(
                  leading!,
                  style: Theme.of(context).textTheme.displaySmall
                  !.copyWith(color: Colors.black54),
                ),
              )
            : const SizedBox(),
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.only(bottom: size.height * 0.01),
            child: FormBuilderDropdown(
              onChanged: (value) {
                if (value != initialValue) {
                  newValueEntered?.call(true);
                } else {
                  newValueEntered?.call(false);
                }
                if (value != null) {
                  isValidated?.call(true);
                } else {
                  isValidated?.call(false);
                }
              },
              initialValue: initialValue,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 16),
                hintText: hintText,
                hintStyle: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(color: Colors.black54),
                errorStyle: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(color: Colors.red, fontSize: 10),
              ),
              name: name,
              items: values
                  .map(
                    (e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(
                        e,
                        style:
                            Theme.of(context).textTheme.displaySmall!.copyWith(
                                  color: Colors.black,
                                ),
                      ),
                    ),
                  )
                  .toList(),
              style: Theme.of(context).textTheme.displaySmall,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
          ),
        ),
      ],
    );
  }
}
