import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../tools/NewEventData.dart';

class TypeSituationNewEvent extends StatefulWidget {
  const TypeSituationNewEvent({Key? key}) : super(key: key);

  @override
  State<TypeSituationNewEvent> createState() => _TypeSituationNewEventState();
}
enum SingingCharacter { murder, accident, fight, theft, shooting, other }

class _TypeSituationNewEventState extends State<TypeSituationNewEvent> {
  SingingCharacter? _character = SingingCharacter.other;

  void changeSituation(value){
    context.read<NewEventData>().changeTypeOfSituation(value.toString().split('.').last);
  }

  @override
  Widget build(BuildContext context) {
    String initTypeOfSituation = context.watch<NewEventData>().getTypeOfSituationNewEvent;
    print(initTypeOfSituation);
    _character = SingingCharacter.values.firstWhere((e) => e.toString().split('.').last == initTypeOfSituation);
    return SafeArea(
        child: Container(
          child: Column(
            children: [
              RadioListTile<SingingCharacter>(
                title: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.red,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width:10,
                    ),
                    Text('Murder')
                  ],
                ),
                value: SingingCharacter.murder,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  changeSituation(value);
                },
              ),
              RadioListTile<SingingCharacter>(
                title: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.blueAccent,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width:10,
                    ),
                    Text('Accident')
                  ],
                ),
                value: SingingCharacter.accident,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  changeSituation(value);
                },
              ),
              RadioListTile<SingingCharacter>(
                title: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.amberAccent,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amberAccent.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width:10,
                    ),
                    Text('Fight')
                  ],
                ),
                value: SingingCharacter.fight,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  changeSituation(value);
                },
              ),
              RadioListTile<SingingCharacter>(
                title: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.cyanAccent,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyanAccent.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width:10,
                    ),
                    Text('Theft')
                  ],
                ),
                value: SingingCharacter.theft,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  changeSituation(value);
                },
              ),
              RadioListTile<SingingCharacter>(
                title: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.green,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width:10,
                    ),
                    Text('Shooting')
                  ],
                ),
                value: SingingCharacter.shooting,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  changeSituation(value);
                },
              ),
              RadioListTile<SingingCharacter>(
                title: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width:10,
                    ),
                    Text('Other')
                  ],
                ),
                value: SingingCharacter.other,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  changeSituation(value);
                },
              ),
            ],
          ),
        )
    );
  }
}
