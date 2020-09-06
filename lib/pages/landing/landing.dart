import 'package:channab/dio/dio.dart';
import 'package:channab/pages/auth/already_have_account_signin.dart';
import 'package:channab/pages/auth/create_pin.dart';
import 'package:channab/shared/button.dart';
import 'package:channab/shared/common.dart';
import 'package:channab/store/auth.dart';
import 'package:channab/store/store.dart';
import 'package:flutter/material.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  bool _fetchingData = true;

  initState(){
    super.initState();
    _fetchAllData();
  }

  void _fetchAllData() async {
    Api.initialize();
    await Store().initialize();
    setState(() => _fetchingData = false);

    if(Store.isLogged()){
      Navigator.popUntil(context, (_) => !Navigator.canPop(context));
      Navigator.pushReplacementNamed(context, '/home');
      // if(Store.getPin() == null){
      //   Navigator.pushReplacementNamed(context, '/createpin');
      // }else if(PIN == ''){
      //   Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => CreatePin(pinVerification: true,) ));
      // }else if(PIN == Store.getPin()){
      //   Navigator.pushReplacementNamed(context, '/home');
      // }
    }
  }

  Widget _logo(){
    return new Container(
      height: 100,
      width: 100,
      child: Image.network('https://channab01.s3.amazonaws.com/img/bg-img/chnaab_vij.png', color: Colors.white,),
    );
  }

  Widget _welcome(){
    return new Container(
      child: Column(
        children: [
          Text('Welcome to', style: TextStyle(
            fontSize: 28,
            color: Colors.grey[300]
          ),),
          Text('CHANNAB', style: TextStyle(
            fontSize: 56,
            color: Colors.white
          ),)
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                child: ListView(
                  children: [
                    SizedBox(height:PERCENT(screenHeight, 15)),
                    _logo(),
                    SizedBox(height: 20),
                    _welcome(),
                    SizedBox(height: PERCENT(screenHeight, 18),),

                    _fetchingData ? Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(backgroundColor: Colors.white,),
                      ),
                    ) : Container(),

                    SizedBox(height: PERCENT(screenHeight, 18),),
                    
                    !_fetchingData ? Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: PERCENT(screenWidth, 60),
                        height: 50,
                        child: BUTTON(
                          text: 'Create Account',
                          fontSize: 18.0,
                          color: Colors.white,
                          borderRadius: 50.0,
                          onPressed: (){
                            Navigator.pushReplacementNamed(context, '/signup');
                          }
                        ),
                      ),
                    ):Container(),

                    SizedBox(height: 10),

                    !_fetchingData ? AlreadyHaveAccountSignIn(signInTextColor: Colors.white) : Container(),
                    SizedBox(height: 50),
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