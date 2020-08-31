import 'dart:convert';

import 'package:channab/store/auth.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _loginFormKey = GlobalKey<FormState>();
  // String _mobileNumber = '7528819272';
  // String _password = '1234567';
  String _mobileNumber = '';
  String _password = '';
  bool _hidePass = true;
  bool _submitting = false;
  bool _loginError = false;
  String _loginErrorMsg = '';

  void _login () async {
    if (_loginFormKey.currentState.validate()) {
      _loginFormKey.currentState.save();
      Dio dio = new Dio();
      FormData formData = new FormData.fromMap({
        "mobile_number": _mobileNumber,
        "password": _password,
      });
      setState(() => _submitting = true);
      Response res = await dio.post("https://channab.com/api/login/", data: formData, options: Options(
        headers: {
          "x-api-key" : "9944b09199c62bcf9418ad846dd0e4bbdfc6ee4b"
        }
      ));
      setState(() => _submitting = false);
      Map<String, dynamic> data = jsonDecode(res.data);
      int statusCode = data['status'];
      if(statusCode != 200){
        setState(() {
          _loginError = true;
          _loginErrorMsg = data['message'];
        });
      }else{
        TOKEN = data['token'];
        Navigator.popUntil(context, (_) => !Navigator.canPop(context));
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('CHANNAB', style: TextStyle(),),
              Text('Login', style: TextStyle(),),
              Form(
                key: _loginFormKey,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Mobile Number'
                        ),
                        onSaved: (val) => setState(() => _mobileNumber = val),
                        validator: (value) => value.isEmpty ? 'Mobile number cannot be empty' : null,
                      ),
                      TextFormField(
                        obscureText: _hidePass,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          suffixIcon: InkWell(
                            child: _hidePass == true ? Icon( Icons.visibility_off, size: 20.0, ) : Icon( Icons.visibility, size: 20.0, ),
                            onTap: () => setState(() => _hidePass = !_hidePass),
                          ),
                        ),
                        onSaved: (val) => setState(() => _password = val),
                        validator: (value) => value.isEmpty ? 'Password cannot be empty' : null,
                      ),

                      SizedBox(height: 50,),

                      RaisedButton(
                        child: Container(
                          width: (MediaQuery.of(context).size.width * 70) / 100,
                          child: Center(
                            child: _submitting ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator( strokeWidth: 2,),
                            ) : Text('Login'),
                          ),
                        ),
                        onPressed: _submitting ? null : _login,
                      ),

                      SizedBox(height: 10),

                      _loginError ? Text(_loginErrorMsg, style: TextStyle(color: Colors.redAccent),) : Container(),
                    ],
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}