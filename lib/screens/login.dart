/*
login register screen animated together
 */

import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:raktkhoj/components/input_container.dart';
import 'package:raktkhoj/components/register_button.dart';
import '../colors.dart';
import '../components/login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  bool isLogin=true;
   Animation<double> containerSize;
   AnimationController animationController;
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
                    onPressed: () async { //returning null to disable the button
                     // await animationController.reverse(from: 0.0);
                      await animationController.reverse();
                     // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                      setState(() {
                        isLogin = true;
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
                          "Welcome back!".tr,
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

                        InputContainer(
                          child: TextField(
                            onChanged: (value) {
                              email=value;
                            },
                            cursorColor: kMainRed,
                            decoration: InputDecoration(
                                icon: Icon(Icons.mail , color: kMainRed,),
                                hintText: 'Email'.tr,
                                border: InputBorder.none
                            ),
                          ),
                        ),

                       // RoundedInput(icon: Icons.person,hint:'Username',),

                        InputContainer(
                          child: TextField(
                            cursorColor: kMainRed,
                            obscureText: true,
                            onChanged: (value){
                              password=value;
                            },
                            decoration: InputDecoration(
                                icon: Icon(Icons.lock , color: kMainRed,),
                                hintText: 'Password'.tr,
                                border: InputBorder.none
                            ),
                          ),
                        ),

                        //RoundedPasswordInput(hint:'Password'),

                        SizedBox(height: 10,),

                        LoginButton(title: 'LOGIN'.tr,userEmail : email , userPassword : password),

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
                            "Welcome !".tr,
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

                          InputContainer(
                            child: TextField(
                              onChanged: (value) {
                                userName=value;
                              },
                              cursorColor: kMainRed,
                              decoration: InputDecoration(
                                  icon: Icon(Icons.person , color: kMainRed,),
                                  hintText: 'Username'.tr,
                                  border: InputBorder.none
                              ),
                            ),
                          ),

                          //RoundedInput(icon: Icons.person,hint:'Username',),
                          InputContainer(
                            child: TextField(
                              onChanged: (value) {
                                email=value;
                              },
                              cursorColor: kMainRed,
                              decoration: InputDecoration(
                                  icon: Icon(Icons.mail , color: kMainRed,),
                                  hintText: 'Email'.tr,
                                  border: InputBorder.none
                              ),
                            ),
                          ),

                          /*TextField(
                            onChanged: (value) {
                              email=value;
                            },
                            cursorColor: kMainRed,
                            decoration: InputDecoration(
                                icon: Icon(Icons.mail , color: kMainRed,),
                                hintText: 'Email',
                                border: InputBorder.none
                            ),
                          ),*/
                          //RoundedInput(icon: Icons.mail,hint:'Email',),
                          InputContainer(
                            child: TextField(
                              cursorColor: kMainRed,
                              obscureText: true,
                              onChanged: (value){
                                password=value;
                              },
                              decoration: InputDecoration(
                                  icon: Icon(Icons.lock , color: kMainRed,),
                                  hintText: 'Password'.tr,
                                  border: InputBorder.none
                              ),
                            ),
                          ),


                          //RoundedPasswordInput(hint:'Password'),
                          Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                        width: size.width*0.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: kMainRed.withAlpha(50)
                        ),
                          //dropdown list for choosing blood group along with search feature
                          child: DropDownField(
                              controller: bgroup,
                              itemsVisibleInDropdown: 1,
                              icon: Icon(Icons.bloodtype,color: kMainRed,),
                              hintText: "Blood Group".tr,
                              hintStyle: TextStyle(color: kDarkerGrey , fontSize: 10, ),
                              enabled: true,
                            items: bloodGroups,
                            onValueChanged: (value){
                                bloodGroup=value;
                                setState(() {
                                  selectGroup=value;
                                });
                            },
                          ),
                      ),

                          SizedBox(height: 10,),
                           RegisterButton(title: 'SIGNUP'.tr , userEmail:email ,
                               userUserName: userName,userBloodGroup: bloodGroup,
                               userPassword: password),

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

//register container starts here
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
            "Don't have an account? Sign up".tr,
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

 String email="";
String password="";
 String userName="";
 String bloodGroup="";
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

