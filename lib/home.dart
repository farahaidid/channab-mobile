import 'package:channab/store/store.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              child: Center(
                child: Text('CHANNAB', style: TextStyle(fontSize: 40),),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add A Farm Animal', style: TextStyle(fontSize: 15.0) ),
              onTap: () {
                Navigator.pushNamed(context, '/farm_animal_form');
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Animal List', style: TextStyle(fontSize: 15.0) ),
              onTap: () {
                Navigator.pushNamed(context, '/animal_list');
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout', style: TextStyle(fontSize: 15.0) ),
              onTap: () {
                Store.clearStore();
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: Center(
          child: Text('WELCOME', style: TextStyle(fontSize: 40),),
        ),
      ),
    );
  }
}