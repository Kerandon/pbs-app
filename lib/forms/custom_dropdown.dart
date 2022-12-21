import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pbs_app/utils/methods/methods_extensions.dart';

import '../utils/constants.dart';

class CustomDropDown extends StatefulWidget {
  const CustomDropDown({
    super.key,
    required this.boxLabel,
    required this.values,
  });

  final String boxLabel;
  final List<String> values;

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  bool _valueSelected = false;

  void _onValueSelected(String? value) {
    if (value != null) {
      _valueSelected = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FormBuilderDropdown(
      decoration: InputDecoration(
        hintText: 'Select',
        hintStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
              color: Colors.black54,
            ),
        border: InputBorder.none,
      ),
      name: widget.boxLabel,
      onChanged: (value) {
        _onValueSelected(value);
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
