import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lectura_app/src/shared/utils.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.red[50],
                  radius: 40,
                  child: FirebaseAuth.instance.currentUser?.photoURL == null
                      ? Text(
                          '${FirebaseAuth.instance.currentUser?.displayName?.substring(0)}',
                          style: TextStyle(
                            fontSize: 42,
                            color: Colors.red[400],
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(FirebaseAuth.instance.currentUser!.photoURL!),
                        ),
                ),
                Text('${FirebaseAuth.instance.currentUser?.displayName}'),
              ],
            ),
          ),

          const ListTile(
            title: Text('Inicio'),
            leading: Icon(Icons.home),
          ),

          const ListTile(
            title: Text('Agregar libro'),
            leading: Icon(Icons.book),
          ),

          const ListTile(
            title: Text('Reseñas'),
            leading: Icon(Icons.comment),
          ),

          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Cuenta'),
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Cerrar sesión'),
            onTap: () async {
              Utils.showSnackBar(
                context: context,
                title: "Sesión cerrada",
                color: Colors.red[300],
                duracion: const Duration(seconds: 3),
              );

              await Future.delayed(const Duration(seconds: 2), () {
                FirebaseAuth.instance.signOut();
                if (!context.mounted) return;
                context.replace('/login');
              });
            },
          ),
        ],
      ),
    );
  }
}
