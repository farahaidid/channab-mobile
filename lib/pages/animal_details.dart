import 'dart:convert';

import 'package:channab/dio/dio.dart';
import 'package:channab/shared/button.dart';
import 'package:channab/shared/common.dart';
import 'package:channab/store/store.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:intl/intl.dart';

class AnimalDetails extends StatefulWidget {
  int id;
  AnimalDetails({@required id}){
    this.id = id;
  }
  @override
  _AnimalDetailsState createState() => _AnimalDetailsState();
}

class _AnimalDetailsState extends State<AnimalDetails> {
  bool _fetchingData = true;
  Map<String,dynamic> _animalDetails;
  List<dynamic> _allAnimal = [];
  List<dynamic> _allMaleAnimal = [];
  List<dynamic> _allFemaleAnimal = [];
  List<dynamic> _multiSelectableAnimals = [];
  List<Map<String,dynamic>> _menu = [
    {'text':'Health', 'value': 'health'},
    {'text':'Family', 'value': 'family'},
    {'text':'Milking', 'value': 'milking'},
    {'text':'Gallery', 'value': 'gallery'},
    {'text':'Description', 'value': 'description'},
  ];

  String _selectedMenu = 'health';
  String _filterMilkingBy = 'complete';
  final _milkingForm = GlobalKey<FormState>();
  final _healthForm = GlobalKey<FormState>();
  final _familyForm = GlobalKey<FormState>();
  final _descriptionForm = GlobalKey<FormState>();
  bool _submittingMilkingForm = false;
  Map<String, dynamic> _milkingFormData = {
    'morning_milk': '',
    'evening_milk': '',
  };
  Map<String, dynamic> _healthFormData = {
    'title_health': '',
    'cost': '',
    'description': ''
  };
  Map<String, dynamic> _familyFormData = {
    'male_parent': -1,
    'female_parent': -1,
    'child_select': []
  };
  Map<String, dynamic> _galleryFormData = {
    'image': null,
  };
  Map<String, dynamic> _descriptionFormData = {
    'description': '',
  };

  initState(){
    super.initState();
    _fetchAllData();
  }

  void _fetchAllData() async {
    List<dynamic> _initAnimal = [{
      'id': -1,
      'animal_tag': '-----',
    }];
    _allAnimal = _initAnimal + Store.getAllAnimal();
    _allMaleAnimal = _initAnimal + Store.getAllAnimal().where((element) => element['gender'] == 'Male').toList();
    _allFemaleAnimal = _initAnimal + Store.getAllAnimal().where((element) => element['gender'] == 'Female').toList();
    await _fetchAnimalDetails();
    if(_animalDetails['female_parents_of_animals']['id'] != null){
      _familyFormData['female_parent'] = _animalDetails['female_parents_of_animals']['id'];
    }
    if(_animalDetails['male_parents_animal']['id'] != null){
      _familyFormData['male_parent'] = _animalDetails['male_parents_animal']['id'];
    }
    _setMultiSelectableAnimalList();
    setState(() => _fetchingData = false);
  }

  _setMultiSelectableAnimalList(){
    _multiSelectableAnimals = Store.getAllAnimal().map((animal) {
      bool selected = false;
      var ch = _animalDetails['child_already_select'].singleWhere((a)=>a['id'] == animal['id'], orElse: ()=>null);
      if(ch != null) selected = true;
      return {
        'id': animal['id'],
        'animal_tag': animal['animal_tag'],
        'gender': animal['gender'],
        'selected': selected,
      };
    }).toList();
  }

  void _fetchAnimalDetails () async {
    try{
      print(widget.id);
      Response res = await dio.get('/view_particular_element/?product_id=' + widget.id.toString());
      Map<String, dynamic> data = jsonDecode(res.data);
      _animalDetails = data;
      print(_animalDetails);
    }catch(e){
      print('GET_ANIMAL_DETAILS_ERROR');
      print(e);
    }
  }

  void _showDialogForm(widget){
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 500),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Align(
              alignment: Alignment.topCenter,
              child: widget
            );
          },
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );           
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _fetchingData ? Center(child: CircularProgressIndicator(),) : SafeArea(child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(children: [Expanded(child: Container(child: ListView(children: [

          Container(margin: EdgeInsets.symmetric(horizontal: 10), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(child: Column(children: [
              Container(child: Stack(children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                    image: DecorationImage(
                      image: NetworkImage(_animalDetails['product_details']['product_image']),
                      fit: BoxFit.fill
                    ),
                  ),
                ),
                Positioned(right: 10, bottom: 3, child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromRGBO(0, 178, 45, 1.0),
                    boxShadow: [
                      BoxShadow(color: Colors.white, spreadRadius: 2)
                    ]
                  ),
                )),
              ],),),
              Container(width: 80, child: Text(_animalDetails['product_details']['animal_tag'], textAlign: TextAlign.center,style: TextStyle(
                fontSize: 18,
                color: Color.fromRGBO(42, 60, 91, 1.0),
              ),overflow: TextOverflow.ellipsis,),),
            ],),),

            Container(child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                height: 39,
                width: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(39),
                ),
                child: Center(child: Text(
                  _animalDetails['product_details']['age_in_year'] > 0 ? 'Age: ${_animalDetails['product_details']["age_in_year"]} year'
                  : _animalDetails['product_details']['age_in_month'] > 0 ? 'Age: ${_animalDetails['product_details']["age_in_month"]} month'
                  : 'Age: ${_animalDetails['product_details']["age_in_day"]} day'
                , style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ), textAlign: TextAlign.left,),),
              ),
              SizedBox(height: 10),
              Container(
                height: 39,
                width: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(39),
                ),
                child: Center(child: Text(_animalDetails['product_details']['animal_breed'] != null ? _animalDetails['product_details']['animal_breed'] : 'No Data', style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ), textAlign: TextAlign.left,),),
              ),
            ],),),

            Container(child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                height: 39,
                width: 85,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(39),
                ),
                child: Center(child: Text(_animalDetails['product_details']['animal_gender'], style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ), textAlign: TextAlign.left,),),
              ),
              SizedBox(height: 10),
              Container(
                height: 39,
                width: 85,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(39),
                ),
                child: Center(child: Text(_animalDetails['product_details']['animal_breed'] != null ? _animalDetails['product_details']['animal_breed'] : 'No Data', style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ), textAlign: TextAlign.left,),),
              ),
            ],),),

          ],),),
          SizedBox(height: 20,),

          Container(margin: EdgeInsets.symmetric(horizontal: 10), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            InkWell(child: Container(
              height: 40, 
              width: 40, 
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(child: SvgPicture.asset('lib/assets/svg/plus.svg')),
            ),onTap: (){
              showGeneralDialog(
                barrierLabel: "Label",
                barrierDismissible: true,
                barrierColor: Colors.black.withOpacity(0.5),
                transitionDuration: Duration(milliseconds: 500),
                context: context,
                pageBuilder: (context, anim1, anim2) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return Align(
                        alignment: Alignment.topCenter,
                        child: Scaffold(backgroundColor: Colors.transparent, body: ListView(children: [ 
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: _selectedMenu == 'health' ? 530 : _selectedMenu == 'family' ? 530 : _selectedMenu == 'description' ? 330 : 430,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Column(children: [Expanded(child: ListView(children: [
                                SizedBox(height: 50),
                                
                                Container(padding: EdgeInsets.symmetric(horizontal: 20), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                  Text(
                                    _selectedMenu == 'health' ? 'Add Health' 
                                    : _selectedMenu == 'family' ? 'Add Family' 
                                    : _selectedMenu == 'gallery' ? 'Add Image' 
                                    : _selectedMenu == 'description' ? 'Add Description' 
                                    : 'Add Milk'
                                    , style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromRGBO(42, 60, 91, 1.0),
                                    decoration: TextDecoration.none,
                                  ),),
                                  InkWell(child: Container(
                                    height: 18,
                                    width: 18,
                                    child: Center(child: SvgPicture.asset('lib/assets/svg/cross.svg',),)
                                  ),onTap: _submittingMilkingForm ? null : () => Navigator.pop(context),),
                                ],),),

                                SizedBox(height: 10),
                                Divider(height: 20,),
                                SizedBox(height: 10),

                                _selectedMenu == 'health' ? Form(key: _healthForm, child: Container(padding: EdgeInsets.symmetric(horizontal: 20),child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text('Title', style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromRGBO(42, 60, 91, 1.0),
                                    decoration: TextDecoration.none,
                                  ),textAlign: TextAlign.left,),
                                  TextFormField(
                                    style: TextStyle(
                                      fontSize: 15
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Title',
                                      contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                      isDense: true,
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide(
                                          color: Color.fromRGBO(229, 229, 229, 1.0),
                                          width: 1.5,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide(
                                          color: Color.fromRGBO(229, 229, 229, 1.0),
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    onSaved: (val) => _healthFormData['title_health'] = val.trim(),
                                    validator: (value) => value.isEmpty ? 'Required' : null,
                                  ),
                                  SizedBox(height: 20),
                                  Text('Health Cost', style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromRGBO(42, 60, 91, 1.0),
                                    decoration: TextDecoration.none,
                                  ),textAlign: TextAlign.left,),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      fontSize: 15
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Health Cost',
                                      contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                      isDense: true,
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide(
                                          color: Color.fromRGBO(229, 229, 229, 1.0),
                                          width: 1.5,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide(
                                          color: Color.fromRGBO(229, 229, 229, 1.0),
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    onSaved: (val) => _healthFormData['cost'] = val.trim(),
                                    validator: (value) => value.isEmpty ? 'Required' : null,
                                  ),
                                  SizedBox(height: 20),
                                  Text('Add Content', style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromRGBO(42, 60, 91, 1.0),
                                    decoration: TextDecoration.none,
                                  ),textAlign: TextAlign.left,),
                                  TextFormField(
                                    style: TextStyle(
                                      fontSize: 15
                                    ),
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      hintText: 'Add Content',
                                      contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                      isDense: true,
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide(
                                          color: Color.fromRGBO(229, 229, 229, 1.0),
                                          width: 1.5,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide(
                                          color: Color.fromRGBO(229, 229, 229, 1.0),
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    onSaved: (val) => _healthFormData['description'] = val.trim(),
                                  ),
                                  SizedBox(height: 20),

                                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    SizedBox(
                                      width: PERCENT(MediaQuery.of(context).size.width, 70),
                                      child: BUTTON(
                                        text: 'Save Information',
                                        fontSize: 18.0,
                                        borderRadius: 7.0,
                                        color: Theme.of(context).primaryColor,
                                        textColor: Colors.white,
                                        submitting: _submittingMilkingForm,
                                        onPressed: () async {
                                          if (_healthForm.currentState.validate()) {
                                            setState(() => _submittingMilkingForm = true);
                                            _healthForm.currentState.save();
                                            try{
                                              FormData formData = new FormData.fromMap({
                                                "animal_particular_id": widget.id,
                                                "title_health": _healthFormData['title_health'],
                                                "cost": _healthFormData['cost'],
                                                "description": _healthFormData['description'],
                                              });
                                              print(formData.fields.toString());
                                              Response res = await dio.post('/health_popup/', data: formData);
                                              print(res);
                                              await _fetchAnimalDetails();
                                              Navigator.pop(context);
                                            }catch(e){
                                              print('ADD_HEALTH_ERROR');
                                              print(e);
                                            }
                                            setState(() => _submittingMilkingForm = false);
                                          }
                                        },
                                      ),
                                    ),
                                  ],),

                                ],),),) 
                                : _selectedMenu == 'family' ?
                                Form(key: _familyForm, child: Container(padding: EdgeInsets.symmetric(horizontal: 20),child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text('Male Parent', style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromRGBO(42, 60, 91, 1.0),
                                    decoration: TextDecoration.none,
                                  ),textAlign: TextAlign.left,),
                                  Container(
                                    child: DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButtonFormField<int>(
                                          decoration: InputDecoration(
                                            contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                            isDense: true,
                                            fillColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(229, 229, 229, 1.0),
                                                width: 1.5,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(229, 229, 229, 1.0),
                                                width: 1.5,
                                              ),
                                            ),
                                          ),
                                          value: _familyFormData['male_parent'],
                                          items: _allMaleAnimal.map((x) => DropdownMenuItem<int>(
                                            value: x['id'],
                                            child: Text(
                                              x['animal_tag'],
                                              textAlign: TextAlign.left,
                                            ),
                                          ))
                                          .toList(),
                                          onChanged: (val) {
                                            _familyFormData['male_parent'] = val;
                                          },
                                          validator: (val) => val == -1 ? 'Required' : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  Text('Female Parent', style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromRGBO(42, 60, 91, 1.0),
                                    decoration: TextDecoration.none,
                                  ),textAlign: TextAlign.left,),
                                  Container(
                                    child: DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButtonFormField<int>(
                                          decoration: InputDecoration(
                                            contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                            isDense: true,
                                            fillColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(229, 229, 229, 1.0),
                                                width: 1.5,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(229, 229, 229, 1.0),
                                                width: 1.5,
                                              ),
                                            ),
                                          ),
                                          value: _familyFormData['female_parent'],
                                          items: _allFemaleAnimal.map((x) => DropdownMenuItem<int>(
                                            value: x['id'],
                                            child: Text(
                                              x['animal_tag'],
                                              textAlign: TextAlign.left,
                                            ),
                                          ))
                                          .toList(),
                                          onChanged: (val) {
                                            _familyFormData['female_parent'] = val;
                                          },
                                          validator: (val) => val == -1 ? 'Required' : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text('Select Child', style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromRGBO(42, 60, 91, 1.0),
                                    decoration: TextDecoration.none,
                                  ),textAlign: TextAlign.left,),
                                  Container(
                                    width: MediaQuery.of(context).size.width - 40,
                                    padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(
                                        color: Color.fromRGBO(229, 229, 229, 1.0),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: InkWell(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Please Select'),
                                          Icon(Icons.arrow_drop_down)
                                        ],
                                      ),
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => StatefulBuilder(builder: (context, setState) => Center(
                                            child: Container(
                                              margin: EdgeInsets.symmetric(horizontal: (MediaQuery.of(context).size.width * 10) / 100),
                                              child: Material(
                                                borderRadius: BorderRadius.circular(10.0),
                                                child: Container(
                                                  child: Container(
                                                    padding: EdgeInsets.all(10.0),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: <Widget>[
                                                        Container(
                                                          height: MediaQuery.of(context).size.height - 400,
                                                          child: SingleChildScrollView(
                                                            child: Column(children: _multiSelectableAnimals.asMap().map((index, animal) => MapEntry(index, Container(
                                                              child: Row(children: [
                                                                Checkbox(
                                                                  value: animal['selected'],
                                                                  onChanged: (v) => setState(() => _multiSelectableAnimals[index]['selected'] = !_multiSelectableAnimals[index]['selected']),
                                                                ),
                                                                Flexible(
                                                                  child: Text(
                                                                    animal['animal_tag'],
                                                                    style: TextStyle(fontSize: 16.0),
                                                                  ),
                                                                ),
                                                              ],),
                                                            ),),).values.toList(),),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 30.0,
                                                        ),
                                                        Center(
                                                          child: BUTTON(
                                                            text: 'DONE',
                                                            textColor: Theme.of(context).primaryColor,
                                                            color: Colors.transparent,
                                                            fontSize: 18.0,
                                                            borderRadius: 5.0,
                                                            elevation: 0.0, 
                                                            onPressed: () {
                                                              var selected = _multiSelectableAnimals.where((element) => element['selected']).toList();
                                                              _familyFormData['child_select'] = selected.map((e) => e['id']).toList();
                                                              Navigator.pop(context);
                                                            }),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 20),

                                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    SizedBox(
                                      width: PERCENT(MediaQuery.of(context).size.width, 70),
                                      child: BUTTON(
                                        text: 'Save Information',
                                        fontSize: 18.0,
                                        borderRadius: 7.0,
                                        color: Theme.of(context).primaryColor,
                                        textColor: Colors.white,
                                        submitting: _submittingMilkingForm,
                                        onPressed: () async {
                                          if (_familyForm.currentState.validate()) {
                                            setState(() => _submittingMilkingForm = true);
                                            _familyForm.currentState.save();
                                            try{
                                              FormData formData = new FormData.fromMap({
                                                "family_particular_id": widget.id,
                                                "male_parent": _familyFormData['male_parent'],
                                                "female_parent": _familyFormData['female_parent'],
                                                "child_select": _familyFormData['child_select'].toString(),
                                              });
                                              print(formData.fields.toString());
                                              Response res = await dio.post('/add_child_api/', data: formData);
                                              await _fetchAnimalDetails();
                                              _setMultiSelectableAnimalList();
                                              print(res);
                                              Navigator.pop(context);
                                            }catch(e){
                                              print('ADD_FAMILY_ERROR');
                                              print(e);
                                            }
                                            setState(() => _submittingMilkingForm = false);
                                          }
                                        },
                                      ),
                                    ),
                                  ],),
                                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    SizedBox(
                                      width: PERCENT(MediaQuery.of(context).size.width, 60),
                                      child: BUTTON(
                                        text: 'Add Animal',
                                        fontSize: 18.0,
                                        borderRadius: 7.0,
                                        color: Theme.of(context).primaryColor,
                                        textColor: Colors.white,
                                        submitting: _submittingMilkingForm,
                                        onPressed: () => Navigator.pushReplacementNamed(context, '/farm_animal_form'),
                                      ),
                                    ),
                                  ],),

                                ],),),)
                                : _selectedMenu == 'gallery' ?
                                Container(padding: EdgeInsets.symmetric(horizontal: 20),child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  InkWell(
                                    child: DottedBorder(
                                      color: Theme.of(context).primaryColor,
                                      borderType: BorderType.RRect,
                                      radius: Radius.circular(5),
                                      child: Container(
                                        height: 200,
                                        width: MediaQuery.of(context).size.width - 40,
                                        child: _galleryFormData['image'] != null ? Image.file(_galleryFormData['image'],) : Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(Icons.cloud_upload, color: Theme.of(context).primaryColor,),
                                            Text('Image Upload', style: TextStyle(color: Theme.of(context).primaryColor,),)
                                          ],
                                        ),
                                      ),
                                    ),
                                    onTap: ()async{
                                      var imageData = await pickImage(ImageSource.camera);
                                      setState((){
                                        _galleryFormData['image'] = imageData['file'];
                                      });
                                    },
                                  ),
                                  SizedBox(height: 20),

                                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    SizedBox(
                                      width: PERCENT(MediaQuery.of(context).size.width, 70),
                                      child: BUTTON(
                                        text: 'Save Information',
                                        fontSize: 18.0,
                                        borderRadius: 7.0,
                                        color: Theme.of(context).primaryColor,
                                        textColor: Colors.white,
                                        submitting: _submittingMilkingForm,
                                        onPressed: _galleryFormData['image'] == null ? null : () async {
                                          setState(() => _submittingMilkingForm = true);
                                          try{
                                            FormData formData = new FormData.fromMap({
                                              "animal_particular_id": widget.id,
                                              "main_image": await MultipartFile.fromFile(_galleryFormData['image'].path),
                                            });
                                            Response res = await dio.post('/gallery_popup/', data: formData);
                                            await _fetchAnimalDetails();
                                            print(res);
                                            Navigator.pop(context);
                                          }catch(e){
                                            print('ADD_IMAGE_ERROR');
                                            print(e);
                                          }
                                          setState(() => _submittingMilkingForm = false);
                                        },
                                      ),
                                    ),
                                  ],),

                                ],),)
                                : _selectedMenu == 'description' ?
                                Form(key: _descriptionForm, child: Container(padding: EdgeInsets.symmetric(horizontal: 20),child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text('Add Description', style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromRGBO(42, 60, 91, 1.0),
                                    decoration: TextDecoration.none,
                                  ),textAlign: TextAlign.left,),
                                  TextFormField(
                                    style: TextStyle(
                                      fontSize: 15
                                    ),
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      hintText: 'Add Description',
                                      contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                      isDense: true,
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide(
                                          color: Color.fromRGBO(229, 229, 229, 1.0),
                                          width: 1.5,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide(
                                          color: Color.fromRGBO(229, 229, 229, 1.0),
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    onSaved: (val) => _descriptionFormData['description'] = val.trim(),
                                    validator: (val) => val.isEmpty ? 'Required' : null,
                                  ),
                                  SizedBox(height: 20,),

                                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    SizedBox(
                                      width: PERCENT(MediaQuery.of(context).size.width, 70),
                                      child: BUTTON(
                                        text: 'Save Information',
                                        fontSize: 18.0,
                                        borderRadius: 7.0,
                                        color: Theme.of(context).primaryColor,
                                        textColor: Colors.white,
                                        submitting: _submittingMilkingForm,
                                        onPressed: () async {
                                          if (_descriptionForm.currentState.validate()) {
                                            setState(() => _submittingMilkingForm = true);
                                            _descriptionForm.currentState.save();
                                            try{
                                              FormData formData = new FormData.fromMap({
                                                "animal_particular_id": widget.id,
                                                "description": _descriptionFormData['description'],
                                              });
                                              Response res = await dio.post('/description_popup/', data: formData);
                                              await _fetchAnimalDetails();
                                              _setMultiSelectableAnimalList();
                                              print(res);
                                              Navigator.pop(context);
                                            }catch(e){
                                              print('ADD_DESCRIPTION_ERROR');
                                              print(e);
                                            }
                                            setState(() => _submittingMilkingForm = false);
                                          }
                                        },
                                      ),
                                    ),
                                  ],),
                                ],),),)
                                
                                : Container(),

                                SizedBox(height: 50),
                              ],),),],),
                            ),
                            // InkWell(child: Container(height: MediaQuery.of(context).size.height > 430 ? MediaQuery.of(context).size.height-430 : 0, width: MediaQuery.of(context).size.width,),onTap: () => Navigator.pop(context),),
                            ],
                          ),
                        )
                      );
                    },
                  );
                },
                transitionBuilder: (context, anim1, anim2, child) {
                  return SlideTransition(
                    position: Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(anim1),
                    child: child,
                  );
                },
              ).then((value) => setState((){}));
            },),
            Container(
              height: 40, 
              width: 40, 
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(child: SvgPicture.asset('lib/assets/svg/bell.svg')),
            ),
            Container(
              height: 40, 
              width: 40, 
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(child: SvgPicture.asset('lib/assets/svg/edit_pencil.svg')),
            ),
            Container(
              height: 40, 
              width: 81, 
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Switch(
                value: true, 
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Theme.of(context).primaryColor, 
                activeTrackColor: Theme.of(context).primaryColor, 
                activeColor: Colors.white,
                onChanged: (v){

                },
              ),
            ),
          ],),),
          SizedBox(height: 20,),

          Divider(),
          Container(margin: EdgeInsets.symmetric(horizontal: 10), height: 30,child: ListView.builder(itemCount: _menu.length, scrollDirection: Axis.horizontal, itemBuilder: (context,index) => Container(
            width: 100,
            height: 29,
            padding: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: _menu[index]['value'] == _selectedMenu ? Theme.of(context).primaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(29)
            ),
            child: InkWell(child: Container(child: Center(child: Text(_menu[index]['text'], style: TextStyle(
              fontSize: 16,
              color: _menu[index]['value'] == _selectedMenu ? Colors.white : Color.fromRGBO(42, 60, 91, 1.0),
            ),),),),onTap: () => setState(() => _selectedMenu = _menu[index]['value']),),
          ),),),
          Divider(),

          _selectedMenu == 'health' ? Container(margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20), child: Column(children: _animalDetails['all_health_record_list'].map<Widget>((healthRecord) => Container(
            margin: EdgeInsets.only(bottom: 10),
            child: TimelineTile(
              alignment: TimelineAlign.left,
              lineX: 1,
              isFirst: false,
              isLast: false,
              rightChild: Container(
                padding: EdgeInsets.only(left: 5),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Container(
                      width: PERCENT(MediaQuery.of(context).size.width, 40),
                      child: Text(healthRecord['tag_name'], style: TextStyle(
                        fontSize: 16,
                        color: Color.fromRGBO(42, 60, 91, 1.0),
                      ),textAlign: TextAlign.left, overflow: TextOverflow.ellipsis,),
                    ),
                    Container(
                      width: PERCENT(MediaQuery.of(context).size.width, 40),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Text('Cost: ' + healthRecord['cost_amount'].toString() + ' PKR', style: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(42, 60, 91, 1.0),
                        ),textAlign: TextAlign.right, overflow: TextOverflow.ellipsis,),
                        Text(healthRecord['ago'].toString().toUpperCase(), style: TextStyle(
                          fontSize: 9,
                          color: Color.fromRGBO(173, 172, 167, 1.0),
                        ),textAlign: TextAlign.right, overflow: TextOverflow.ellipsis,),
                      ],),
                    ),
                  ],),),
                  SizedBox(height: 5),
                  Container(child: Text(healthRecord['text_description'], style: TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(173, 172, 167, 1.0),
                  ),textAlign: TextAlign.left, ),),
                ],),
              ),
              indicatorStyle: IndicatorStyle(
                width: 24,
                height: 24,
                indicator: Container(
                  height: 24,
                  width: 24,
                  padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(24)
                  ),
                  child: SvgPicture.asset('lib/assets/svg/plus.svg'),
                ),
                drawGap: true,
              ),
              topLineStyle: LineStyle(
                width: 1,
                color: Color.fromRGBO(222, 222, 222, 1.0),
              ),
            ),
          ),).toList(),),) : Container(),

          _selectedMenu == 'family' ? Container(margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),child: Column(crossAxisAlignment: CrossAxisAlignment.start, 
          children: _animalDetails['male_parents_animal']['animal_tag'] == null ? [] : [
            Text('Parents', style: TextStyle(
              fontSize: 23,
              color: Color.fromRGBO(42, 60, 91, 1.0),
            ),),
            SizedBox(height: 20,),
          ] + [_animalDetails['male_parents_animal'] , _animalDetails['female_parents_of_animals']].map<Widget>((parent) =>
            Container(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 66,
                width: MediaQuery.of(context).size.width - 20,
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0,5),
                      blurRadius: 14,
                      spreadRadius: 3,
                      color: Color.fromRGBO(229, 229, 229, 1.0)
                    )
                  ]
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Container(child: Row(children: [
                    Container(
                      height: 51,
                      width: 54,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(image: NetworkImage(parent['animal_image']), fit: BoxFit.fill)   
                      ),
                    ),
                    Container(width: MediaQuery.of(context).size.width - 40 - 20 - 80 - 87 - 15, margin: EdgeInsets.only(left: 10), child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(parent['animal_tag'], style: TextStyle(
                        fontSize: 21,
                        color: Color.fromRGBO(31, 48, 111, 1.0)
                      ),textAlign: TextAlign.left, overflow: TextOverflow.ellipsis,),
                    ],),),
                  ],),),

                  Container(
                    height: 30,
                    width: 87,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 178, 45, 1.0),
                      borderRadius: BorderRadius.circular(19.5)
                    ),
                    child: Center(child: Text(parent['gender'], style: TextStyle(
                      fontSize: 16,
                      color: Colors.white
                    ),),),
                  ),  
                ],),
              ),
            ),).toList() + [
              SizedBox(height: 10,),
              Text('Childs', style: TextStyle(
                fontSize: 23,
                color: Color.fromRGBO(42, 60, 91, 1.0),
              ),),
              SizedBox(height: 20,),
            ] + _animalDetails['child_already_select'].map<Widget>((child) => Container(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 66,
                width: MediaQuery.of(context).size.width - 20,
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0,5),
                      blurRadius: 14,
                      spreadRadius: 3,
                      color: Color.fromRGBO(229, 229, 229, 1.0)
                    )
                  ]
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Container(child: Row(children: [
                    Container(
                      height: 51,
                      width: 54,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(image: NetworkImage(child['image']), fit: BoxFit.fill)   
                      ),
                    ),
                    Container(width: MediaQuery.of(context).size.width - 40 - 20 - 80 - 87 - 15, margin: EdgeInsets.only(left: 10), child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(child['animal_tag'], style: TextStyle(
                        fontSize: 21,
                        color: Color.fromRGBO(31, 48, 111, 1.0)
                      ),textAlign: TextAlign.left, overflow: TextOverflow.ellipsis,),
                    ],),),
                  ],),),

                  Container(
                    height: 30,
                    width: 87,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 178, 45, 1.0),
                      borderRadius: BorderRadius.circular(19.5)
                    ),
                    child: Center(child: Text(child['gender'], style: TextStyle(
                      fontSize: 16,
                      color: Colors.white
                    ),),),
                  ),  
                ],),
              ),
            ),).toList(),),) : Container(),

          _selectedMenu == 'milking' ? Container(margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              PopupMenuButton<String>(
                child: Container(
                  width: 34,height: 32,
                  padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(5)

                  ),
                  child: SvgPicture.asset('lib/assets/svg/filter.svg', ),
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: "week",
                    child: Text('Week'),
                  ),
                  PopupMenuItem<String>(
                    value: "1month",
                    child: Text('1 Month'),
                  ),
                  PopupMenuItem<String>(
                    value: "3month",
                    child: Text('3 Month'),
                  ),
                  PopupMenuItem<String>(
                    value: "6month",
                    child: Text('6 Month'),
                  ),
                  PopupMenuItem<String>(
                    value: "1year",
                    child: Text('1 Year'),
                  ),
                  PopupMenuItem<String>(
                    value: "complete",
                    child: Text('Complete'),
                  ),
                ],
                initialValue: _filterMilkingBy,
                onSelected: (v) => setState(() => _filterMilkingBy = v),
              ),
            ],),

            SizedBox(height: 20,),

            _animalDetails['milk_all_record']['milk_data_by_row'].length == 0 ? Container() : Container(
              width: MediaQuery.of(context).size.width-20,
              decoration: BoxDecoration(
              color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(229, 229, 229, 1.0),
                    spreadRadius: 1,
                  )
                ],
                borderRadius: BorderRadius.circular(10)
              ),
              child: DataTable(columns: [
                DataColumn(label: Text('Date', style: TextStyle(
                  fontSize: 13,
                  color: Color.fromRGBO(42, 60, 91, 1.0),
                ),)),
                DataColumn(label: Text('Morning', style: TextStyle(
                  fontSize: 13,
                  color: Color.fromRGBO(42, 60, 91, 1.0),
                ),)),
                DataColumn(label: Text('Evening', style: TextStyle(
                  fontSize: 13,
                  color: Color.fromRGBO(42, 60, 91, 1.0),
                ),)),
                DataColumn(label: Text('Total', style: TextStyle(
                  fontSize: 13,
                  color: Color.fromRGBO(42, 60, 91, 1.0),
                ),)),
              ], rows: _animalDetails['milk_all_record']['milk_data_by_row'].map<DataRow>((milkRecord) => DataRow(cells: [
                DataCell(Text(milkRecord['created_on'], style: TextStyle(
                  fontSize: 11,
                  color: Color.fromRGBO(42, 60, 91, 1.0)
                ),),),
                DataCell(Text(milkRecord['morning_time'].toString() + ' Liter', style: TextStyle(
                  fontSize: 11,
                  color: Color.fromRGBO(42, 60, 91, 1.0)
                ),),),
                DataCell(Text(milkRecord['evening_time'].toString() + ' Liter', style: TextStyle(
                  fontSize: 11,
                  color: Color.fromRGBO(42, 60, 91, 1.0)
                ),),),
                DataCell(Text(milkRecord['sum_of_one'].toString() + ' Liter', style: TextStyle(
                  fontSize: 11,
                  color: Color.fromRGBO(42, 60, 91, 1.0)
                ),),),
              ],), ).toList() + [1].map<DataRow>((last) => DataRow(cells: [
                DataCell(Text('Total/Week', style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).primaryColor,
                ),),),
                DataCell(Text(_animalDetails['milk_all_record']['sum_of_morning_coloumn'].toString() + ' Liter', style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).primaryColor,
                ),),),
                DataCell(Text(_animalDetails['milk_all_record']['sum_of_evening_colourmn'].toString() + ' Liter', style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).primaryColor,
                ),),),
                DataCell(Text(_animalDetails['milk_all_record']['sum_of_all'].toString() + ' Liter', style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).primaryColor,
                ),),),
              ],),).toList(),),
            ),
          ],),) : Container(),

          _selectedMenu == 'gallery' ? Container(margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),child: Wrap(children: _animalDetails['galler_list'].map<Widget>((gallery) => Container(
            width: (MediaQuery.of(context).size.width - 20) / 2,
            child: Container(
              margin: EdgeInsets.all(5),
              height: 154,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(gallery['image']),
                  fit: BoxFit.fill
                ),
                borderRadius: BorderRadius.circular(12)
              ),
            ),
          ),).toList(),),): Container(),

          _selectedMenu == 'description' ? Container(margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: _animalDetails['all_description_list'].map<Widget>((description) => Container(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(description['created_on'].toString().toUpperCase(), style: TextStyle(
                fontSize: 13,
                color: Color.fromRGBO(51, 72, 98, 1.0),
              ),),
              SizedBox(height: 5),
              Text(description['description'], style: TextStyle(
                fontSize: 18,
                color: Color.fromRGBO(173, 172, 167, 1.0),
              ),),
              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 10),

            ],),
          ),).toList(),),) : Container(),

        ],),),),],),
      ),),
    );
  }
}