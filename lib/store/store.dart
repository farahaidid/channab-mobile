import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences _pref;
final PIN_KEY = 'pin';
final IS_LOGGED_KEY = 'isLogged';
final TOKEN_KEY = 'token';
final USER_INFO = 'user_info';


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

  static String getPin(){
    return _pref.getString(PIN_KEY);
  }
  static void setPin(p){
    _pref.setString(PIN_KEY, p);
  }

  static String getToken(){
    return _pref.getString(TOKEN_KEY);
  }
  static void setToken(p){
    _pref.setString(TOKEN_KEY, p);
  }

  static bool isLogged(){
    if(_pref.getBool(IS_LOGGED_KEY) == null) return false;
    return _pref.getBool(IS_LOGGED_KEY);
  }
  static void setIsLogged(p){
    _pref.setBool(IS_LOGGED_KEY, p);
  }

  static void setUserInfo(String p){
    _pref.setString(USER_INFO, p);
  }
  static Map<String,dynamic> getUserInfo(){
    if(_pref.getString(USER_INFO) == null) return null;
    return jsonDecode(_pref.getString(USER_INFO));
  }



  static void clearStore(){
    _pref.clear();
  }

}