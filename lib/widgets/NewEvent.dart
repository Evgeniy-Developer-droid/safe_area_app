import 'package:flutter/material.dart';
import 'package:safe_area_app/widgets/MapNewEvent.dart';
import 'package:safe_area_app/widgets/DescriptionNewEvent.dart';
import 'package:safe_area_app/widgets/TypeSituationNewEvent.dart';
import 'package:safe_area_app/widgets/MediaNewEvent.dart';

class NewEvent extends StatefulWidget {
  const NewEvent({Key? key}) : super(key: key);

  @override
  State<NewEvent> createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {
  int _selectedStep = 0;
  Widget _getMap = MapNewEvent();
  Widget _getTypeSituation = TypeSituationNewEvent();
  Widget _getDescription = DescriptionNewEvent();
  Widget _getMedia = MediaNewEvent();

  Widget getBody(){
    if(_selectedStep == 0){
      return _getMap;
    } else if(_selectedStep == 1) {
      return _getTypeSituation;
    }else if(_selectedStep == 2) {
      return _getMedia;
    }else{
      return _getDescription;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 200,
            child: getBody(),
          ),
          _getButtons(),
          _getPointBar()
        ],
      ),
    );
  }

  Container _getButtons(){
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if(_selectedStep == 0)...[
            _getNextButton()
          ]else if(_selectedStep > 0 && _selectedStep < 3)...[
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
  Container _getPointBar(){
    return Container(
      width: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 5,
            width: 5,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: _selectedStep == 0 ? Colors.white : Colors.deepPurple
            ),
          ),
          Container(
            height: 5,
            width: 5,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: _selectedStep == 1 ? Colors.white : Colors.deepPurple
            ),
          ),
          Container(
            height: 5,
            width: 5,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: _selectedStep == 2 ? Colors.white : Colors.deepPurple
            ),
          ),
          Container(
            height: 5,
            width: 5,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: _selectedStep == 3 ? Colors.white : Colors.deepPurple
            ),
          ),
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
        setState((){
          _selectedStep -= 1;
        });
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
        setState((){
          _selectedStep += 1;
        });
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
      onPressed: (){},
    );
  }

}

