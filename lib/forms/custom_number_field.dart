import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomNumberField extends StatelessWidget {
  const CustomNumberField({
    super.key,
    required this.name,
    this.hintText,
    this.initialValue,
    this.newValueEntered,
  });

  final String? hintText;
  final String? initialValue;
  final String name;
  final Function(bool)? newValueEntered;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FormBuilderTextField(
          onChanged: (value){
            if(value != initialValue){
              newValueEntered?.call(true);
            }else{
              newValueEntered?.call(false);
            }
          },
          textAlign: TextAlign.center,

          initialValue: initialValue,
          keyboardType: TextInputType.number,
          maxLength: 3,

          inputFormatters: [FilteringTextInputFormatter.digitsOnly],

          decoration: InputDecoration(
            counterText: "",
            helperText: "",
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(),
            hintStyle: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(color: Colors.black54),
            hintText: hintText,
            errorStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
                  color: Colors.red,
                ),
          ),
          name: name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "";
            }
            if(value.length > 3){
              return "";
            }
            return null;
          },
          style: Theme.of(context).textTheme.displaySmall,
          autovalidateMode: AutovalidateMode.onUserInteraction,

        ),
      ],
    );
  }
}
