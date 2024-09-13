import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peactical_demo/main.dart';

class GridCubit extends Cubit<GridState> {
  GridCubit() : super(GridState(grid: [], highlightedCells: {}));

  void createGrid(int rows, int cols, List<String> alphabets) {
    if (rows * cols != alphabets.length || rows <= 0 || cols <= 0) {
      emit(GridState(grid: [], highlightedCells: {}));
      return;
    }
    List<List<String>> grid = List.generate(
      rows,
      (i) => alphabets.sublist(i * cols, (i + 1) * cols),
    );
    emit(GridState(grid: grid, highlightedCells: {}));
  }

  void highlightCells(Set<Point> cells) {
    emit(GridState(grid: state.grid, highlightedCells: cells));
  }
}
