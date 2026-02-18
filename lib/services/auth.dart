import 'dart:convert';

import 'package:danish_apis/models/login.dart';
import 'package:danish_apis/models/register.dart';
import 'package:danish_apis/models/user.dart';
import 'package:http/http.dart' as http;

class AuthService{
  String baseUrl = "https://todo-nu-plum-19.vercel.app";

  ///Register User
  Future<RegisterModel> registerUser({
    required String name,
    required String email,
    required String password,
})async{
    try{
      http.Response response = await http.post(
        Uri.parse("$baseUrl/users/register"),
        headers: {
          "Content-Type":"application/json"
        },
        body: jsonEncode({
          "name":name,
          "email":email,
          "password":password
        })
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        return RegisterModel.fromJson(jsonDecode(response.body));
      }else{
        throw response.reasonPhrase.toString();
      }
    }catch(e){
      throw e.toString();
    }
  }
  ///Login User
  Future<LoginModel> loginUser({
    required String email,
    required String password,
  })async{
    try{
      http.Response response = await http.post(
          Uri.parse("$baseUrl/users/login"),
          headers: {
            "Content-Type":"application/json"
          },
          body: jsonEncode({
            "email":email,
            "password":password
          })
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        return LoginModel.fromJson(jsonDecode(response.body));
      }else{
        throw response.reasonPhrase.toString();
      }
    }catch(e){
      throw e.toString();
    }
  }
  ///Get Profile
  Future<UserModel> getProfile({
    required String token,
  })async{
    try{
      http.Response response = await http.get(
          Uri.parse("$baseUrl/users/profile"),
          headers: {
            "Authorization": token
          },
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        return UserModel.fromJson(jsonDecode(response.body));
      }else{
        throw response.reasonPhrase.toString();
      }
    }catch(e){
      throw e.toString();
    }
  }
  ///Update Profile
  Future<bool> updateProfile({
    required String token,
    required String name,
  })async{
    try{
      http.Response response = await http.put(
        Uri.parse("$baseUrl/users/profile"),
        headers: {
          "Authorization": token,
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          "name":name,
        })
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        return true;
      }else{
        throw response.reasonPhrase.toString();
      }
    }catch(e){
      throw e.toString();
    }
  }
}