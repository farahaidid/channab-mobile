import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences _pref;

class Store{
  static Store _store;

  static shared(){
    if(_store==null){
      _store = new Store();
      return _store;
    }else{
      return _store;
    }
  }

  Future<void> initialize()async{
    if(_pref == null){
      _pref = await SharedPreferences.getInstance();
    }
  }
}