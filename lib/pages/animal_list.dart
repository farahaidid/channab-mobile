import 'dart:convert';

import 'package:channab/dio/dio.dart';
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

  initState(){
    super.initState();
    _fetchAllData();
  }

  void _fetchAllData() async {
    await _fetchAnimals();
    setState(() => _fetchingData = false);
  }

  void _fetchAnimals () async {
    try{
      Response res = await dio.get('/livestock_listing/');
      Map<String, dynamic> data = jsonDecode(res.data);
      _animals = data['all_animal_list'];
    }catch(e){
      print('GET_ANIMAL_LIST_ERROR');
      print(e);
    }
    
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
              onTap: (){},
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
                Container(
                  height: 32, 
                  width: 34, 
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(child: SvgPicture.asset('lib/assets/svg/plus.svg')),
                ),
              ],),),

              SizedBox(height: 30,),

              Container(child: Column(children: _animals.map((animal) => InkWell(child: Container(
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
                        Text(
                          animal['year_result'] > 0 ? 'Age ${animal["year_result"]} year'
                          : animal['month_result'] > 0 ? 'Age ${animal["month_result"]} month'
                          : 'Age ${animal["day_result"]} day'
                        , style: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(111, 123, 162, 1.0)
                        ), textAlign: TextAlign.left,),
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