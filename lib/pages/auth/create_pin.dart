import 'dart:ui';

import 'package:channab/pages/auth/dont_have_account_signin%20copy.dart';
import 'package:channab/pages/auth/otp_verification.dart';
import 'package:channab/pages/widgets/pin.dart';
import 'package:channab/shared/button.dart';
import 'package:channab/shared/common.dart';
import 'package:channab/store/auth.dart';
import 'package:channab/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CreatePin extends StatefulWidget {
  bool pinVerification;
  CreatePin({pinVerification = false}){
    this.pinVerification = pinVerification;
  }
  @override
  _CreatePinState createState() => _CreatePinState();
}

class _CreatePinState extends State<CreatePin> {

  String _pin = '';
  String _cPin = '';
  bool _showConfirmPin = false;
  bool _pinError = false;
  String _pinErrMsg = '';

  final PIN_LENGTH = 4;

  void _submit() async {
    
  }

  void _keyDown(String key){
    String p = _showConfirmPin ? _cPin : _pin;
    if(key == 'CLEAR_ONE'){
      if (p != null && p.length > 0) {
        p = p.substring(0, p.length - 1);
      }
    }else{
      p += key;
    }
    
    setState(() {
      if(_showConfirmPin){
        _cPin = p;
      }else{
        _pin = p;
      }
      if(_pin.length == PIN_LENGTH && widget.pinVerification){
        if(_pin == Store.getPin()){
          Navigator.popUntil(context, (_) => !Navigator.canPop(context));
          Navigator.pushReplacementNamed(context, '/home');
        }else{
          _pin = '';
          _pinError = true;
          _pinErrMsg = 'Pin Did not match!';
        }
      }
      else if(_pin.length == PIN_LENGTH && !_showConfirmPin){
        _showConfirmPin = true;
      }else if(_cPin.length == PIN_LENGTH){
        if(_pin == _cPin){
          Store.setPin(_pin);
          Navigator.popUntil(context, (_) => !Navigator.canPop(context));
          Navigator.pushReplacementNamed(context, '/home');
        }else{
          _cPin = '';
          _pinError = true;
          _pinErrMsg = 'Pin Did not match!';
        }
      }
    });
    
  }

  List<Widget> _pinLengthsContainers(){
    List<Widget> cons = [];
    for(var i = 0; i < PIN_LENGTH;i++){
      cons.add(new Container(
        margin: EdgeInsets.only(right: i < PIN_LENGTH ? 10 : 0 ),
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: i < (_showConfirmPin ? _cPin.length : _pin.length) ? Colors.lightBlueAccent : Colors.white,
          borderRadius: BorderRadius.circular(20.0)
        ),
      ));
    }
    return cons;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _showConfirmPin ? 'Confirm Pin' : widget.pinVerification ? 'Verify Pin' : 'Create Pin'
          , style: TextStyle(
          fontSize: 32,
          color: Colors.white
        ),),
        centerTitle: true,
        elevation: 0,
        leading: _showConfirmPin ? IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            setState(() {
              _showConfirmPin = false;
              _cPin = '';
              _pin = '';
              _pinError = false;
            });
          },
        ) : null,
      ),
      body: Container(
        height: screenHeight,
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
                      child: Column(
                        children: [
                          SizedBox(height: PERCENT(screenHeight, 15),),

                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _pinLengthsContainers(),
                            ),
                          ),

                          SizedBox(height: PERCENT(screenHeight, 15),),

                          _pinError ? Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Text( _pinErrMsg, style: TextStyle(
                              fontSize: 18,
                              color: Colors.white
                            ),textAlign: TextAlign.center,),
                          ) : Container(),

                        ],
                      ),
                    ),
                    Pin(keyDown: _keyDown)
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