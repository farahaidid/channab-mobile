import 'dart:convert';

import 'package:channab/dio/dio.dart';
import 'package:channab/pages/auth/dont_have_account_signin%20copy.dart';
import 'package:channab/pages/auth/otp_verification.dart';
import 'package:channab/shared/button.dart';
import 'package:channab/shared/common.dart';
import 'package:channab/store/store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  
  String _mobileNumber = '';
  String _password = '';
  bool _hidePass = true;
  bool _submitting = false;
  bool _loginErr = false;
  String _loginErrMsg = '';

  void _login() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      String formattedMobileNumber = '';
      if(_mobileNumber.startsWith('0092')){
        formattedMobileNumber = _mobileNumber.substring(2);
      }else if(_mobileNumber.startsWith('92')){
        formattedMobileNumber = '92' + _mobileNumber.substring(2);
      }else if(_mobileNumber.startsWith('0')){
        formattedMobileNumber = '92' + _mobileNumber.substring(1);
      }else{
        formattedMobileNumber = _mobileNumber;
      }

      print(formattedMobileNumber);
      setState(() => _submitting = true);
      FormData formData = new FormData.fromMap({
        "mobile_number": formattedMobileNumber,
        "password": _password,
      });

      try{
        Response res = await dio.post('/login/', data: formData);
        print(res);
        Map<String, dynamic> data = jsonDecode(res.data);
        if(data['status'] == 100){
          if(data['message'] == 'Sorry, You have not confirmed your account'){
            Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => OTP_Verification(nextRoute: '/signin') ));
          }else{
            _loginErr = true;
            _loginErrMsg = data['message'];
          }
        }else{
          Map<String, dynamic> userInfo = {
            'user_id': data['user_id'],
            'user_email': data['user_email'],
            'phone': data['phone'],
          };
          Store.setToken(data['token']);
          Store.setIsLogged(true);
          Store.setUserInfo(jsonEncode(userInfo));
          if(Store.getPin() == null){
            Navigator.pushReplacementNamed(context, '/createpin');
          }else{
            Navigator.pushReplacementNamed(context, '/home');
          }
        }
      }catch(e){
        print('SIGNUP_ERROR');
        print(e.message);
        _loginErr = true;
        _loginErrMsg = 'Something went wrong! Please try again later.';
      }
      setState(() => _submitting = false);

    }
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome Back!', style: TextStyle(
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
                            child: Image.asset('lib/assets/images/user-login.png')
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: screenWidth,
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

                            SizedBox(height: 5,),
                            
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    child: Text('Forgot your password?', style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.redAccent,
                                    ),),
                                    onTap: (){
                                      Navigator.pushNamed(context, '/forgotpassword');
                                    },
                                  )
                                ],
                              ),
                            ),

                            _loginErr ? Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Center(
                                child: Text(_loginErrMsg, style: TextStyle(
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
                                text: 'Login',
                                color: Theme.of(context).primaryColor,
                                borderRadius: 50.0,
                                fontSize: 18.0,
                                textColor: Colors.white,
                                submitting: _submitting,
                                onPressed: _login
                              ),
                            ),

                            SizedBox(height: 10,),
                            DontHaveAccountSignUp(signUpTextColor: Colors.grey[600])
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