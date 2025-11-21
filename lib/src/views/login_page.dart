import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lectura_app/src/shared/utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final correoController = TextEditingController();
  final contraseniaController = TextEditingController();

  //bool _isLoading = false;
  bool obscurePassword = true;

  Future<UserCredential?> _handleGoogleSignIn() async {
    try {
      final GoogleSignIn signIn = GoogleSignIn.instance;

      await signIn.initialize();
      final GoogleSignInAccount googleAuth = await signIn.authenticate();

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.authentication.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } 
    catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB8E0D2), Color(0xFFA3B18A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),

                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Inicio de sesión",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF344E41),
                        ),
                      ),

                      const SizedBox(height: 24),

                      TextFormField(
                        controller: correoController,
                        cursorColor: Color(0xFF3A5A40),
                        decoration: InputDecoration(
                          labelText: "Correo electrónico",
                          prefixIcon: Icon(Icons.email),
                          floatingLabelStyle: TextStyle(
                            color: Color(0xFF3A5A40),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF3A5A40)),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: contraseniaController,
                        obscureText: obscurePassword,
                        cursorColor: Color(0xFF3A5A40),
                        decoration: InputDecoration(
                          labelText: "Contraseña",
                          prefixIcon: Icon(Icons.lock),

                          floatingLabelStyle: TextStyle(
                            color: Color(0xFF3A5A40),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(
                                () => obscurePassword = !obscurePassword,
                              );
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF3A5A40)),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF588157),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 6,
                          ),

                          onPressed: () async {
                            Utils.showSnackBar(
                              context: context,
                              title: "Debe iniciar sesion por Google",
                              color: Colors.red[300],
                              duracion: Duration(seconds: 2),
                            );
                            await Future.delayed(Duration(seconds: 2));
                            correoController.text = '';
                            contraseniaController.text = '';
                          },
                          child: Text(
                            "Iniciar sesión",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(width: 2, color: Color(0xFF3E7CB1)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          minimumSize: Size(double.infinity, 50),
                        ),

                        onPressed: () async {
                          Utils.showSnackBar(
                            context: context,
                            title: "Iniciando sesión con Google...",
                            color: Colors.blue,
                            duracion: Duration(seconds: 2),
                          );

                          final result = await _handleGoogleSignIn();

                          if (result != null) {
                            if (context.mounted) {
                              Utils.showSnackBar(
                                context: context,
                                title: "Bienvenido",
                                color: Colors.green,
                                duracion: Duration(seconds: 2),
                              );
                              context.replace("/libro");
                            }
                          } else {
                            if (context.mounted) {
                              Utils.showSnackBar(
                                context: context,
                                title: "No se pudo iniciar sesión con Google",
                                duracion: Duration(seconds: 2),
                              );
                            }
                          }
                        },

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/google.png",
                              width: 25,
                              height: 25,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "Continuar con Google",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "StackSansHeadline",
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3E7CB1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
