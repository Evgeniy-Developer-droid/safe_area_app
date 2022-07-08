import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../tools/NewEventData.dart';

class DescriptionNewEvent extends StatefulWidget {
  const DescriptionNewEvent({Key? key}) : super(key: key);

  @override
  State<DescriptionNewEvent> createState() => _DescriptionNewEventState();
}

class _DescriptionNewEventState extends State<DescriptionNewEvent> {
  final TextEditingController _controller = new TextEditingController();
  var _needToUpdate = true;

  @override
  Widget build(BuildContext context) {
    if(_needToUpdate){
      _controller.text = context.watch<NewEventData>().getDescriptionNewEvent;
      _needToUpdate = false;
    }
    return SafeArea(
        child: Column(
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 6,
              minLines: 6,
              controller: _controller,
              onChanged: (value){
                context.read<NewEventData>().changeDescription(value);
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
