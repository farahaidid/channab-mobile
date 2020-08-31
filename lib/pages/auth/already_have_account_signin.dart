import 'package:flutter/material.dart';

class AlreadyHaveAccountSignIn extends StatelessWidget {
  var _signInTextColor;
  AlreadyHaveAccountSignIn({signInTextColor = Colors.black}){
    _signInTextColor = signInTextColor;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Already have an account?', style: TextStyle(
            color: Colors.grey[400],
            fontSize: 18
          ),),
          SizedBox(width: 10,),
          InkWell(
            child: Text('Sign In', style: TextStyle(
              color: _signInTextColor,
              fontSize: 18,
              decoration: TextDecoration.underline
            ),),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/signin');
            },
          ),
        ],
      ),
    );
  }
}