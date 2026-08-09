import 'package:flutter/material.dart';
import 'package:gorev_takip_flutter/services/api_service.dart';
import 'package:gorev_takip_flutter/screens/LoginScreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
final TextEditingController usernameController= TextEditingController();
final TextEditingController emailController=TextEditingController();
final TextEditingController passwordController=TextEditingController();
final TextEditingController password2Controller=TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("KAYIT OL"),),
      body:Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment:MainAxisAlignment.center ,
          children: [
            const Text("KAYIT OL"),

            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                hintText: "kullanıcı adı"
              ),
            ),
            SizedBox(
              height: 16,
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "email",
              ),
            ),
            SizedBox(
              height: 16,
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "şifre",
              ),
            ),
            SizedBox(
              height: 16,
            ),
            TextField(
              controller: password2Controller,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "şifre tekrar",
              ),
            ),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () async{
                try{
                  final apiService=ApiService();

                  final result = await apiService.register(
                    usernameController.text,
                    emailController.text,
                    passwordController.text,
                    password2Controller.text,
                  );
                  if(!mounted);

                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (context)=>const Loginscreen(),
                    ),
                  );

                }catch (e){
                  print(e);

                }
                


            }, 
              child: const Text("KAYIT OL"),),
          ]

        ),
      ) ,
    );
  }
}