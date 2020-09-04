import 'dart:convert';
import 'dart:io';

import 'package:channab/dio/dio.dart';
import 'package:channab/store/auth.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FarmAnimalForm extends StatefulWidget {
  @override
  _FarmAnimalFormState createState() => _FarmAnimalFormState();
}

class _FarmAnimalFormState extends State<FarmAnimalForm> {
  double screenWidth = 0;
  final animalForm = GlobalKey<FormState>();
  int _categoryId = -1;
  List<dynamic> _categories = [];
  bool _fetchingData = true;
  DateTime _date;
  bool _submitting = false;

  List<Map<String,String>> _genderOptions = [
    { 'text': 'Select Gender', 'value': '' },
    { 'text': 'Male', 'value': 'Male' },
    { 'text': 'Female', 'value': 'Female' },
  ];
  String _gender = '';

  String _animalTag = '';

  bool _success = false;
  bool _error = false;
  String _successMsg = '';
  String _errorMsg = '';

  var _animalTagController = TextEditingController();

  initState(){
    super.initState();
    _fetchAllData();
  }

  void _fetchAllData() async {
    await fetchCategories();
    setState(() => _fetchingData = false);
  }

  void fetchCategories () async {
    Response res = await dio.get("/all_category/",);

    Map<String, dynamic> data = jsonDecode(res.data);

    List<dynamic> cats = new List<dynamic>();
    cats.add({'name_of_category': 'Select Category', 'id': -1});
    _categories = cats + data['all_categories'];
    
  }

  double width(per){
    return (screenWidth * per) / 100;
  }

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  void _saveInfo() async {
    if (animalForm.currentState.validate()) {
      animalForm.currentState.save();
      Dio dio = new Dio();
      String category = _categories.firstWhere((element) => element['id'] == _categoryId)['name_of_category'];
      FormData formData = new FormData.fromMap({
        "animal_tag": _animalTag,
        "age": _date.toString().substring(0,10),
        "category": category,
        "gender": _gender,
        "animal_type": 'Dry',
        "main_image": await MultipartFile.fromFile(_image.path)
      });
      setState(() => _submitting = true);
      Response res = await dio.post("https://channab.com/api/live_animal_Add/", data: formData, options: Options(
        headers: {
          "token" : TOKEN
        }
      ));
      setState(() => _submitting = false);
      Map<String, dynamic> data = jsonDecode(res.data);
      int statusCode = data['status'];
      if(statusCode == 200){
        setState(() {
          _success = true;
          _successMsg = data['message'];
          _image = null;
          _animalTag = '';
          _date = null;
          _categoryId = -1;
          _gender = '';
          _animalTagController.clear();
        });
      }else{
        setState(() {
          _error = true;
          _errorMsg = data['message'];
        });
      }
      
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Farm Animals'),
      ),
      body: _fetchingData ? Center(
        child: CircularProgressIndicator(),
      ) : GestureDetector( child: 
        Container(
          padding: EdgeInsets.all(10),
          child: Form(
            key: animalForm,
            child: ListView(
              children: [
                InkWell(
                  child: DottedBorder(
                    color: Theme.of(context).primaryColor,
                    borderType: BorderType.RRect,
                    radius: Radius.circular(5),
                    child: Container(
                      height: 200,
                      width: screenWidth,
                      child: _image != null ? Image.file(_image,) : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload, color: Theme.of(context).primaryColor,),
                          Text('Image Upload', style: TextStyle(color: Theme.of(context).primaryColor,),)
                        ],
                      ),
                    ),
                  ),
                  onTap: getImage,
                ),

                SizedBox(height: 20),

                Text('Animal Tag'),
                TextFormField(
                  controller: _animalTagController,
                  decoration: InputDecoration(
                    hintText: 'Type here',
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                  ),
                  onSaved: (val) => setState(() => _animalTag = val),
                ),
                SizedBox(height: 20),

                Text('Date of Birth'),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.only(left: 20,),
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: _date != null ? Text(_date.toString().substring(0,10)) : Text('DOB'),
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10)
                            )
                          ),
                          child: Icon(Icons.event, color: Colors.white,),
                        ),
                      ],
                    ),
                  ),
                  onTap: (){
                    showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1950), lastDate: DateTime(2021))
                    .then((value) => {
                      setState(()=>_date = value)
                    });
                  },
                ),


                Container(
                  margin: EdgeInsets.only(top: 20),
                  width: width(100),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<int>(
                        value: _categoryId,
                        items: _categories.map((x) => DropdownMenuItem<int>(
                          value: x['id'],
                          child: Text(
                            x['name_of_category'],
                            textAlign: TextAlign.left,
                          ),
                        ))
                        .toList(),
                        onChanged: (val) => setState(() {
                          _categoryId = val;
                        }),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  width: width(100),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        value: _gender,
                        items: _genderOptions.map((x) => DropdownMenuItem<String>(
                          value: x['value'],
                          child: Text(
                            x['text'],
                            textAlign: TextAlign.left,
                          ),
                        ))
                        .toList(),
                        onChanged: (val) => setState(() {
                          _gender = val;
                        }),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                Container(
                  width: 100,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Theme.of(context).primaryColor,
                    child: Container(
                      child: Center(
                        child: _submitting ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator( strokeWidth: 2,),
                        ) : Text('Save Information', style: TextStyle(color: Colors.white),),
                      ),
                    ),
                    onPressed: _submitting ? null : _saveInfo,
                  ),
                ),

                _error ? Center(child: Text(_errorMsg, style: TextStyle(color: Colors.redAccent),)) : Container(),
                _success ? Center(child: Text(_successMsg, style: TextStyle(color: Colors.greenAccent),)) : Container(),
                
              ],
            ),
          ),
        ),
        onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());
        },
      ),
    );
  }
}