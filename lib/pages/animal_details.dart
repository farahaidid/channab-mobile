import 'dart:convert';

import 'package:channab/dio/dio.dart';
import 'package:channab/shared/common.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  List<Map<String,dynamic>> _menu = [
    {'text':'Health', 'value': 'health'},
    {'text':'Family', 'value': 'family'},
    {'text':'Milking', 'value': 'milking'},
    {'text':'Gallery', 'value': 'gallery'},
    {'text':'Description', 'value': 'description'},
  ];

  String _selectedMenu = 'health';
  String _filterMilkingBy = 'complete';

  initState(){
    super.initState();
    _fetchAllData();
  }

  void _fetchAllData() async {
    await _fetchAnimalDetails();
    setState(() => _fetchingData = false);
  }

  void _fetchAnimalDetails () async {
    try{
      Response res = await dio.get('/view_particular_element/?product_id=' + widget.id.toString());
      Map<String, dynamic> data = jsonDecode(res.data);
      _animalDetails = data;
      print(_animalDetails);
    }catch(e){
      print('GET_ANIMAL_DETAILS_ERROR');
      print(e);
    }
    
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
            Container(
              height: 40, 
              width: 40, 
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(child: SvgPicture.asset('lib/assets/svg/plus.svg')),
            ),
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
          ] + _animalDetails['male_parents_animal']['animal_tag'] == null ? [] : [_animalDetails['male_parents_animal'] , _animalDetails['female_parents_of_animals']].map<Widget>((parent) =>
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