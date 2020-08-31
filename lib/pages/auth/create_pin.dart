import 'dart:ui';

import 'package:channab/pages/auth/dont_have_account_signin%20copy.dart';
import 'package:channab/pages/auth/otp_verification.dart';
import 'package:channab/pages/widgets/pin.dart';
import 'package:channab/shared/button.dart';
import 'package:channab/shared/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CreatePin extends StatefulWidget {
  @override
  _CreatePinState createState() => _CreatePinState();
}

class _CreatePinState extends State<CreatePin> {
  String _title = 'Create Pin';

  String _pin = '';
  String _cPin = '';
  bool _showConfirmPin = false;
  bool _pinDidNotMatch = false;

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
      if(_pin.length == PIN_LENGTH && !_showConfirmPin){
        _showConfirmPin = true;
        _title = 'Confirm Pin';
      }else if(_cPin.length == PIN_LENGTH){
        if(_pin == _cPin){

        }else{
          _pinDidNotMatch = true;
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
        title: Text(_title, style: TextStyle(
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
              _title = 'Create Pin';
              _pin = '';
              _pinDidNotMatch = false;
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

                          _pinDidNotMatch ? Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Text('Pin Did not match!', style: TextStyle(
                              fontSize: 18,
                              color: Colors.white
                            ),),
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