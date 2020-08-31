import 'package:channab/pages/auth/dont_have_account_signin%20copy.dart';
import 'package:channab/shared/button.dart';
import 'package:channab/shared/common.dart';
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

  void _login() async {
    _formKey.currentState.save();
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
                            child: Image.asset('lib/assets/images/user-login.png')
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