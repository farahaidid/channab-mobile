import 'dart:convert';

import 'package:channab/store/auth.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class AnimalForm extends StatefulWidget {
  @override
  _AnimalFormState createState() => _AnimalFormState();
}

class _AnimalFormState extends State<AnimalForm> {
  double screenWidth = 0;
  final animalForm = GlobalKey<FormState>();
  int _categoryId = -1;
  List<dynamic> _categories = [];
  final _marketOptions = <MultiSelectDialogItem<int>>[
    MultiSelectDialogItem(1, 'Jhang Cattle Market'),
    MultiSelectDialogItem(2, 'Multan Cattle Market'),
    MultiSelectDialogItem(3, 'Ludan Market Vehari'),
  ];
  List _selectedMarkets = [1];

  List<String> _typeOptions = ['Select Type', 'Dry', 'Milking', 'Breader'];
  String _type = 'Select Type';

  bool _fetchingData = true;

  initState(){
    super.initState();
    _fetchAllData();
  }

  void _fetchAllData() async {
    await fetchCategories();
    setState(() => _fetchingData = false);
  }

  void fetchCategories () async {
    Dio dio = new Dio();

    Response res = await dio.get("https://channab.com/api/all_category/", options: Options(
      headers: {
        "token" : TOKEN
      }
    ));

    Map<String, dynamic> data = jsonDecode(res.data);

    List<dynamic> cats = new List<dynamic>();
    cats.add({'name_of_category': 'Select Category', 'id': -1});
    _categories = cats + data['all_categories'];

    print(_categories);
    
  }

  void _showMarketOptions()async{
    final selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: _marketOptions,
          initialSelectedValues: _selectedMarkets.toSet(),
        );
      },
    );
  }

  double width(per){
    return (screenWidth * per) / 100;
  }
  

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add an animal'),
      ),
      body: _fetchingData ? Center(
        child: CircularProgressIndicator(),
      ) : Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: animalForm,
          child: ListView(
            children: [
              Container(
                child: Text('Animal Detail'),
              ),
              Container(
                child: Row(
                  children: [
                    Container(
                      width: width(45),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Animal Title'
                        ),
                      ),
                    ),
                    SizedBox(width: width(2),),
                    Container(
                      width: width(45),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Year'
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: screenWidth,
                child: Row(
                  children: [
                    Container(
                      width: width(45),
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
                    SizedBox(width: width(2),),
                    Container(
                      width: width(45),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      child: InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Please Select'),
                            Icon(Icons.arrow_drop_down)
                          ],
                        ),
                        onTap: () {
                          _showMarketOptions();
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: screenWidth,
                child: Row(
                  children: [
                    Container(
                      width: width(45),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Price'
                        ),
                      )
                    ),
                    SizedBox(width: width(2),),
                    Container(
                      width: width(45),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Mobile Number'
                        ),
                      )
                    ),
                  ],
                ),
              ),

              Container(
                width: screenWidth,
                child: Row(
                  children: [
                    Container(
                      width: width(45),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'City'
                        ),
                      )
                    ),
                    SizedBox(width: width(2)),
                    Container(
                      width: width(45),
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<String>(
                            value: _type,
                            items: _typeOptions.map((x) => DropdownMenuItem<String>(
                              value: x,
                              child: Text(
                                x,
                                textAlign: TextAlign.left,
                              ),
                            ))
                            .toList(),
                            onChanged: (val) => setState(() {
                              _type = val;
                            }),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                child: TextFormField(
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Description'
                  ),
                ),
              ),
            ]
          )
        ),
      ),
    );
  }
}

class MultiSelectDialogItem<V> {
  const MultiSelectDialogItem(this.value, this.label);

  final V value;
  final String label;
}

class MultiSelectDialog<V> extends StatefulWidget {
  MultiSelectDialog({Key key, this.items, this.initialSelectedValues}) : super(key: key);

  final List<MultiSelectDialogItem<V>> items;
  final Set<V> initialSelectedValues;

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
}

class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
  final _selectedValues = Set<V>();

  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues);
    }
  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select animals'),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: _onCancelTap,
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: _onSubmitTap,
        )
      ],
    );
  }

  Widget _buildItem(MultiSelectDialogItem<V> item) {
    final checked = _selectedValues.contains(item.value);
    return CheckboxListTile(
      value: checked,
      title: Text(item.label),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.value, checked),
    );
  }
}