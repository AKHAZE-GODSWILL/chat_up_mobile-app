import 'package:flutter/material.dart';

class MessageItem extends StatelessWidget {
  MessageItem({ Key? key, required this.sentByMe, required this.message }) : super(key: key);


  Color purple = Color(0xFF6c5ce7);
  Color black = Color(0xFF191919);
  Color white = Colors.white;

  final bool sentByMe;
  final String message;
  @override
  Widget build(BuildContext context) {
    
    return Align(
      
      alignment: sentByMe?Alignment.centerRight: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: sentByMe? purple: Colors.white,
        ),
        
        child: Row(
    
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
    
            Text(message,
    
             style: TextStyle(
              fontSize: 18,
              color: sentByMe? white: purple
             ),),
    
            SizedBox(width: 5,),
            Text("1:10 am",
            
            style: TextStyle(
              fontSize: 10,
              color: (sentByMe? white: purple).withOpacity(0.7)
             ),
            ),
          ],
        ),
      ),
    );
  }
}