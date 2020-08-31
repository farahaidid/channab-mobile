import 'package:channab/pages/auth/already_have_account_signin.dart';
import 'package:channab/shared/button.dart';
import 'package:channab/shared/common.dart';
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

  void _signup() async {
    _formKey.currentState.save();
    Navigator.pushReplacementNamed(context, '/createpin');
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
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'First Name'
                              ),
                              onSaved: (v) => _firstName = v
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Last Name'
                              ),
                              onSaved: (v) => _lastName = v
                            ),
                            TextFormField(
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: 'Mobile Number'
                              ),
                              onSaved: (v) => _mobileNumber = v
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

                            SizedBox(height: 20),

                            Container(
                              width: PERCENT(screenWidth, 60),
                              height: 50,
                              child: BUTTON(
                                text: 'Lets Get Started',
                                color: Theme.of(context).primaryColor,
                                borderRadius: 50.0,
                                fontSize: 18.0,
                                textColor: Colors.white,
                                onPressed: _signup
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