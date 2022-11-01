import 'package:chat_up/screens/auth/SignUp.dart';
import 'package:chat_up/screens/auth/onBoarding/onBoard1.dart';
import 'package:chat_up/screens/auth/onBoarding/onBoard2.dart';
import 'package:chat_up/screens/auth/onBoarding/onBoard3.dart';
import 'package:chat_up/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



//DJEMERHOMU MIIRAROSUE
//ONBOARDING SCREEN

class MyOnboarding extends StatefulWidget {
  const MyOnboarding({Key? key}) : super(key: key);

  @override
  _MyOnboardingState createState() => _MyOnboardingState();
}

class _MyOnboardingState extends State<MyOnboarding> {
  List<Widget> slides = <Widget>[];
  int currentIndex = 0;
  PageController? _controller;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 58),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
              // const SizedBox(height: 36),

              Expanded(
                child: PageView(
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                controller: pageController,
                onPageChanged: (value) {
                  setState(() {
                    currentIndex = value;
                  });
                  print(currentIndex);
                },
                children: [
                    FirstOnBoard(),
              
                    SecondOnBoard(),
              
                    ThirdOnBoard(),
                ],
              )),
              const SizedBox(height: 40),
              Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                         3 , (index) => buildDot(index, context)))),
              const SizedBox(height: 20),

              Text("Terms and privacy policy"),

              const SizedBox(height: 20),

              currentIndex == 2
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: GestureDetector(
                
                onTap: (){

                    Navigator.push(context,MaterialPageRoute(
                      builder: (context)=> SignUp()
                    ));

                },

                child: Container(

                  width: 327,
                  height:52,
                  decoration: BoxDecoration(

                    color: Constants().purple,
                    borderRadius: BorderRadius.circular(30)
                  ),

                  child: Center(child: Text("Start messaging",
                  
                          style: TextStyle(
                            color: Colors.white
                          ))),
                )),
                    )
                  : Padding(
                      padding:
                          const EdgeInsets.only(bottom: 30, right: 30, top: 25),
                      child: GestureDetector(
                        child: const Align(
                          alignment: Alignment.centerRight,
                          child: Text("Skip",
                              style: TextStyle(color: Color(0xff23054B))),
                        ),
                        onTap: () async {
                          skip();
                        },
                      ),
                    )

              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [

              //     GestureDetector(
              //       child: Container(
              //         height: 40,
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(10),
              //           color: Colors.white,
              //         ),
              //         child: const Padding(
              //           padding: EdgeInsets.symmetric(horizontal: 70.0, vertical: 10),
              //           child: Text("Skip", style: TextStyle(color: Color(0xff23054B))),
              //         ),
              //       ),
              //       onTap: ()async{
              //         skip();
              //       },
              //     ),
              //     const SizedBox(height: 30),
              //   ],
              // )
          //   ],
          // ),
        ],
      ),
    );
  }

  void skip() {
    // getX.write(constants.GETX_IS_NOT_FIRST_TIME, true);
    Navigator.pushReplacement(context, CupertinoPageRoute(builder: (_) =>  SignUp()));
  }

  AnimatedContainer buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: 8,
      width: currentIndex == index ? 25 : 10,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: currentIndex == index
              ? const Color.fromRGBO(10, 16, 52, 1)
              : const Color.fromRGBO(215, 216, 233, 1)),
    );
  }
}
