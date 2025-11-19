import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lectura_app/src/shared/utils.dart';
import 'package:lectura_app/src/widgets/mytextfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final correoController = TextEditingController();
  final contraseniaController = TextEditingController();

  bool _isLoading = false;
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

    } catch (e) {
      print('Error en Goggle Sign-In $e');
      return null;
    }
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _isLoading = false);
        if (context.mounted) {
          Utils.showSnackBar(
            context: context,
            title: 'Debes de iniciar sesión con Google',
            duracion: Duration(seconds: 2),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 89, 139, 77),
        title: const Center(
          child: Text('Inicio de sesion', style: TextStyle(fontSize: 30)),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyTextfield(
                obscuretext: false,
                type: TextInputType.emailAddress,
                controller: correoController,
                texto: 'Ingrese su correo',
                tamaniotexto: 20,
                pmargin: const EdgeInsets.all(15),
                ppadding: const EdgeInsets.all(15),
                radio: 20,
                color: Color(0xFFDAD7CD),
              ),

              SizedBox(height: 20),

              MyTextfield(
                obscuretext: true,
                type: TextInputType.visiblePassword,
                icono: IconButton(
                  icon: const Icon(Icons.remove_red_eye_rounded),
                  onPressed: () {},
                ),
                controller: contraseniaController,
                texto: 'Ingrese su contraseña',
                tamaniotexto: 20,
                pmargin: const EdgeInsets.all(15),
                ppadding: const EdgeInsets.all(15),
                radio: 20,
                color: Color(0xFFDAD7CD),
              ),

              Center(
                child: FilledButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Color.fromARGB(255, 70, 96, 63),
                    ),
                  ),
                  onPressed: () async {
                    _handleLogin();
                    Utils.showSnackBar(
                      context: context,
                      title: "Debe iniciar sesion por Google",
                      color: Colors.red[300],
                      duracion: const Duration(seconds: 2),
                    );

                    await Future.delayed(const Duration(seconds: 2), () {
                      correoController.text = '';
                      contraseniaController.text = '';
                    });
                  },
                  child: const Text(
                    'Iniciar Sesion',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),

              SizedBox(height: 250),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    Utils.showSnackBar(
                      context: context,
                      title: "Iniciando sesión...",
                      color: Colors.blue,
                      duracion: const Duration(seconds: 2),
                    );

                    final result = await _handleGoogleSignIn();

                    if (result != null) {
                      if (context.mounted) {
                        Utils.showSnackBar(
                          context: context,
                          title: 'Bienvenido',
                          duracion: Duration(seconds: 2),
                        );
                        context.replace('/libro');
                      }
                    } else {
                      if (context.mounted) {
                        Utils.showSnackBar(
                          context: context,
                          title: 'No se pudo iniciar sesión con Google',
                          duracion: Duration(seconds: 2),
                        );
                      }
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/google.png', width: 25, height: 25),
                      const SizedBox(width: 12),
                      const Text(
                        'Continuar con Google',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
