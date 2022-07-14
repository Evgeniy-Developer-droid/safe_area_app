import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_area_app/widgets/ButtonsNewEvent.dart';
import 'package:safe_area_app/widgets/MapNewEvent.dart';
import 'package:safe_area_app/widgets/DescriptionNewEvent.dart';
import 'package:safe_area_app/widgets/TypeSituationNewEvent.dart';
import 'package:safe_area_app/widgets/MediaNewEvent.dart';

import '../tools/NewEventData.dart';
import '../widgets/SuccessPageNewEvent.dart';

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

  bool created = false;

  Widget getBody(){
    if(_selectedStep == 0){
      return _getMap;
    } else if(_selectedStep == 1) {
      return _getTypeSituation;
    }else if(_selectedStep == 2) {
      return _getMedia;
    }else if(_selectedStep == 3) {
      return _getDescription;
    } else {
      return SuccessPageNewEvent(created: created,);
    }
  }

  void changeStep(action){
    if(action == "inc"){
      setState((){
        _selectedStep += 1;
      });
    }else{
      setState((){
        _selectedStep -= 1;
      });
    }
  }
  void createdChange(val){
    setState((){
      created = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NewEventData>(
        create:(context)=> NewEventData(),
      child: Container(
        // resizeToAvoidBottomInset: false,
        child: Column(
          children: [
            if(_selectedStep < 4)...[
              Container(
                height: MediaQuery.of(context).size.height - 200,
                child: getBody(),
              ),
              ButtonsNewEvent(
                step: _selectedStep,
                changeStep: changeStep,
                changeCreated: createdChange,
              ),
              _getPointBar()
            ] else ...[
              getBody()
            ]
          ],
        ),
      ),
    );
  }

  // Container _getButtons(){
  //   return Container(
  //     padding: const EdgeInsets.only(top: 10, bottom: 10),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: [
  //         if(_selectedStep == 0)...[
  //           _getNextButton()
  //         ]else if(_selectedStep > 0 && _selectedStep < 3)...[
  //           _getPrevButton(),
  //           _getNextButton()
  //         ] else ...[
  //           _getPrevButton(),
  //           _getCreateButton()
  //         ]
  //       ],
  //     ),
  //   );
  // }
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

}

