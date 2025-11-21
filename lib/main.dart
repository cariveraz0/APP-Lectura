import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lectura_app/firebase_options.dart';
import 'package:lectura_app/src/views/libro_page.dart';
import 'package:lectura_app/src/views/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GoRouter(
        redirect: (context, state) {
          final user = FirebaseAuth.instance.currentUser;

          final freeRoutes = ['/login']; //Aqui se colocan las rutas "libres" que no necesitan el inicio

          if (user == null && !freeRoutes.contains(state.fullPath)){
            return '/login';
          }
          return null;
        },
        //La ruta inicial será la de LibroPage()
        //Si el usuario está autenticado pasará de un solo a LibroPage()
        //De lo contrario, irá hacia LoginPage
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
            builder: (context, state){
              final libroId = state.extra as String? ?? 'd4HdWJAySYLWOiUJV1br';
              return LibroPage(libroid: libroId);
            },
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