import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomDropDown extends StatefulWidget {
  const CustomDropDown(
      {super.key,
      required this.name,
      required this.values,
      this.hintText,
      this.initialValue,
      this.newValueEntered,
      this.isValidated});

  final String name;
  final List<String> values;
  final String? hintText;
  final dynamic initialValue;
  final Function(bool newValue)? newValueEntered;
  final Function(bool isValid)? isValidated;

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.01),
      child: FormBuilderDropdown(
        onChanged: (value) {
          if (value != widget.initialValue) {
            widget.newValueEntered?.call(true);
          } else {
            widget.newValueEntered?.call(false);
          }
          if (value != null) {
            widget.isValidated?.call(true);
          } else {
            widget.isValidated?.call(false);
          }
        },
        initialValue: widget.initialValue,

        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 16),
          hintText: widget.hintText,
          hintStyle: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(color: Colors.black54),
          errorStyle: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(color: Colors.red, fontSize: 10),
        ),
        name: widget.name,
        items: widget.values
            .map(
              (e) => DropdownMenuItem<String>(
                value: e,
                child: Text(
                  e,
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: Colors.black,
                      ),
                ),
              ),
            )
            .toList(),
        style: Theme.of(context).textTheme.displaySmall,
        // validator: (value) {
        //   if (value == null) {
        //     return '';
        //   }
        //   return null;
        // },
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}
