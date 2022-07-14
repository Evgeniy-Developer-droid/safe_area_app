import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../tools/NewEventData.dart';

class ButtonsNewEvent extends StatefulWidget {
  int step = 0;
  final ValueSetter changeStep;
  final ValueSetter changeCreated;
  ButtonsNewEvent({Key? key, required this.step, required this.changeStep, required this.changeCreated}) : super(key: key);

  @override
  State<ButtonsNewEvent> createState() => _ButtonsNewEventState();
}

class _ButtonsNewEventState extends State<ButtonsNewEvent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if(widget.step == 0)...[
            _getNextButton()
          ]else if(widget.step  > 0 && widget.step  < 3)...[
            _getPrevButton(),
            _getNextButton()
          ] else ...[
            _getPrevButton(),
            _getCreateButton()
          ]
        ],
      ),
    );
  }
  ElevatedButton _getPrevButton(){
    return ElevatedButton(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        children: [
          Icon(
            Icons.navigate_before,
            color: Colors.black,
          ),
          SizedBox(
            width:10,
          ),
          Text("Prev Step", style: TextStyle(color: Colors.black, fontSize: 17),)
        ],
      ),
      style:  ElevatedButton.styleFrom(
        primary: Color(0xFF60439B),
      ),
      onPressed: (){
        widget.changeStep('dec');
      },
    );
  }
  ElevatedButton _getNextButton(){
    return ElevatedButton(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        children: [
          Text("Next Step", style: TextStyle(color: Colors.black, fontSize: 17)),
          SizedBox(
            width:10,
          ),
          Icon(
            Icons.navigate_next,
            color: Colors.black,
          )
        ],
      ),
      style:  ElevatedButton.styleFrom(
          primary: Color(0xFF60439B)
      ),
      onPressed: (){
        widget.changeStep('inc');
      },
    );
  }
  ElevatedButton _getCreateButton(){
    return ElevatedButton(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        children: [
          Text("Create", style: TextStyle(color: Colors.black, fontSize: 17)),
          SizedBox(
            width:10,
          ),
          Icon(
            Icons.add_circle_outline,
            color: Colors.black,
          )
        ],
      ),
      style:  ElevatedButton.styleFrom(
          primary: Color(0xFF9E00F1)
      ),
      onPressed: () async {
        bool result = await context.read<NewEventData>().createNewEvent();
        setState((){
          widget.changeCreated(result);
          widget.changeStep('inc');
        });
      },
    );
  }
}
