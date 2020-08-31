import 'package:channab/pages/auth/dont_have_account_signin%20copy.dart';
import 'package:channab/pages/auth/otp_verification.dart';
import 'package:channab/shared/button.dart';
import 'package:channab/shared/common.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  
  String _password = '';
  String _cPassword = '';
  bool _hidePass = true;
  bool _hideC_Pass = true;

  void _submit() async {
    _formKey.currentState.save();
    
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Password', style: TextStyle(
          fontSize: 32,
          color: Colors.white
        ),),
        centerTitle: true,
        elevation: 0,
        leading: Container(),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: ListView(
                  children: [
                    Container(
                      width: screenWidth,
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          Container(
                            width: PERCENT(screenWidth, 60),
                            height: 300,
                            child: Text('Type your new password to reset.', style: TextStyle(
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
                            TextFormField(
                              obscureText: _hideC_Pass,
                              decoration: InputDecoration(
                                labelText: 'Retype Password',
                                suffixIcon: InkWell(
                                  child: _hideC_Pass == true ? Icon( Icons.visibility_off, size: 20.0, ) : Icon( Icons.visibility, size: 20.0, ),
                                  onTap: () => setState(() => _hideC_Pass = !_hideC_Pass),
                                ),
                              ),
                              onSaved: (v) => _password = v
                            ),

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