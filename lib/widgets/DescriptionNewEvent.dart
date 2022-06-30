import 'package:flutter/material.dart';

class DescriptionNewEvent extends StatefulWidget {
  const DescriptionNewEvent({Key? key}) : super(key: key);

  @override
  State<DescriptionNewEvent> createState() => _DescriptionNewEventState();
}

class _DescriptionNewEventState extends State<DescriptionNewEvent> {
  String _description = "";

  @override
  Widget build(BuildContext context) {
    print(_description);
    return SafeArea(
        child: Column(
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 6,
              minLines: 6,
              onChanged: (value){
                setState((){
                  _description = value;
                });
              },
              decoration: InputDecoration(
                  labelText: 'Describe',
                  hintText: 'Write something about situation\n\n\n\n\n'),
            )
          ],
        )
    );
  }
}
