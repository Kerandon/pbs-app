import 'package:flutter/material.dart';
import '../../models/note.dart';
import '../../models/student.dart';

class NoteTile extends StatefulWidget {
  const NoteTile({
    super.key,
    required this.note,
    required this.student,
    required this.onChanged,
    required this.value,
  });

  final Note note;
  final Student student;
  final Function(bool?) onChanged;
  final bool value;

  @override
  State<NoteTile> createState() => _NoteTileState();
}

class _NoteTileState extends State<NoteTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            widget.note.date,
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontSize: 10, color: Colors.grey),
          ),
          subtitle: Text(
            widget.note.note,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          leading: const Icon(
            Icons.note_outlined,
          ),
          trailing: Checkbox(
            value: widget.value,
            onChanged: widget.onChanged,
          ),
        ),
        const Divider()
      ],
    );
  }
}
