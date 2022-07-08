import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_area_app/pages/HomePage.dart';
import 'package:safe_area_app/tools/NewEventData.dart';
import 'package:safe_area_app/pages/About.dart';
import 'package:safe_area_app/pages/NewEvent.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  Widget _home = HomePage();
  Widget _newEvent = NewEvent();
  Widget _aboutSA = AboutView();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  Widget getBody(){
    if(_selectedIndex == 0){
      return _home;
    }else if(_selectedIndex == 1){
      return _newEvent;
    }else{
      return _aboutSA;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        home: Scaffold(
          body: getBody(),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_location_alt),
                label: 'Add Event',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.info),
                label: 'About',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: const Color(0xFF00F6FF),
            onTap: _onItemTapped,
          ),
        ),
    );
  }
}
