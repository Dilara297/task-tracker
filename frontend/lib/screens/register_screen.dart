import 'package:flutter/material.dart';
import 'package:gorev_takip_flutter/services/api_service.dart';
import 'package:gorev_takip_flutter/screens/LoginScreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController password2Controller = TextEditingController();

  bool isLoading = false; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF), 
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade100, 
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "KAYIT OL",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "Yeni Hesap Oluştur",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          TextField(
                            controller: usernameController,
                            decoration: InputDecoration(
                              hintText: "Kullanıcı Adı",
                              prefixIcon: const Icon(Icons.person_outline),
                              filled: true,
                              fillColor: const Color(0xFFF8F5FF),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: "E-posta",
                              prefixIcon: const Icon(Icons.email_outlined),
                              filled: true,
                              fillColor: const Color(0xFFF8F5FF),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "Şifre",
                              prefixIcon: const Icon(Icons.lock_outline),
                              filled: true,
                              fillColor: const Color(0xFFF8F5FF),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: password2Controller,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "Şifre Tekrar",
                              prefixIcon: const Icon(Icons.lock_reset_outlined),
                              filled: true,
                              fillColor: const Color(0xFFF8F5FF),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(double.infinity, 56),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (passwordController.text != password2Controller.text) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Şifreler eşleşmiyor!")),
                                      );
                                      return;
                                    }

                                    setState(() => isLoading = true);
                                    try {
                                      final apiService = ApiService();
                                      await apiService.register(
                                        usernameController.text,
                                        emailController.text,
                                        passwordController.text,
                                        password2Controller.text,
                                      );
                                      
                                      if (!mounted) return;

                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const Loginscreen(),
                                        ),
                                      );
                                    } catch (e) {
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Bir hata oluştu, bilgileri kontrol edin.")),
                                      );
                                    } finally {
                                      if (mounted) {
                                        setState(() => isLoading = false);
                                      }
                                    }
                                  },
                                  child: const Text("KAYIT OL", style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Zaten hesabın var mı?", style: TextStyle(color: Colors.grey)),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const Loginscreen()),
                                  );
                                },
                                child: const Text(
                                  "GİRİŞ YAP",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}