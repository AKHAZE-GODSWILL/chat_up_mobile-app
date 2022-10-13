import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpScreen extends StatefulWidget{
    const OtpScreen({Key? key}) : super(key:key);

    State<OtpScreen> createState()=> _OtpScreen();

}

class _OtpScreen extends State<OtpScreen>{

  @override 
  Widget build(BuildContext context){

      return Scaffold(
        body: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[

                  Container(       
                    height: 50,
                    width: 55,
                    child: TextFormField(
                      
                      onChanged:(value){

                          if(value.length == 1){
                            FocusScope.of(context).nextFocus();
                          }
                      },
                      onSaved: (pin1){},
                      decoration: InputDecoration(hintText: "0"),
                      style: Theme.of(context).textTheme.headline6,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      )
                ),

                  Container(
                    height: 50,
                    width: 55,
                    child: TextFormField(
                      
                      onChanged:(value){

                          if(value.length == 1){
                            FocusScope.of(context).nextFocus();
                          }
                      },
                      onSaved: (pin1){},
                      decoration: InputDecoration(hintText: "0"),
                      style: Theme.of(context).textTheme.headline6,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      )
                ),

                  Container(
                    height: 50,
                    width: 55,
                    child: TextFormField(
                      
                      onChanged:(value){

                          if(value.length == 1){
                            FocusScope.of(context).nextFocus();
                          }
                      },
                      onSaved: (pin1){},
                      decoration: InputDecoration(hintText: "0"),
                      style: Theme.of(context).textTheme.headline6,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      )
                ),

                 Container(
                    height: 50,
                    width: 55,
                    child: TextFormField(
                      
                      onChanged:(value){

                          if(value.length == 1){
                            FocusScope.of(context).nextFocus();
                          }
                      },
                      onSaved: (pin1){},
                      decoration: InputDecoration(hintText: "0"),
                      style: Theme.of(context).textTheme.headline6,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],

                      
                      )
                ),

                  Container(
                    height: 50,
                    width: 55,
                    child: TextFormField(
                      
                      onChanged:(value){

                          if(value.length == 1){
                            FocusScope.of(context).nextFocus();
                          }
                      },
                      onSaved: (pin1){},
                      decoration: InputDecoration(hintText: "0"),
                      style: Theme.of(context).textTheme.headline6,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      )
                ),

                  Container(
                    height: 50,
                    width: 55,
                    child: TextFormField(
                      
                      onChanged:(value){

                          if(value.length == 1){
                            FocusScope.of(context).nextFocus();
                          }
                      },
                      onSaved: (pin1){},
                      decoration: InputDecoration(hintText: "0"),
                      style: Theme.of(context).textTheme.headline6,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      )
                ),
                ]
        ),
      );
  }
}

