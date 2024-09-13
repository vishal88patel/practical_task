import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peactical_demo/search_cubit.dart';

import 'grid_cubit.dart';
import 'main.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _rowsController = TextEditingController();
  final TextEditingController _colsController = TextEditingController();
  final TextEditingController _alphabetsController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grid Search App'),
      ),
      body: Column(
        children: [
          _buildInputFields(context),
          Expanded(
            child: BlocBuilder<GridCubit, GridState>(
              builder: (context, gridState) {
                return BlocBuilder<SearchCubit, String>(
                  builder: (context, searchQuery) {
                    return _buildGridDisplay(gridState.grid, gridState.highlightedCells);
                  },
                );
              },
            ),
          ),
          _buildSearchSection(context),
        ],
      ),
    );
  }

  Widget _buildInputFields(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _rowsController,
            decoration: InputDecoration(labelText: 'Number of Rows'),
            keyboardType: TextInputType.number,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _colsController,
            decoration: InputDecoration(labelText: 'Number of Columns'),
            keyboardType: TextInputType.number,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _alphabetsController,
            decoration: InputDecoration(labelText: 'Enter Alphabets'),
            keyboardType: TextInputType.text,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            int rows = int.tryParse(_rowsController.text) ?? 0;
            int cols = int.tryParse(_colsController.text) ?? 0;
            List<String> alphabets = _alphabetsController.text.split('');
            if (rows > 0 && cols > 0 && alphabets.length == rows * cols) {
              context.read<GridCubit>().createGrid(rows, cols, alphabets);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Invalid grid dimensions or alphabet count')),
              );
            }
          },
          child: Text('Create Grid'),
        ),
      ],
    );
  }

  Widget _buildGridDisplay(List<List<String>> grid, Set<Point> highlightedCells) {
    if (grid.isEmpty) return Container();
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: grid.isNotEmpty ? grid[0].length : 0,
      ),
      itemCount: grid.isNotEmpty ? grid.length * grid[0].length : 0,
      itemBuilder: (context, index) {
        if (grid.isEmpty) return Container();
        int row = index ~/ grid[0].length;
        int col = index % grid[0].length;
        bool isHighlighted = highlightedCells.contains(Point(col.toDouble(), row.toDouble()));
        return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: isHighlighted ? Colors.green : Colors.white,
          ),
          child: Text(
            grid[row][col],
            style: TextStyle(
              fontSize: 20,
              color: isHighlighted ? Colors.white : Colors.black,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchSection(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(labelText: 'Search Text'),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<SearchCubit>().search(
              _searchController.text,
              context.read<GridCubit>().state.grid,
              (highlightedCells) {
                context.read<GridCubit>().highlightCells(highlightedCells);
              },
            );
          },
          child: Text('Search'),
        ),
      ],
    );
  }
}
