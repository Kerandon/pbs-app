import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pbs_app/models/student.dart';
import '../../app/components/loading_helper.dart';
import '../../configs/app_colors.dart';
import '../../configs/ui_constants.dart';
import '../../utils/app_messages.dart';
import '../../utils/enums/task_result.dart';
import '../../utils/firebase_properties.dart';
import '../../utils/methods/notes.dart';
import '../../utils/methods/pop_ups.dart';
import '../../utils/methods/route_methods.dart';

class NoteTextInputBox extends StatefulWidget {
  const NoteTextInputBox({
    super.key,
    required this.notesLength,
    required this.student,
    required this.focusNode,
    required this.onCompleteCallback,
  });

  final int notesLength;
  final Student student;
  final FocusNode focusNode;
  final VoidCallback onCompleteCallback;

  @override
  State<NoteTextInputBox> createState() => _NoteTextInputBoxState();
}

class _NoteTextInputBoxState extends State<NoteTextInputBox> {
  final _textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  bool _expand = false;
  bool _validated = false;

  @override
  void initState() {
    if(widget.notesLength == 0){
      _expand = true;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    final size = MediaQuery.of(context).size;
    return Positioned(
      bottom: 0,
      child: AnimatedContainer(
        height: _expand ? size.height * 0.40 : size.height * 0.08,
        width: size.width,
        duration: const Duration(milliseconds: 150),
        decoration: const BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(kBorderRadius),
            topRight: Radius.circular(kBorderRadius),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: IconButton(
                  onPressed: () {
                    _setExpand();
                  },
                  icon: Icon(
                    _expand
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_up_rounded,
                    size: 40,
                  )),
            ),
            _expand
                ? Expanded(
                    flex: 5,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          size.width * 0.05,
                          size.height * 0.01,
                          size.width * 0.05,
                          size.height * 0.01),
                      child: FormBuilder(
                        key: _formKey,
                        child: FormBuilderTextField(
                          onChanged: (value){
                            _checkIfValidated(value);
                          },
                          focusNode: widget.focusNode,
                          controller: _textEditingController,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            filled: true,
                          ),
                          name: FirebaseProperties.note,
                          maxLines: 10,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
            _expand
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: size.height * 0.01),
                      child: SizedBox(
                        width: size.width * 0.80,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: _validated ? () async {
                            widget.focusNode.unfocus();
                            if (_formKey.currentState != null) {
                              _formKey.currentState!.save();
                              final value = _formKey
                                  .currentState!.value[FirebaseProperties.note];
                              if (value != null && value.toString().trim() != "") {
                                    await saveNoteToFirebase(
                                      student: widget.student,
                                      note: value,
                                      index: widget.notesLength,
                                    ).then((value) async {
                                            widget.onCompleteCallback.call();
                                            widget.focusNode.unfocus();
                                              _textEditingController.clear();

                                    });
                              }
                            }
                          } : null,
                          child: const Text(AppMessages.addNote),
                        ),
                      ),
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  void _checkIfValidated(String? value) {
             if (value != null && value.toString().trim() != ""){
      _validated = true;
    }else{
      _validated = false;
    }
    setState(() {

    });
  }
  _setExpand({bool? expand}) {
    if (expand == null) {
      _expand = !_expand;
    } else {
      _expand = expand;
    }

    setState(() {});
  }
}
