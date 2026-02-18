import 'dart:convert';

import 'package:danish_apis/models/taskListing.dart';
import 'package:http/http.dart' as http;

class TaskService{

  String baseUrl = "https://todo-nu-plum-19.vercel.app";

  ///Create Task
  ///Get All Task
  ///Mark As Completed Task
  ///Get Completed Task
  ///Get inCompleted Task
  ///Update Task
  ///Delete Task
  ///Filter Task
  Future<TaskListingModel> filterTask({
    required String token,
    required String startDate,
    required String endDate,
  })async{
    try{
      http.Response response = await http.get(
          Uri.parse("$baseUrl/todos/filter?startDate=$startDate&endDate=$endDate"),
          headers: {
            "Authorization":token
          },
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        return TaskListingModel.fromJson(jsonDecode(response.body));
      }else{
        throw response.reasonPhrase.toString();
      }
    }catch(e){
      throw e.toString();
    }
  }
  ///Search Task
  Future<TaskListingModel> searchTask({
    required String token,
    required String keyword,
  })async{
    try{
      http.Response response = await http.get(
        Uri.parse("$baseUrl/todos/search?keywords=$keyword"),
        headers: {
          "Authorization":token
        },
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        return TaskListingModel.fromJson(jsonDecode(response.body));
      }else{
        throw response.reasonPhrase.toString();
      }
    }catch(e){
      throw e.toString();
    }
  }
}