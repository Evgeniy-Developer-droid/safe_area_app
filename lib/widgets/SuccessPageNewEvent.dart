import 'package:flutter/material.dart';

class SuccessPageNewEvent extends StatelessWidget {
  bool created = false;
  SuccessPageNewEvent({
    Key? key,
    required this.created
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        // margin: EdgeInsets.only(top: 100, left: 20, right: 20),
        // height: MediaQuery.of(context).size.height - 100,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(created ? "Success!" : "Error",
                  style: TextStyle(
                      color: created ? Colors.green[500] : Colors.red,
                      fontSize: 30),)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(created ? "Event has been created." : "Something wrong. Please try again later", style: TextStyle(
                  fontSize: 17
                ),)
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(created)...[
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 100,
                  )
                ] else ...[
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 100,
                  )
                ]
              ],
            )
          ],
        ),
      ),
    );
  }
}
