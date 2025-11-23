import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lectura_app/src/models/datos_libros.dart';
import 'package:lectura_app/src/providers/libro_provider.dart';
import 'package:lectura_app/src/widgets/custom_drawer.dart';
import 'package:lectura_app/src/widgets/custom_listtile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final libroprovider = LibroProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Libros')
        ),
        backgroundColor: Color.fromARGB(255, 153, 165, 153),
      ),
      backgroundColor: Color.fromARGB(255, 214, 231, 214),
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
          context.push('/add');
        },
      ),
    );
  }
}