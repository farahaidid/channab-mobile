import 'package:flutter/material.dart';

Widget BUTTON({color, text, onPressed, textColor = Colors.black, submitting = false , borderRadius = 10.0, fontSize = 14.0, elevation = 1.0}){
  return new RaisedButton(
    elevation: elevation,
    color: color,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    child: Center(
      child: submitting ? SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator( strokeWidth: 2,),
      ) : Text(
        text, 
        style: TextStyle(
          color: textColor,
          fontSize: fontSize
        ),
      ),
    ),
    
    onPressed: submitting ? null : onPressed,
  );
}