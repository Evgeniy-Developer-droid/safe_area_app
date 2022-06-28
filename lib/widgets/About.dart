import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'dart:async';

const aboutDescription = '''
Welcome to our App! The app is intended for everyone who cares about their safety. On the app you can get acquainted with an interactive map that displays recent events and the situation around you. You can also create an event and thereby warn others about a danger or inform about a situation. All events you create are completely anonymous. For any questions, you can contact me using the Linkedin social network or using the contact form on the website. Thank you for your visit! Take care of yourself!
''';
final Uri _url_website = Uri.parse('https://safe-area.com.ua');
final Uri _url_linkedin = Uri.parse('https://www.linkedin.com/in/evgeny-grinchak/');

void _launchUrlLinkedin() async {
  if (!await launchUrl(_url_linkedin)) throw 'Could not launch linkedin';
}

void _launchUrlWebsite() async {
  if (!await launchUrl(_url_website)) throw 'Could not launch website';
}

class AboutView extends StatelessWidget {
  const AboutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height - 85,
          child: ListView(
            children: <Widget>[
              const Text('About', style: TextStyle(
                fontSize: 30,
              ),),
              Container(
                height: 12,
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                decoration: const BoxDecoration(
                  color: Color(0xFF00F6FF),
                  borderRadius: BorderRadius.all(
                      Radius.circular(10)
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF00F6FF),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
              ),
              const Text(aboutDescription, style: TextStyle(
                  fontSize: 17,
                  height: 1.2
              ),),
              Container(
                height: 40,
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                    color: Color(0xFF001B8A),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF001B8A),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: Offset(0, 0),
                      )
                    ]
                ),
                child: Center(
                  child: GestureDetector(
                    onTap: _launchUrlLinkedin,
                    child: const Text(
                      'Linkedin',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: "Netflix",
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        letterSpacing: 0.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                height: 40,
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                    color: Color(0xFF00E7FF),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF00E7FF),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: Offset(0, 0),
                      )
                    ]
                ),
                child: Center(
                  child: GestureDetector(
                    onTap: _launchUrlWebsite,
                    child: const Text(
                      'Website',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: "Netflix",
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        letterSpacing: 0.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
