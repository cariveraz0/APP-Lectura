import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lectura_app/src/providers/libro_provider.dart';
import 'package:lectura_app/src/shared/utils.dart';
import 'package:lectura_app/src/widgets/mytextfield.dart';

class AddLibro extends StatelessWidget {
  AddLibro({super.key});
  final nombreLibro = TextEditingController();
  final nombreAutor = TextEditingController();
  final paginasTotales = TextEditingController();
  final libroprovider = LibroProvider();
  
  @override
  Widget build(BuildContext context) {
    String? direccionimagen;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 153, 165, 153),
        title: Center(child: const Text('Agregue un nuevo libro')),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                MyTextfield(
                  type: TextInputType.text, 
                  obscuretext: false, 
                  texto: 'Nombre del libro', 
                  tamaniotexto: 20, 
                  pmargin: EdgeInsetsGeometry.all(10), 
                  ppadding: EdgeInsetsGeometry.all(20), 
                  radio: 20, 
                  colorfondo: Color.fromARGB(255, 176, 190, 152),
                  controller: nombreLibro,
                  icono: Icon(Icons.book),
                ),
                MyTextfield(
                  type: TextInputType.text, 
                  obscuretext: false, 
                  texto: 'Nombre del Autor', 
                  tamaniotexto: 20, 
                  pmargin: EdgeInsetsGeometry.all(10), 
                  ppadding: EdgeInsetsGeometry.all(20), 
                  radio: 20, 
                  colorfondo: Color.fromARGB(255, 176, 190, 152),
                  controller: nombreAutor,
                  icono: Icon(Icons.person),
                ),
                MyTextfield(
                  type: TextInputType.number, 
                  obscuretext: false, 
                  texto: 'Ingrese el numero de paginas', 
                  tamaniotexto: 20, 
                  pmargin: EdgeInsetsGeometry.all(10), 
                  ppadding: EdgeInsetsGeometry.all(20), 
                  radio: 20, 
                  colorfondo: Color.fromARGB(255, 176, 190, 152),
                  controller: paginasTotales,
                  icono: Icon(Icons.my_library_books_sharp),
                ),
                SizedBox(height: 20),
                TextButton(
                  child: Text(
                    'Seleccione la foto de portada', 
                    style: TextStyle(
                      color: Color(0xFF3A5A40)
                    ),
                  ),
                  onPressed: () async {
                    final String nombreimagen = nombreLibro.text.replaceAll(' ', '').toLowerCase();
                    direccionimagen = await libroprovider.subirimagen(nombreimagen);
                  },
                ),
                SizedBox(height: 50),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF588157),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 6,
                    ),
                    child: Text(
                      "Agregar Libro",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    onPressed: () async {
                      if(nombreLibro.text.isEmpty || nombreAutor.text.isEmpty || paginasTotales.text.isEmpty)
                      {
                        Utils.showSnackBar(
                          context: context,
                          title: "Todos los campos deben estar llenos",
                          duracion: Duration(seconds: 2),
                          color: Colors.red
                        );
                      }
                      else
                      {
                        if(direccionimagen == null)
                        {
                          Utils.showSnackBar(
                            context: context,
                            title: "Debe seleccionar tambien una imagen para la portada",
                            duracion: Duration(seconds: 2),
                            color: Colors.red
                          );
                        }
                        else
                        {
                          final Map<String, dynamic> nuevolibro = {
                            'autor': nombreAutor.text,
                            'estado': 'Pendiente',
                            'imagenPortada' : '$direccionimagen',
                            'paginasLeidas' : 0,
                            'paginasTotales': int.parse(paginasTotales.text),
                            'titulo': nombreLibro.text,
                            'userId': FirebaseAuth.instance.currentUser?.uid,
                          };
                          await libroprovider.guardarLibro(nuevolibro);
                          nombreAutor.text = '';
                          nombreLibro.text = '';
                          paginasTotales.text = '';
                          Utils.showSnackBar(
                            context: context,
                            title: "Libro agregado",
                            duracion: Duration(seconds: 2),
                            color: Colors.green
                          );
                          context.push('/home');
                        }
                      }
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}