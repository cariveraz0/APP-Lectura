import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lectura_app/src/models/datos_libros.dart';
import 'package:lectura_app/src/providers/libro_provider.dart';
import 'package:lectura_app/src/shared/utils.dart';
import 'package:lectura_app/src/widgets/custom_drawer.dart';
import 'package:lectura_app/src/widgets/custom_listtile.dart';
import 'package:percent_indicator/percent_indicator.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final libroprovider = LibroProvider();
  final String? nombre = FirebaseAuth.instance.currentUser?.displayName;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: nombre == null ? Text('Libros') : Text('Libros de $nombre'),
        ),
        backgroundColor: Color.fromARGB(255, 153, 165, 153),
      ),
      drawer: CustomDrawer(),
      body: StreamBuilder(
        stream: libroprovider.getLibrosStream(), 
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final List<Libro> libros = snapshot.data!;

          return ListView.builder(
            itemCount: libros.length,
            itemBuilder: (BuildContext context, int index) {
              final libro = libros[index];
              return CustomListTile(
                fotoPortada: libro.imagenPortada.isNotEmpty
                  ? Image.network(libro.imagenPortada, width: 50, height: 50, fit: BoxFit.cover)
                  : const Icon(Icons.book),
                libroTitulo: libro.titulo,
                autor: libro.autor,
                estado: libro.estado,
                paginasLeidas: libro.paginasLeidas,
                paginasTotales: libro.paginasTotales,
                contexto: context,
                direccion: 'libro',
                id: libro.id,
              );    
            },
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF588157),	
        child: Icon(Icons.add, color: Colors.white),
        onPressed: (){
          libroprovider.getLibrosStream().first.then((libros){
            if (libros.length >= 12){
              Utils.showSnackBar(
                context: context,
                title: "Solo se puede agregar un maximo de 12 libros",
                duracion: Duration(seconds: 3),
                color: Colors.red
              );
            }
            else{
              context.push('/add');
            }
          });
        },
      ),
      bottomNavigationBar: StreamBuilder<List<Libro>>(
        stream: libroprovider.getLibrosStream(),
        builder: (context, snapshot){
          final libros = snapshot.data ?? [];
          final int librosTotales = libros.length;
          final int librosLeidos = libros.where((libro) => libro.estado == 'Finalizado').length;
          final double progreso = librosTotales == 0 ? 0 : librosLeidos / librosTotales;

          return Container(
            color: Color(0xFFA3B18A),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: LinearPercentIndicator(
                    percent: progreso.clamp(0.0, 1.0),
                    lineHeight: 30,
                    backgroundColor: Color(0xFFDAD7CD),
                    progressColor: Color(0xFF3A5A40),
                    barRadius: Radius.circular(10),
                    animation: true,
                    animationDuration: 800,
                    center: Text(
                      "${(progreso * 100).toInt()}% Finalizados",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "StackSansHeadline",
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                      ),
                    ),
                  )
                )
              ],
            ),
          );
        },
      ),
    );
  }
}