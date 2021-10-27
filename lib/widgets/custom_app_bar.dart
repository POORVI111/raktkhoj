import 'package:flutter/material.dart';
import 'package:raktkhoj/Colors.dart';

class CustomAppBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.only(
        top: MediaQuery
            .of(context)
            .padding
            .top,
        right: 5.0,
      ),
      child: new Row(
        children: [
          new Expanded(flex: 3,
            child: new Row(
            children: <Widget>[
              Material(
                child: IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(Icons.arrow_back_ios)),
              ),
              new Expanded(
                child: new Text(
                    'DONATIONS',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 21.0,
                        color: kMainRed,
                        //fontFamily: 'Dosis',
                        //fontWeight: FontWeight.w600
                    )),
              ),
            ],
          ),
          ),
          Material(
            child: new IconButton(
              tooltip: 'Shopping Cart',
              icon: new Icon(const IconData(0xe807, fontFamily: 'fontello'),
                  color: Colors.black87),
              onPressed: null,
            ),
          ),
        ],
      ),
    );
  }
}