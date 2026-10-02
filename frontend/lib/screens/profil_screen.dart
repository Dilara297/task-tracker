import 'package:flutter/material.dart';
import 'package:gorev_takip_flutter/services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final ApiService apiService=ApiService();
  bool isLoading= true;
  String? errorMessage;

  Map<String,dynamic>? profile;

  @override
  void initState(){
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile()async{
    setState(() {
      isLoading=true;
      errorMessage=null;
    });
  
  try{
    final gelenProfile = await apiService.getProfile();
    if(!mounted) return;

    setState(() {
      profile=gelenProfile;
      isLoading=false;
    });
  }catch (e){
    if(!mounted)return;
    setState(() {
      errorMessage= e.toString();
      isLoading=false;
    });
  }

  }
  @override
  Widget build(BuildContext context) {
    Widget body;

    if(isLoading){
      body= const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Profil yükleniyor...")
          ],
        ),
      );
    }else if(errorMessage !=null){
      body =Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error,
              size: 48,
              color: Colors.amberAccent,
            ),

            const SizedBox(height: 16),
            Text(errorMessage!),

            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: ()async{
                await loadProfile();
              }, 
              child: const Text("Tekrar deneyin"),
              ),
          ],
        ),
      );
    }else{
      body = SizedBox(
        width: double.infinity,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.deepPurple.shade50,
              child: const Icon(
                Icons.person,
                size:50,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),

            Text(
              profile!["username"],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              profile!["email"],
              style: const TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),

        Row(
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        profile!["total_tasks"].toString(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Toplam görev",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        profile!["completed_tasks"].toString(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Tamamlanan görev",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                  ),
              )
              ),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          profile!["todo_tasks"].toString(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Devam eden görev",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    ),
                )
                ),
        ],
        ),
          ],
        ),
        

        );
    }



    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
      ),
      body: body ,  
    );
  }
}