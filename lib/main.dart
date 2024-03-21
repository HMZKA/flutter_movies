import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_movies/cubit/app_cubit.dart';
import 'package:flutter_movies/dio_helper.dart';
import 'package:flutter_movies/home_screen.dart';
import 'package:flutter_movies/test_screen.dart';

void main() {
  DioHelper.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  static bool isGrid = true;
  static ScrollController listController = ScrollController();
  static ScrollController gridController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..getMovies(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
