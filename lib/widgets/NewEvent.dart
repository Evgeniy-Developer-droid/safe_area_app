import 'package:flutter/material.dart';
import 'package:safe_area_app/widgets/MapNewEvent.dart';
import 'package:safe_area_app/tools/CheckBoxState.dart';

class NewEvent extends StatefulWidget {
  const NewEvent({Key? key}) : super(key: key);

  @override
  State<NewEvent> createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {
  bool _checked = false;

  final eventTypes = [
    CheckBoxState(title: "Murder"),
    CheckBoxState(title: "Accident"),
    CheckBoxState(title: "Fight"),
    CheckBoxState(title: "Theft"),
    CheckBoxState(title: "Shooting"),
    CheckBoxState(title: "Other"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
        ],
      ),
    );
  }
}

