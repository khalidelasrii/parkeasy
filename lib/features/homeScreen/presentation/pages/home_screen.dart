import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:parkeasy/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static Future<String?> redirect(
      BuildContext context, GoRouterState state) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    if (firebaseAuth.currentUser != null) {
      print(firebaseAuth.currentUser!.email);
      return null;
    } else {
      return '/authPage';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(SingOutEvent());
            },
            child: Text('Bienvenue dans l\'application!')),
      ),
    );
  }
}
