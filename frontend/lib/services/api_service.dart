import 'package:flutter/material.dart';
import 'package:gorev_takip_flutter/models/task.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  Future<List<Task>> getTasks()async{
    final url =Uri.parse("http://127.0.0.1:8000/api/tasks/");

    final prefs = await SharedPreferences.getInstance();
    final token =prefs.getString("token");

    final response=await http.get(
      url,
      headers: {
        "Authorization":"Token $token",//"Authorization" isimli header'ın değeri "Token $token" olsun.
      },
      );
    if(response.statusCode==200){// eger istek başarılıysa devam et
      final json=jsonDecode(response.body);

      final tasks=(json["results"]as List)
      
        .map((item)=> Task.fromJson(item))
        .toList();

    return tasks;
    }else{
      throw Exception("görevler alınamadı: ${response.statusCode} - ${response.body}");
    }
    
  }
  Future<Task> addTask(
    String title,
    String description,
  ) async{
    final url =Uri.parse("http://127.0.0.1:8000/api/tasks/");

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final body={
      "title":title,
      "description":description,
    };

    final response = await http.post(
      url,
      headers: {
        "Content-Type":"application/json",
        "Authorization":"Token $token",
      },
      body:jsonEncode(body),
    );
   
    if (response.statusCode==201){
      final json = jsonDecode(response.body);
      return Task.fromJson(json);
    }else{
     
      throw Exception("Görev eklenemedi");
    }
  
  }

  Future <Map<String,dynamic>> login(
    String username,
    String password,
  ) async{
    final url = Uri.parse("http://127.0.0.1:8000/api/login/");

    final body ={
      "username":username,
      "password":password,
    };

    final response =await http.post(
      url,
      headers:{
        "content-Type":"application/json",
      },
      body:jsonEncode(body),
    );
    if(response.statusCode==200){
      final data = jsonDecode(response.body);
      return data;
    }else{
     
      throw Exception("Giriş Yapılamadı");
    }
    }

    Future<Map<String,dynamic>> register(
      String username,
      String email,
      String password,
      String password2,
    )async{
      final url=Uri.parse("http://127.0.0.1:8000/api/register/");

      final body={
        "username":username,
        "email":email,
        "password":password,
        "password2":password2,
      };
      final response = await http.post(
        url,
        headers: {
          "Content-Type":"application/json",
        },
        body: jsonEncode(body),
        );

        if(response.statusCode==201){
          final data= jsonDecode(response.body);
          return data;        
        }else{
          throw Exception("kayıt başarısız");
        }
    }

  }
