import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import '../../helpers/weekday.dart';

class AddJournalScreen extends StatefulWidget {
  AddJournalScreen({super.key, required this.journal});
  final Journal journal;
  final service = JournalService();

  @override
  State<AddJournalScreen> createState() => _AddJournalScreenState();
}

class _AddJournalScreenState extends State<AddJournalScreen> {
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();

  Future<bool> registerJournal() async {
    var result = await widget.service.register(
      Journal(
          id: const Uuid().v1(),
          content: myController.text,
          createdAt: widget.journal.createdAt,
          updatedAt: widget.journal.updatedAt),
    );
    return result;
  }

  @override
  void initState() {
    super.initState();
    var logging = Logger();
    (widget.journal.content);
    if (widget.journal.content.isNotEmpty) {
      logging.i(widget.journal.content);
      myController.text = widget.journal.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(WeekDay(widget.journal.createdAt).toString()),
        actions: [
          IconButton(
            onPressed: () async {
              registerJournal().then(
                (value) {
                  if (value) {
                    Navigator.pop(context, true);
                  } else {
                    Navigator.pop(context, false);
                  }
                },
              );
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: TextFormField(
            controller: myController,
            keyboardType: TextInputType.multiline,
            style: const TextStyle(fontSize: 24),
            expands: true,
            maxLines: null,
            minLines: null,
          ),
        ),
      ),
    );
  }
}
