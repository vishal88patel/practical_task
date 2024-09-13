import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<String> {
  SearchCubit() : super('');

  void search(String query, List<List<String>> grid, Function(Set<Point>) onFound) {
    Set<Point> highlightedCells = {};
    if (query.isEmpty || grid.isEmpty) {
      emit('');
      return;
    }

    // Search in all directions
    highlightedCells.addAll(searchInDirection(query, grid, 0, 1)); // East
    highlightedCells.addAll(searchInDirection(query, grid, 1, 0)); // South
    highlightedCells.addAll(searchInDirection(query, grid, 1, 1)); // South-East

    emit(query);
    onFound(highlightedCells);
  }

  Set<Point> searchInDirection(String query, List<List<String>> grid, int rowStep, int colStep) {
    Set<Point> cells = {};
    int rows = grid.length;
    int cols = grid[0].length;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        int nr = r, nc = c;
        bool match = true;

        for (int k = 0; k < query.length; k++) {
          if (nr < 0 || nr >= rows || nc < 0 || nc >= cols || grid[nr][nc] != query[k]) {
            match = false;
            break;
          }
          nr += rowStep;
          nc += colStep;
        }

        if (match) {
          nr = r;
          nc = c;
          for (int k = 0; k < query.length; k++) {
            cells.add(Point(nc.toDouble(), nr.toDouble())); // Using Point
            nr += rowStep;
            nc += colStep;
          }
        }
      }
    }

    return cells;
  }
}
