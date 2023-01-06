import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pbs_app/app/components/avatar_image.dart';
import 'package:pbs_app/app/components/loading_page.dart';
import 'package:pbs_app/classroom/classroom_main.dart';
import 'package:pbs_app/classroom/notes/text_input_box.dart';
import 'package:pbs_app/utils/constants_other.dart';
import 'package:pbs_app/utils/firebase_properties.dart';
import 'package:pbs_app/utils/methods/route_methods.dart';

import '../../app/components/confirmation_box.dart';
import '../../app/components/loading_helper.dart';
import '../../app/components/sub_banner.dart';
import '../../models/note.dart';
import '../../models/student.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:intl/date_symbol_data_local.dart' show initializeDateFormatting;

import '../../utils/app_messages.dart';
import '../../utils/enums/task_result.dart';
import '../../utils/methods/notes.dart';
import 'note_tile.dart';

class NotesMain extends StatefulWidget {
  const NotesMain({Key? key, required this.student}) : super(key: key);

  final Student student;

  @override
  State<NotesMain> createState() => _NotesMainState();
}

class _NotesMainState extends State<NotesMain> {
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _notesStream;
  final FocusNode _focusNode = FocusNode();

  final Map<Note, bool> _checkedList = {};
  List<Note> notes = [];

  bool _allSelected = false;
  int _numberSelected = 0;
  int _notesLength = 0;

  void _updateCheck({required Note note, required bool isChecked}) {
    _checkedList.addAll({note: isChecked});
    _focusNode.unfocus();
    setState(() {});
  }

  void _selectAll() {
    _focusNode.unfocus();
    if (!_allSelected) {
      for (var n in notes) {
        _checkedList.addAll({n: true});
      }
    } else {
      for (var n in _checkedList.entries) {
        _checkedList.addAll({n.key: false});
      }
    }
    _allSelected = !_allSelected;

    setState(() {});
  }

  late final ScaffoldMessengerState? _scaffoldMessengerStateState;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scaffoldMessengerStateState = ScaffoldMessenger.of(context);
    });

    initializeDateFormatting(kAustraliaLocale);
    _notesStream = FirebaseFirestore.instance
        .collection(FirebaseProperties.collectionClassrooms)
        .doc(widget.student.classroom)
        .collection(FirebaseProperties.collectionStudents)
        .doc(widget.student.name)
        .collection(FirebaseProperties.collectionNotes)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _numberSelected = 0;
    for (var i in _checkedList.entries) {
      if (i.value) {
        _numberSelected++;
      }
    }

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
                width: size.width * 0.08,
                height: size.height * 0.08,
                child: AvatarImage(student: widget.student)),
            Text(
              '   ${widget.student.name}\'s Notes',
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            pushReplacementRoute(
              context,
              ClassroomMain(classroom: widget.student.classroom),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
              onPressed: () => _selectAll(),
              icon: const Icon(Icons.select_all_outlined)),
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: _notesStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      notes.clear();

                      if (snapshot.hasData) {
                        for (var d in snapshot.data!.docs) {
                          DateTime date =
                              d.get(FirebaseProperties.date).toDate();

                          String dateFormatted =
                              DateFormat.yMMMEd(kAustraliaLocale).format(date);

                          notes.add(
                            Note(
                              note: d.get(FirebaseProperties.note),
                              index: int.parse(d.id),
                              date: dateFormatted,
                            ),
                          );
                        }
                        notes.sort((a, b) => b.index.compareTo(a.index));

                        _notesLength = notes.length;

                        return SizedBox(
                          height: size.height,
                          width: size.width,
                          child: Column(
                            children: [
                              SubBanner(
                                contents: [
                                  const Icon(Icons.note_outlined),
                                  SizedBox(
                                    width: size.width * 0.02,
                                  ),
                                  Text('${_notesLength.toString()} notes'),
                                ],
                              ),
                              _numberSelected > 0
                                  ? SizedBox(
                                      width: size.width * 0.90,
                                      height: size.height * 0.05,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          _focusNode.unfocus();
                                          BuildContext? dialogContext;
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              dialogContext = context;
                                              return ConfirmationBox(
                                                title:
                                                    'Delete the $_numberSelected selected notes?',
                                                voidCallBack: () {
                                                  Navigator.pop(dialogContext!);

                                                  pushRoute(
                                                    context,
                                                    LoadingHelper(
                                                      onFutureComplete:
                                                          (taskResult) {
                                                        _focusNode.unfocus();
                                                        if (taskResult ==
                                                            TaskResult
                                                                .success) {
                                                          _scaffoldMessengerStateState
                                                              ?.showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                  _checkedList.length == 1 ? AppMessages
                                                                      .noteDeleted : AppMessages.notesDeleted)
                                                            ),
                                                          );
                                                        }
                                                        _checkedList.clear();
                                                        setState(() {});
                                                      },
                                                      future: deleteNotes(
                                                          student:
                                                              widget.student,
                                                          notes: _checkedList
                                                              .keys
                                                              .toList()),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.delete_outline,
                                            ),
                                            SizedBox(width: size.width * 0.02),
                                            Text('$_numberSelected selected')
                                          ],
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: notes.length,
                                  itemBuilder: (context, index) {
                                    return NoteTile(
                                      note: notes[index],
                                      student: widget.student,
                                      value: _checkedList.containsKey(
                                              notes.elementAt(index))
                                          ? _checkedList.entries
                                              .firstWhere((element) =>
                                                  element.key.index ==
                                                  notes.elementAt(index).index)
                                              .value
                                          : false,
                                      onChanged: (value) {
                                        _updateCheck(
                                            note: notes.elementAt(index),
                                            isChecked: value!);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return SizedBox(
                          height: size.height * 0.80,
                          child: const LoadingPage());
                    },
                  ),
                ],
              ),
            ),
          ),
          NoteTextInputBox(
            notesLength: _notesLength,
            student: widget.student,
            focusNode: _focusNode,
            onCompleteCallback: () {
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
