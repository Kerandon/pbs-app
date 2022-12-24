import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomDropDown extends StatefulWidget {
  const CustomDropDown({
    super.key,
    required this.boxLabel,
    required this.values,
    this.hintText = 'Select'
  });

  final String boxLabel;
  final List<String> values;
  final String hintText;

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {

  @override
  Widget build(BuildContext context) {
    return FormBuilderDropdown(
      decoration: InputDecoration(
        hintText: 'Select',
        hintStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
              color: Colors.black54,
            ),
        errorStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
              color: Colors.red,
            ),
        border: InputBorder.none,
      ),
      name: widget.boxLabel,
      onChanged: (value) {
        if (value != null) {
          setState(() {});
        }
      },
      items: widget.values
          .map(
            (e) => DropdownMenuItem<String>(
              value: e,
              child: Text(
                e,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: Colors.black54,
                    ),
              ),
            ),
          )
          .toList(),
      style: Theme.of(context).textTheme.displaySmall,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Make a selection';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
