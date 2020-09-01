import 'dart:convert';

import 'package:channab/dio/dio.dart';
import 'package:channab/pages/auth/dont_have_account_signin%20copy.dart';
import 'package:channab/pages/auth/otp_verification.dart';
import 'package:channab/shared/button.dart';
import 'package:channab/shared/common.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  
  String _mobileNumber = '';
  bool _submitting = false;
  bool _forgotPassErr = false;
  String _forgotPassErrMsg = '';

  void _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
    setState(() => _submitting = true);
      FormData formData = new FormData.fromMap({
        "mobile_number": _mobileNumber,
      });

      try{
        Response res = await dio.post('/forgot_password/', data: formData);
        print(res);
        Map<String, dynamic> data = jsonDecode(res.data);
        _forgotPassErrMsg = data['message'];
        // if(data['status'] == 100){
        //   _forgotPassErr = true;
        // }else{
          // Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=>OTP_Verification(nextRoute: '/resetpassword',) ));
        // }
      }catch(e){
        print('SIGNUP_ERROR');
        print(e.message);
        _forgotPassErr = true;
        _forgotPassErrMsg = 'Something went wrong! Please try again later.';
      }
      setState(() => _submitting = false);
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password', style: TextStyle(
          fontSize: 32,
          color: Colors.white
        ),),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: ListView(
                  children: [
                    Container(
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          Container(
                            width: PERCENT(screenWidth, 60),
                            height: 300,
                            child: Text('Enter your mobile number below to reset password', style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),textAlign: TextAlign.center,)
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: screenWidth,
                      height: PERCENT(screenHeight, 50),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        )
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: 'Mobile Number'
                              ),
                              onSaved: (v) => _mobileNumber = v
                            ),

                            _forgotPassErrMsg.length > 0 ? Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Center(
                                child: Text(_forgotPassErrMsg, style: TextStyle(
                                  fontSize: 14,
                                  // color: Colors.redAccent
                                ),textAlign: TextAlign.center,),
                              ),
                            ) : Container(),

                            SizedBox(height: PERCENT(screenHeight, 20)),

                            Container(
                              width: PERCENT(screenWidth, 60),
                              height: 50,
                              child: BUTTON(
                                text: 'Reset Password',
                                color: Theme.of(context).primaryColor,
                                borderRadius: 50.0,
                                fontSize: 18.0,
                                textColor: Colors.white,
                                submitting: _submitting,
                                onPressed: _submit
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}