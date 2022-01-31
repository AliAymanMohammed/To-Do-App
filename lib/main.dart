import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cubit.dart';
import '../notificationservice.dart';
import 'observer.dart';
import 'screens/home_screen.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();

  Bloc.observer = MyBlocObserver();
  runApp( MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) =>TaskCubit()..createDatabase()),
      ],
      child: MaterialApp(
        title: 'ToDo',
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
        theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromRGBO(28, 40, 51, 1),
          appBarTheme: const AppBarTheme(
            color:  Color.fromRGBO(40, 55, 71, 1),
            elevation: 10,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color.fromRGBO(40, 55, 71, 1),
            unselectedItemColor: Colors.white70,
            selectedItemColor: Colors.greenAccent,
            elevation: 20
          ),
          accentColor: const Color.fromRGBO(40, 180, 99, 1),
          cardColor: const Color.fromRGBO(40, 55, 71, 1),
        ),
        routes: {
          HomeScreen.routeName : (context) => HomeScreen(),
        },
      ),
    );
  }
}