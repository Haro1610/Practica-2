import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:practica_2/auth/bloc/auth_bloc.dart';
import 'package:practica_2/content/bloc/content_bloc.dart';
import 'package:practica_2/home/bloc/record_bloc.dart';
import 'package:practica_2/home/home.dart';
import 'package:practica_2/login/login.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => AuthBloc()..add(VerifyAuthEvent())),
      BlocProvider(create: (context) => ContentBloc()),
      BlocProvider(create: (context) => RecordBloc()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Material App',
        theme: ThemeData.dark(),
        home: BlocConsumer<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthSuccesState) {
              return HomePage();
            } else if (state is AuthErrorState) {
              return LoginPage();
            } else if (state is SingOutSucces) {
              return LoginPage();
            }
            return Scaffold(
              body: Container(
                child: CircularProgressIndicator(),
              ),
            );
          },
          listener: (context, state) {},
        ));
  }
}
