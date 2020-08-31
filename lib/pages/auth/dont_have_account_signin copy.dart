import 'package:flutter/material.dart';

class DontHaveAccountSignUp extends StatelessWidget {
  var _signUpTextColor;
  DontHaveAccountSignUp({signUpTextColor = Colors.black}){
    _signUpTextColor = signUpTextColor;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Dont have an account?', style: TextStyle(
            color: Colors.grey[400],
            fontSize: 18
          ),),
          SizedBox(width: 10,),
          InkWell(
            child: Text('Sign Up', style: TextStyle(
              color: _signUpTextColor,
              fontSize: 18,
              decoration: TextDecoration.underline
            ),),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/signup');
            },
          ),
        ],
      ),
    );
  }
}