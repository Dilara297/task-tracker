import 'package:flutter/material.dart';
import 'package:gorev_takip_flutter/services/api_service.dart';
import 'package:gorev_takip_flutter/services/auth_service.dart';
import 'package:gorev_takip_flutter/screens/home_screen.dart';
import 'package:gorev_takip_flutter/screens/register_screen.dart';
class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
final TextEditingController usernameController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Giriş yap"),),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Hesabına Giriş Yap"),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                hintText:"Kullanıcı Adı"
              ),
            ),
            SizedBox(
              height: 16,
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Şifre"
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: ()async{
                try{
                  final apiService=ApiService();

                  final result = await apiService.login(
                    usernameController.text,
                    passwordController.text,
                  );
                  final token =result["token"];

                  final authService = AuthService();
                  await authService.saveToken(token);

                  if(!mounted)return;//mounted:"Bu widget hâlâ Flutter widget ağacında mevcut mu?"

                  Navigator.pushReplacement(//Bu yüzden kullanıcı başarılı login'den sonra geri tuşuna basarak eski login ekranına dönmüyor.
                    context, 
                    MaterialPageRoute(
                      builder: (context)=> const HomeScreen(),
                      ),
                      );

                }catch (e){
                  print(e);
                }
                 
              }, 
              child: const Text("GİRİŞ YAP"),
              ),
              SizedBox(
                height: 16,
              ),
            Row(children: [
              const Text("hesabın yok mu?"),
              SizedBox(
                width: 8,
              ),
              TextButton(
                onPressed: (){
                  Navigator.push(context, 
                  MaterialPageRoute(builder: (context)=> const RegisterScreen(),
                  ),
                );
                }, 
                child: const Text("KAYIT OL"),
                ),
            ],
            ), 
          ],
        ),
        ),

    );
  }
}