import 'dart:convert';

import 'package:channab/dio/dio.dart';
import 'package:channab/pages/auth/already_have_account_signin.dart';
import 'package:channab/pages/auth/otp_verification.dart';
import 'package:channab/shared/button.dart';
import 'package:channab/shared/common.dart';
import 'package:channab/store/store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String _firstName = '';
  String _lastName = '';
  String _mobileNumber = '';
  String _password = '';
  bool _hidePass = true;
  bool _submitting = false;
  bool _signupErr = false;
  String _signupErrMsg = '';

  void _signup() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      String formattedMobileNumber = _mobileNumber;
      // if(_mobileNumber.startsWith('0092')){
      //   formattedMobileNumber = _mobileNumber.substring(2);
      // }else if(_mobileNumber.startsWith('92')){
      //   formattedMobileNumber = '92' + _mobileNumber.substring(2);
      // }else if(_mobileNumber.startsWith('0')){
      //   formattedMobileNumber = '92' + _mobileNumber.substring(1);
      // }else{
      //   formattedMobileNumber = _mobileNumber;
      // }

      print(formattedMobileNumber);
      setState(() => _submitting = true);
      FormData formData = new FormData.fromMap({
        "mobile_number": formattedMobileNumber,
        "password": _password,
      });

      try{
        Response res = await dio.post('/register/', data: formData);
        Map<String, dynamic> data = jsonDecode(res.data);
        if(data['user_id'] == null){
          _signupErr = true;
          _signupErrMsg = data['message'];
        }else{
          Store.setToken(data['token']);
          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => OTP_Verification(nextRoute: '/signin') ));
        }
      }catch(e){
        print('SIGNUP_ERROR');
        print(e.message);
        _signupErr = true;
        _signupErrMsg = 'Something went wrong! Please try again later.';
      }
      setState(() => _submitting = false);

    }
    // Navigator.pushReplacementNamed(context, '/createpin');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account', style: TextStyle(
          fontSize: 32,
          color: Colors.white
        ),),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: ListView(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      width: screenWidth,
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          Container(
                            width: PERCENT(screenWidth, 60),
                            height: 300,
                            child: Image.asset('lib/assets/images/user-registration.png')
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: screenWidth,
                      // height: PERCENT(screenHeight, 50),
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
                            // TextFormField(
                            //   decoration: InputDecoration(
                            //     labelText: 'First Name'
                            //   ),
                            //   onSaved: (v) => _firstName = v
                            // ),
                            // TextFormField(
                            //   decoration: InputDecoration(
                            //     labelText: 'Last Name'
                            //   ),
                            //   onSaved: (v) => _lastName = v
                            // ),
                            TextFormField(
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: 'Mobile Number'
                              ),
                              onSaved: (v) => _mobileNumber = v.trim(),
                              validator: (v){
                                String mobile = v.trim();
                                if(mobile.length == 0) return 'Required';
                                // if(
                                //   mobile.length < 11 
                                //   || mobile.length > 14 
                                //   || ((mobile.startsWith('0092')) && mobile.length != 14)
                                //   || ((mobile.startsWith('92')) && mobile.length != 12)
                                //   || (!mobile.startsWith('0092') && mobile.startsWith('0') && mobile.length > 11)
                                // ) return 'Invalid Mobile Number';
                                return null;
                              },
                            ),
                            TextFormField(
                              obscureText: _hidePass,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                suffixIcon: InkWell(
                                  child: _hidePass == true ? Icon( Icons.visibility_off, size: 20.0, ) : Icon( Icons.visibility, size: 20.0, ),
                                  onTap: () => setState(() => _hidePass = !_hidePass),
                                ),
                              ),
                              onSaved: (v) => _password = v
                            ),

                            _signupErr ? Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Center(
                                child: Text(_signupErrMsg, style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.redAccent
                                ),textAlign: TextAlign.center,),
                              ),
                            ) : Container(),

                            SizedBox(height: PERCENT(screenHeight, 20)),

                            Container(
                              width: PERCENT(screenWidth, 60),
                              height: 50,
                              child: BUTTON(
                                text: 'Lets Get Started',
                                color: Theme.of(context).primaryColor,
                                borderRadius: 50.0,
                                fontSize: 18.0,
                                textColor: Colors.white,
                                submitting: _submitting,
                                onPressed: _signup,
                              ),
                            ),

                            SizedBox(height: 10,),
                            AlreadyHaveAccountSignIn(signInTextColor: Colors.grey[600])
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