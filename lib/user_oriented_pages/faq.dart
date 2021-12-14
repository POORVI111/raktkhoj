import 'package:flutter/material.dart';

class FAQ extends StatefulWidget {
  @override
  _FAQState createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  tileMode: TileMode.mirror,
                  begin: Alignment.topRight,
                  end: Alignment.topLeft,

                  colors: <Color>[
                    Color(0xFFE53033),Color(0xFFBC002D),
                  ])
          ),
        ),
        title: Text("Information Guide",style: TextStyle(fontFamily: 'nunito'),),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:20,left: 20,right: 20),
              child: Text("Who can I donate to?",style: TextStyle(fontFamily: 'nunito',fontSize: 16,fontWeight: FontWeight.bold),),
            ),

            Padding(
              padding: const EdgeInsets.only(top:8,left: 20,right: 20),
              child: Text("A patient can receive blood that has the same ABO antigens as theirs, plus O. Rh+ can receive Rh+ or Rh-, while Rh- must receive Rh- blood. Here is a table of compatible blood types:",style: TextStyle(fontFamily: 'nunito',fontSize: 14,fontWeight: FontWeight.w400),),
            ),
            Padding(
              padding: const EdgeInsets.only(top:20.0,bottom: 10,left: 8,right: 20),
              child: Container(
                child: new Image.asset('images/table1.png',width:330,height:200),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:8,left: 20,right: 20),
              child: Text("Who can give blood?",style: TextStyle(fontFamily: 'nunito',fontSize: 16,fontWeight: FontWeight.bold),),
            ),

            Padding(
              padding: const EdgeInsets.only(top:8,left: 20,right: 20),
              child: Text("Almost anyone who is healthy, at least 16 years old, and weighs at least 110 pounds. (16-year-olds must weigh at least 130 lbs and need signed parental consent.)",style: TextStyle(fontFamily: 'nunito',fontSize: 14,fontWeight: FontWeight.w400),),
            ),
            Padding(
              padding: const EdgeInsets.only(top:20,left: 20,right: 20),
              child: Text("How much blood is drawn?",style: TextStyle(fontFamily: 'nunito',fontSize: 16,fontWeight: FontWeight.bold),),
            ),

            Padding(
              padding: const EdgeInsets.only(top:8,left: 20,right: 20),
              child: Text("One pint. The average person has 10-12 pints, so the small loss is easily afforded. The fluid (plasma) is replaced within 24 hours. The red cells take about five weeks. You can donate again in eight weeks!",style: TextStyle(fontFamily: 'nunito',fontSize: 14,fontWeight: FontWeight.w400),),
            ),
            Padding(
              padding: const EdgeInsets.only(top:20,left: 20,right: 20),
              child: Text('Who needs blood transfusions?',style: TextStyle(fontFamily: 'nunito',fontSize: 16,fontWeight: FontWeight.bold),),
            ),

            Padding(
              padding: const EdgeInsets.only(top:8,left: 20,right: 20),
              child: Text('A wide variety of patients receive blood transfusions. The various components of donated blood are used to treat different conditions ranging from replenishing lost blood to platelet transfusions for Cancer patients',style: TextStyle(fontFamily: 'nunito',fontSize: 14,fontWeight: FontWeight.w400),),
            ),
            Padding(
              padding: const EdgeInsets.only(top:20,left: 20,right: 20),
              child: Text('Is donating blood safe?',style: TextStyle(fontFamily: 'nunito',fontSize: 16,fontWeight: FontWeight.bold),),
            ),

            Padding(
              padding: const EdgeInsets.only(top:8,left: 20,right: 20),
              child: Text('Absolutely. Blood donation conditions are sanitary, and needles are sterile and disposable.',style: TextStyle(fontFamily: 'nunito',fontSize: 14,fontWeight: FontWeight.w400),),
            ),
            Padding(
              padding: const EdgeInsets.only(top:20,left: 20,right: 20),
              child: Text('What should I do to prepare for donating?',style: TextStyle(fontFamily: 'nunito',fontSize: 16,fontWeight: FontWeight.bold),),
            ),

            Padding(
              padding: const EdgeInsets.only(top:8,left: 20,right: 20),
              child: Text('Eat a well-balanced meal, free of fatty or fried foods. A diet that regularly includes iron-rich foods will help promote red cell regeneration, increasing your chances of having an adequate hemoglobin level for blood donation.',style: TextStyle(fontFamily: 'nunito',fontSize: 14,fontWeight: FontWeight.w400),),
            ),
            Padding(
              padding: const EdgeInsets.only(top:20,left: 20,right: 20),
              child: Text('Blood Compatability',style: TextStyle(fontFamily: 'nunito',fontSize: 16,fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: const EdgeInsets.only(top:10.0,bottom: 10,left: 20,right: 20),
              child: Container(
                child: new Image.asset('images/table2.png',width:340,height:250),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
