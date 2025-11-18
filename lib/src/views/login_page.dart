import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lectura_app/src/shared/utils.dart';
import 'package:lectura_app/src/widgets/mytextfield.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final correoController = TextEditingController();
  final contraseniaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 89, 139, 77),
        title: const Center(
          child: Text(
            'Inicio de sesion', style: TextStyle(fontSize: 30, ),
          )
        ),
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index){
          return Center(
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
                    onPressed: (){}, 
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
                      backgroundColor: WidgetStateProperty.all(Color.fromARGB(255, 70, 96, 63))
                    ),
                    onPressed: ()async{
                      Utils.showSnackBar(
                          context: context,
                          title: "Debe iniciar sesion por Google",
                          color: Colors.red[300],
                          duracion: const Duration(seconds: 2)
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
                      side: const BorderSide(
                        color: Color(0xFFE5E7EB),
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Utils.showSnackBar(
                      //     context: context,
                      //     title: "Pendiente...",
                      //     color: Colors.blue,
                      //     duracion: const Duration(seconds: 2)
                      // );

                      //Momentaneo hasta implementar autenticacion por google
                      context.replace('/libro');
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
          );
        }
      ),
    );
  }
}