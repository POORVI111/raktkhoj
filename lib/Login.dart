//import 'dart:html';

import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:raktkhoj/Constants.dart';
import 'package:raktkhoj/components/rounded_button.dart';
import 'package:raktkhoj/components/rounded_input.dart';
import 'package:raktkhoj/components/rounded_password_input.dart';
import 'Colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  bool isLogin=true;
  late Animation<double> containerSize;
  late AnimationController animationController;
  Duration animationDuration=Duration(milliseconds: 270);

  @override
  void initState(){
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);

    animationController=AnimationController(vsync: this,duration: animationDuration);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    //we are using this to determine keyboard is opened or not
    double viewInset = MediaQuery
        .of(context)
        .viewInsets
        .bottom;

    double defaultLoginSize = size.height - (size.height * 0.2);
    double defaultRegisterSize = size.height - (size.height * 0.1);

    containerSize=Tween<double>(
        begin: size.height*0.1 ,
        end: defaultRegisterSize)
        .animate(CurvedAnimation(
        parent: animationController,
        curve: Curves.linear));
    return Scaffold(
        body: Stack(

          children: [

            //adding some decorations....
            Positioned(
              top: 100,
                right: -50,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: kMainRed,
                  ),
                ),
            ),

            Positioned(
              top: -50,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: kMainRed,
                ),
              ),
            ),

            //CANCEL BUTTON........
            AnimatedOpacity(
              opacity: isLogin ? 0.0 : 1.0,
              duration: animationDuration,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: size.width,
                  height: size.height*0.1,
                  alignment: Alignment.bottomCenter,

                  child: IconButton(
                    icon:Icon(Icons.close),
                    onPressed: isLogin ? null : (){ //returning null to disable the button
                      animationController.reverse();
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    color: kMainRed,
                  ),
                ),
              ),
            ),
            //LOGIN FORM.....
            AnimatedOpacity(
              opacity: isLogin ? 1.0 : 0.0,
              duration: animationDuration * 4,
              child: Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Container(
                    width: size.width,
                    height: defaultLoginSize,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Text(
                          "Welcome back!",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24
                          ),
                        ),

                        SizedBox(height: 40),

                        Container(
                          width: size.width * 0.8,
                          child: Image.asset("images/Login.png"),
                        ),
                        //new SvgPicture.asset('images/Login.svg'),

                        SizedBox(height: 40),

                        RoundedInput(icon: Icons.person,hint:'Username',),

                        RoundedPasswordInput(hint:'Password'),

                        SizedBox(height: 10,),

                        RoundedButton(title: 'LOGIN'),

                      ],

                    ),
                  ),
                ),
              ),
            ),

            //REGISTER CONTAINER......
            AnimatedBuilder(
              animation: animationController,
              builder: (context , child){
                if(viewInset == 0 && isLogin) {
                    return buildRegisterConatiner();
                  }else if(!isLogin){
                  return buildRegisterConatiner();
                }
                //returning an empty conatiner to hide widget
                return Container();
              },

            ),

            //REGISTER FORM GOES HERE ........
            AnimatedOpacity(
              opacity: isLogin ? 0.0 : 1.0,
              duration: animationDuration*5,
              child: Visibility(
                visible: !isLogin,
                child: Align(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Container(
                      width: size.width,
                      height: defaultRegisterSize,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Text(
                            "Welcome !",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24
                            ),
                          ),

                          SizedBox(height: 5),

                          Container(
                            width: size.width * 0.6,
                            child: Image.asset("images/Login.png"),
                          ),
                          //new SvgPicture.asset('images/Login.svg'),

                          SizedBox(height: 5),

                          RoundedInput(icon: Icons.person,hint:'Username',),

                          RoundedInput(icon: Icons.mail,hint:'Email',),

                          RoundedPasswordInput(hint:'Password'),
                          Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                        width: size.width*0.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: kMainRed.withAlpha(50)
                        ),
                          child: DropDownField(
                              controller: bgroup,
                              itemsVisibleInDropdown: 1,
                              icon: Icon(Icons.bloodtype,color: kMainRed,),
                              hintText: "Blood Group",
                              hintStyle: TextStyle(color: kDarkerGrey , fontSize: 10, ),
                              enabled: true,
                            items: bloodGroups,
                            onValueChanged: (value){
                                setState(() {
                                  selectGroup=value;
                                });
                            },
                          ),
                      ),

                          SizedBox(height: 10,),

                          RoundedButton(title: 'SIGNUP'),

                        ],

                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }


  Widget buildRegisterConatiner()
  {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: containerSize.value,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(100),
              topRight:Radius.circular(100),
            ),
            color: kBackgroundColor
        ),
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: !isLogin ? null : (){
            animationController.forward();

            setState(() {
              isLogin= !isLogin;
            });
          },
          child: isLogin ? Text(
            "Don't have an account? Sign up",
            style: TextStyle(
              color: kMainRed,
              fontSize: 18,
            ),
          ) : null,
        ),
      ),
    );
  }

}

String selectGroup="";
final bgroup=TextEditingController();
//creating a list of blood groups

List<String> bloodGroups=[
  "A+",
  "A-",
  "O+",
  "O-",
  "B-",
  "B+",
  "AB-",
  "AB+"
];

