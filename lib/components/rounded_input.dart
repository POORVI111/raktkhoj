import 'package:flutter/material.dart';
import 'package:raktkhoj/colors.dart';

import 'input_container.dart';

class RoundedInput extends StatelessWidget {
  const RoundedInput(
      { Key key,
        //required this.size,
         this.icon, this.hint
        //required this.hint
      }) : super(key: key);

  //final Size size;
  final IconData icon;
  final String hint;


  @override
  Widget build(BuildContext context) {

    return InputContainer(
        child: TextField(

        cursorColor: kMainRed,
        decoration: InputDecoration(
        icon: Icon(icon , color: kMainRed,),
        hintText: hint,
        border: InputBorder.none
        ),
    ),);
  }





}

