import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lectura_app/src/views/libro_page.dart';
import 'package:lectura_app/src/views/login_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GoRouter(
        //Esto es por mientras
        //La ruta inicial será la lista de libros si el usuario ya inició sesion, de lo contrario pasará al login
        initialLocation: '/libro',
        routes: [
          GoRoute(
            path: '/login', 
            name: 'login', 
            builder: (context, state) => LoginPage(),
          ),
          GoRoute(
            path: '/libro',
            name: 'libro',
            builder: (context, state) => LibroPage(),
          ),
        ]
      ),
      debugShowCheckedModeBanner: false,
      title: 'App-Lectura',
      theme: ThemeData(
        fontFamily: 'StackSansHeadline',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}