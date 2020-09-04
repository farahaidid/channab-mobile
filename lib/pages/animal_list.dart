import 'dart:convert';

import 'package:channab/dio/dio.dart';
import 'package:channab/shared/button.dart';
import 'package:channab/shared/common.dart';
import 'package:channab/store/store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AnimalList extends StatefulWidget {
  @override
  _AnimalListState createState() => _AnimalListState();
}

class _AnimalListState extends State<AnimalList> {
  bool _fetchingData = true;
  List<dynamic> _animals = [];
  List<dynamic> _filteredAnimals = [];
  List<dynamic> _categories = [];
  List<FilterItem> _filterItems = [ 
    new FilterItem(
      false,
      'Animal Type',
    ),
    new FilterItem(
      false,
      'Status',
    ),
    new FilterItem(
      false,
      'Female Status',
    ),
    new FilterItem(
      false,
      'Animal Age',
    ),
  ];
  List<Map<String,String>> _animalTypeOptions = [
    { 'text': 'Male', 'value': 'Male' },
    { 'text': 'Female', 'value': 'Female' },
  ];
  List<Map<String,String>> _animalStatusOptions = [
    { 'text': 'Active', 'value': 'Active' },
    { 'text': 'Retired', 'value': 'Retired' },
  ];
  List<Map<String,String>> _animalFemaleTypeOptions = [
    { 'text': 'Dry', 'value': 'Dry' },
    { 'text': 'Milking', 'value': 'Milking' },
  ];
  List<Map<String,String>> _animalAgeOptions = [
    { 'text': 'Less then 3 month', 'value': 'less_than_3_month' },
    { 'text': 'Less then 6 month', 'value': 'less_than_six' },
    { 'text': 'Less then 1 year', 'value': 'less_then_one' },
    { 'text': 'Less then 1.6 Year', 'value': 'less_then_one_point_six' },
    { 'text': 'More then 1.6 Year', 'value': 'more_then_one_pont_six' },
  ];
  List<Map<String,String>> _animalMarketOptions = [
    { 'text': 'Jhang Market', 'value': 'jhang_market' },
    { 'text': 'Multan Market', 'value': 'multan_market' },
    { 'text': 'Ludan Market', 'value': 'ludan_market' },
  ];
  List<Map<String,String>> _animalRatingsOptions = [
    { 'text': '1 Star', 'value': '1' },
    { 'text': '2 Star', 'value': '2' },
    { 'text': '3 Star', 'value': '3' },
    { 'text': '4 Star', 'value': '4' },
    { 'text': '5 Star', 'value': '5' },
  ];

  Map<String, dynamic> _filterBy = {
    // 'animal_type': '',
    // 'price_range': RangeValues(1, 100),
    // 'category': -1,
    // 'animal_age': '',
    // 'search_by_market': '',
    // 'rating': '',

    'animal_type':[],
    'animal_status':[],
    'animal_female_type':[],
    'animal_age':[]
  };

  initState(){
    super.initState();
    _fetchAllData();
  }

  void _fetchAllData() async {
    await _fetchCategories();
    await _fetchAnimals();
    _filter();
    setState(() => _fetchingData = false);
  }

  void _fetchAnimals () async {
    try{
      Response res = await dio.get('/livestock_listing/');
      Map<String, dynamic> data = jsonDecode(res.data);
      _animals = data['all_animal_list'];
      Store.setAllAnimal(_animals);
    }catch(e){
      print('GET_ANIMAL_LIST_ERROR');
      print(e);
    }
    
  }
  void _fetchCategories () async {
    Response res = await dio.get("/all_category/",);
    Map<String, dynamic> data = jsonDecode(res.data);
    List<dynamic> cats = new List<dynamic>();
    _categories = cats + data['all_categories'];
  }

  Widget _filterOptionHorizontalContainer(filterVal, value, text){
    return Container(
      height: 29,
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.symmetric(horizontal: 10,),
      decoration: BoxDecoration(
        color: filterVal.contains(value) ? Theme.of(context).primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Theme.of(context).primaryColor
        )
      ),
      child: Center(child: Text(text, style: TextStyle(
        fontSize: 13,
        color: filterVal.contains(value) ? Colors.white : Theme.of(context).primaryColor,
      ),),)
    );
  }

  void _filter() async {
    setState(() => _fetchingData = true);
    List<dynamic> _tempAnimals = _animals;
    try{
      var obj = {};
      _filterBy['animal_type'].forEach((element) {
        if(element == 'Male') obj['Male'] = element;
        else if(element == 'Female') obj['Female'] = element;
      });
      _filterBy['animal_status'].forEach((element) {
        if(element == 'Active') obj['active_status'] = element;
        else if(element == 'Retired') obj['retired_category'] = element;
      });
      _filterBy['animal_female_type'].forEach((element) {
        if(element == 'Dry') obj['dry_female_status'] = element;
        else if(element == 'Milking') obj['milking_status'] = element;
      });
      _filterBy['animal_age'].forEach((element) {
        if(element == 'less_than_3_month') obj['less_than_3_month'] = element;
        else if(element == 'less_than_six') obj['less_than_six'] = element;
        else if(element == 'less_then_one') obj['less_then_one'] = element;
        else if(element == 'less_then_one_point_six') obj['less_then_one_point_six'] = element;
        else if(element == 'more_then_one_pont_six') obj['more_then_one_pont_six'] = element;
      });
      FormData formData = new FormData.fromMap(obj);
      Response res = await dio.post('/search_listing/', data: formData);
      Map<String, dynamic> data = jsonDecode(res.data);
      _tempAnimals = data['all_animal_list'];
    }catch(e){
      print('GET_CATEGORY_WISE_ANIMAL_LIST_ERROR');
      print(e);
    }
    _filteredAnimals = _tempAnimals;
    setState(() => _fetchingData = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(child: AppBar(
        title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            height: 20,
            width: 20,
            child: InkWell(
              child: SvgPicture.asset('lib/assets/svg/back.svg',),
              onTap: (){
                Navigator.pop(context);
              },
            ),
          ),
          Text('Animal List', style: TextStyle(
            fontSize: 18,
            color: Colors.white
          ),),
          Container(
            margin: EdgeInsets.only(right: 10),
            child: InkWell(
              child: SvgPicture.asset('lib/assets/svg/filter.svg'),
              onTap: _fetchingData ? null : (){
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
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height - 200,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                              ),
                            ),
                            child: Column(children: [Expanded(child: ListView(children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 15), 
                                child: Text('Filter', style: TextStyle(
                                  fontSize: 25,
                                  color: Theme.of(context).primaryColor,
                                  decoration: TextDecoration.none
                                ),),
                              ),
                              SizedBox(height: 20,),

                              ExpansionPanelList(
                                expansionCallback: (int index, bool isExpanded) {
                                  setState(() {
                                    _filterItems[index].isExpanded = !_filterItems[index].isExpanded;
                                  });
                                },
                                elevation: 0,
                                expandedHeaderPadding: EdgeInsets.all(0),
                                dividerColor: Colors.transparent,
                                children: _filterItems.map<ExpansionPanel>((FilterItem item) {
                                  return new ExpansionPanel(
                                    canTapOnHeader: true,
                                    headerBuilder: (BuildContext context, bool isExpanded) {
                                      return new ListTile(
                                          title: new Text(
                                            item.header,
                                            textAlign: TextAlign.left,
                                            style: new TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ));
                                    },
                                    isExpanded: item.isExpanded,
                                    body: item.header == 'Animal Type' ? 
                                      Container( margin: EdgeInsets.symmetric(horizontal: 15), height: 29, child: ListView(scrollDirection: Axis.horizontal, children: _animalTypeOptions.map((animalType) => InkWell(
                                        child: _filterOptionHorizontalContainer(_filterBy['animal_type'], animalType['value'], animalType['text']),
                                        onTap: () => setState( () {
                                          if(_filterBy['animal_type'].contains(animalType['value'])){
                                            _filterBy['animal_type'].remove(animalType['value']);
                                          }else{
                                            _filterBy['animal_type'].add(animalType['value']);
                                          }
                                        }),),
                                      ).toList(),),) : item.header == 'Status' ?
                                      Container( margin: EdgeInsets.symmetric(horizontal: 15), height: 29, child: ListView(scrollDirection: Axis.horizontal, children: _animalStatusOptions.map((status) => InkWell(
                                        child: _filterOptionHorizontalContainer(_filterBy['animal_status'], status['value'], status['text']),
                                        onTap: () => setState( () {
                                          if(_filterBy['animal_status'].contains(status['value'])){
                                            _filterBy['animal_status'].remove(status['value']);
                                          }else{
                                            _filterBy['animal_status'].add(status['value']);
                                          }
                                        }),),
                                      ).toList(),),) : item.header == 'Female Status' ?
                                      Container( margin: EdgeInsets.symmetric(horizontal: 15), height: 29, child: ListView(scrollDirection: Axis.horizontal, children: _animalFemaleTypeOptions.map((status) => InkWell(
                                        child: _filterOptionHorizontalContainer(_filterBy['animal_female_type'], status['value'], status['text']),
                                        onTap: () => setState( () {
                                          if(_filterBy['animal_female_type'].contains(status['value'])){
                                            _filterBy['animal_female_type'].remove(status['value']);
                                          }else{
                                            _filterBy['animal_female_type'].add(status['value']);
                                          }
                                        }),),
                                      ).toList(),),) : item.header == 'Animal Age' ?
                                      Container( margin: EdgeInsets.symmetric(horizontal: 15), height: 29, child: ListView(scrollDirection: Axis.horizontal, children: _animalAgeOptions.map((animalAge) => InkWell(
                                        child: _filterOptionHorizontalContainer(_filterBy['animal_age'], animalAge['value'], animalAge['text']),
                                        onTap: () => setState( () {
                                          if(_filterBy['animal_age'].contains(animalAge['value'])){
                                            _filterBy['animal_age'].remove(animalAge['value']);
                                          }else{
                                            _filterBy['animal_age'].add(animalAge['value']);
                                          }
                                        } ),),
                                      ).toList(),),) : 
                                      Container( ),
                                  );
                                }).toList(),
                              ),

                              SizedBox(height: 50,),

                              Container(
                                margin: EdgeInsets.symmetric(horizontal: PERCENT(MediaQuery.of(context).size.width, 15)),
                                child: BUTTON(
                                  borderRadius: 50.0,
                                  color: Theme.of(context).primaryColor,
                                  text: 'Apply Filter',
                                  fontSize: 18.0,
                                  textColor: Colors.white,
                                  onPressed: (){
                                    Navigator.pop(context);
                                    _filter();
                                  }
                                ),
                              ),

                              SizedBox(height: 50,),

                            ],),),],),
                          ),
                        );
                      },
                    );
                  },
                  transitionBuilder: (context, anim1, anim2, child) {
                    return SlideTransition(
                      position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
                      child: child,
                    );
                  },
                );
              },
            ),
          ),
        ],),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
      ), preferredSize: Size.fromHeight(70)),

      body: _fetchingData ? Center(child: CircularProgressIndicator(),) : Container(
        // color: Color.fromRGBO(229, 229, 229, 1.0),
        child: Column(children: [
          Expanded(child: Container(
            child: ListView(children: [
              Container(margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10), height: 23, child: ListView(scrollDirection: Axis.horizontal, children: [1,2,3,4].map((n) => Container(
                  height: 50,
                  width: 77,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(23),
                  ),
                  child: Center(child: Text('None', style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  ),),),
                )).toList(),),
              ),

              SizedBox(height: 30,),

              Container(margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
                Text('Add Animals', style: TextStyle(
                  fontSize: 18
                ),),
                InkWell(child: Container(
                  height: 32, 
                  width: 34, 
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(child: SvgPicture.asset('lib/assets/svg/plus.svg')),
                ),onTap: () => Navigator.pushNamed(context, '/farm_animal_form'),),
              ],),),

              SizedBox(height: 30,),

              Container(child: Column(children: _filteredAnimals.map((animal) => InkWell(child: Container(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 103,
                  width: MediaQuery.of(context).size.width - 40,
                  margin: EdgeInsets.only(bottom: 20),
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
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(image: NetworkImage(animal['image']), fit: BoxFit.fill)   
                        ),
                      ),
                      Container(width: MediaQuery.of(context).size.width - 40 - 20 - 80 - 87 - 15, margin: EdgeInsets.only(left: 10), child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(animal['id'].toString() + ' '+ animal['animal_tag'], style: TextStyle(
                          fontSize: 18,
                          color: Color.fromRGBO(31, 48, 111, 1.0)
                        ),textAlign: TextAlign.left, overflow: TextOverflow.ellipsis,),
                        SizedBox(height: 5 ),
                        // Text(
                        //   animal['year_result'] > 0 ? 'Age ${animal["year_result"]} year'
                        //   : animal['month_result'] > 0 ? 'Age ${animal["month_result"]} month'
                        //   : 'Age ${animal["day_result"]} day'
                        // , style: TextStyle(
                        //   fontSize: 16,
                        //   color: Color.fromRGBO(111, 123, 162, 1.0)
                        // ), textAlign: TextAlign.left,),
                      ],),),
                    ],),),

                    Container(
                      height: 30,
                      width: 87,
                      decoration: BoxDecoration(
                        color: animal['animal_type'] == 'Dry' ? Color.fromRGBO(255, 0, 0, 1.0) 
                        : animal['animal_type'] == 'Pregnant' ? Color.fromRGBO(0, 178, 45, 1.0)
                        : animal['animal_type'] == 'Milking' ? Color.fromRGBO(2, 183, 147, 1.0)
                        : Color.fromRGBO(255, 107, 107, 1.0),
                        borderRadius: BorderRadius.circular(19.5)
                      ),
                      child: Center(child: Text(animal['animal_type'], style: TextStyle(
                        fontSize: 13,
                        color: Colors.white
                      ),),),
                    ),  
                  ]),
                ),
              ), onTap: (){
                Navigator.pushNamed(context, '/animal_details/' + animal["id"].toString());
              },),).toList()),),


            ],),
          ),),
        ],),
      ),
    );
  }
}

class FilterItem {
  bool isExpanded;
  final String header;
  // final Widget body;
  // FilterItem(this.isExpanded, this.header, this.body);
  FilterItem(this.isExpanded, this.header);
}