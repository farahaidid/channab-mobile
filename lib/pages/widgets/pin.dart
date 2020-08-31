import 'package:channab/shared/button.dart';
import 'package:channab/shared/common.dart';
import 'package:flutter/material.dart';

class Pin extends StatefulWidget {
  var keyDown;
  Pin({@required keyDown}){
    this.keyDown = keyDown;
  }
  @override
  _PinState createState() => _PinState();
}

class _PinState extends State<Pin> {

  Widget _keyBtn(keyNum){
    return Container(
      height: 70.0,
      width: 70.0,
      child: BUTTON(
        text: keyNum,
        color: Colors.grey[100],
        borderRadius: 50.0,
        textColor: Colors.grey,
        elevation: 0.0,
        fontSize: 18.0,
        onPressed: (){
          widget.keyDown(keyNum);
        }
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: PERCENT(screenWidth, 15), vertical: 20),
      decoration: BoxDecoration(
        color: Colors.transparent
      ),
      child: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['1','2','3'].map((keyNum) => _keyBtn(keyNum)).toList(),
            ),
          ),
          SizedBox(height: 10),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['4','5','6'].map((keyNum) => _keyBtn(keyNum)).toList(),
            ),
          ),
          SizedBox(height: 10),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['7','8','9'].map((keyNum) => _keyBtn(keyNum)).toList(),
            ),
          ),
          SizedBox(height: 10),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 70.0,
                  width: 70.0,
                ),
                _keyBtn('0'),
                Container(
                  height: 70.0,
                  width: 70.0,
                  child: RaisedButton(
                    child: Icon(Icons.backspace,size: 18,),
                    color: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    textColor: Colors.grey,
                    elevation: 0.0,
                    onPressed: (){
                      widget.keyDown('CLEAR_ONE');
                    }
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}