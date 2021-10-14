import 'package:flutter/material.dart';
import 'package:raktkhoj/Colors.dart';

import 'input_container.dart';

class RoundedPasswordInput extends StatelessWidget {
  const RoundedPasswordInput(
      { Key key,
         this.hint,
      }) : super(key: key);

  //final Size size;
  final String hint;
  @override
  Widget build(BuildContext context) {

    return InputContainer(
        child: TextField(
          cursorColor: kMainRed,
          obscureText: true,
          decoration: InputDecoration(
              icon: Icon(Icons.lock , color: kMainRed,),
              hintText: hint,
              border: InputBorder.none
          ),
        )
    );}
}

