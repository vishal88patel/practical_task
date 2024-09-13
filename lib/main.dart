import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peactical_demo/search_cubit.dart';
import 'package:peactical_demo/splash_screen.dart';
import 'dart:ui';

import 'grid_cubit.dart';
import 'home_screen.dart';

// Define Grid State
class GridState {
  final List<List<String>> grid;
  final Set<Point> highlightedCells;

  GridState({required this.grid, required this.highlightedCells});
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GridCubit()),
        BlocProvider(create: (_) => SearchCubit()),
      ],
      child: MaterialApp(
        title: 'Grid Search App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(), // Start with the SplashScreen
      ),
    );
  }
}
