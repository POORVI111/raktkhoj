import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:raktkhoj/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';


class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int _current=0;
  //adding three images animation when user first time opens the app
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 206,
              width: double.infinity,
              child: CarouselSlider(
                items: imageSliders,
                options: CarouselOptions(
                    height: 580.0,
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imgList.map((url) {
                int index = imgList.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? kMainRed
                        : Color(0xffc4c4c4),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 18,),
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: kLightGrey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 29,
                  ),
                  Text(
                    'Get started now'.tr,
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Color(0xff292929)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 7,left: 30),
                          child: InkWell(
                            onTap: (){

                             Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginScreen()),
                              );
                            },
                            child: Container(
                                height: 48,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                    Border.all(width: 1, color: kMainRed),
                                    color: Colors.transparent),
                                child: Center(
                                  child: Text('Sign In'.tr,
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: kMainRed,
                                      )),
                                )),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 30,left: 7),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                            },
                            child: Container(
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  //border: Border.all(width:1, color:Colors.white24),
                                  color: kMainRed,
                                ),
                                child: Center(
                                  child: Text('Create Account'.tr,
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Colors.white,
                                        //letterSpacing: 1
                                      )),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'v0.9.123(391)',
                    style: GoogleFonts.lato(
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                        color: Colors.white.withOpacity(0)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final List<String> imgList = [
  'images/Frame 1.png',
  'images/Frame 2.png',
  'images/Frame 3.png',
];


final List<Widget> imageSliders = imgList
    .map((item) => Container(
  child: Container(
    margin: EdgeInsets.all(5.0),
    child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    '$item',
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        )),
  ),
))
    .toList();