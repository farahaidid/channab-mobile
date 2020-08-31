import 'package:channab/pages/auth/dont_have_account_signin%20copy.dart';
import 'package:channab/shared/button.dart';
import 'package:channab/shared/common.dart';
import 'package:flutter/material.dart';

class OTP_Verification extends StatefulWidget {
  String nextRoute;
  OTP_Verification({@required String nextRoute}){
    this.nextRoute = nextRoute;
  }
  @override
  _OTP_VerificationState createState() => _OTP_VerificationState();
}

class _OTP_VerificationState extends State<OTP_Verification> {
  final _formKey = GlobalKey<FormState>();
  
  String _otp = '';

  void _submit() async {
    _formKey.currentState.save();
    Navigator.pushReplacementNamed(context, widget.nextRoute);
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification', style: TextStyle(
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
                            child: Text('Enter your OTP below', style: TextStyle(
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
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'OTP'
                              ),
                              onSaved: (v) => _otp = v
                            ),

                            SizedBox(height: PERCENT(screenHeight, 20)),

                            Container(
                              width: PERCENT(screenWidth, 60),
                              height: 50,
                              child: BUTTON(
                                text: 'Verify',
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