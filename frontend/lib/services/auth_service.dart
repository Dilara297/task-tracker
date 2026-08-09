import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<void> saveToken(String token)async{
    final prefs =await SharedPreferences.getInstance();
    // bana sharedpreferences sınıfına erişebilecegim bir nesne ver bu nesneyi prefs isimli degişkene koy

    await prefs.setString("token", token);
    //"token" anahtarı altında token degişkeninin içindeki string degeri sakla(kaydet)
  }

  Future<void> logout() async{
    final prefs = await SharedPreferences.getInstance();//yerel depoya eriş
    await prefs.remove("token");//.clear()sharedpreferences içindeki butun kayıtları sil
    //.remove("token") sadeec tokeni sil 

  }



}