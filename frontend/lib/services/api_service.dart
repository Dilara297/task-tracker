import 'package:gorev_takip_flutter/models/task.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  Future<List<Task>> getTasks()async{
    final response=await http.get(
      Uri.parse("http://127.0.0.1:8000/api/tasks/")
    );
    if(response.statusCode==200){// eger istek başarılıysa devam et
      final json=jsonDecode(response.body);

      final tasks=(json["results"]as List)
        .map((item)=> Task.fromJson(item))
        .toList();

    return tasks;
    }else{
      throw Exception("görevler alınamadı");
    }
    
  }
}
