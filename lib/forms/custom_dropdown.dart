import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pbs_app/utils/methods/methods_extensions.dart';

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
    return Stack(
      children: [
        _valueSelected
            ? SizedBox(
                height: size.height * 0.06,
              )
            : SizedBox(
                width: size.width,
                height: size.height * 0.06,
                child: Align(
                  alignment: const Alignment(-1, -0.10),
                  child: Text(
                    widget.boxLabel.capitalizeFirstLetter(),
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(fontSize: 12),
                  ),
                ),
              ),
        FormBuilderDropdown(
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
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              )
              .toList(),
          style: Theme.of(context).textTheme.displaySmall,
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(bottom: size.height * 0.008)),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Make a selection';
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }
}
