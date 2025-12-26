import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class PokedexHomePage extends StatelessWidget {
  const PokedexHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveGridListBuilder(
        horizontalGridSpacing: 16, // Horizontal space between grid items
        verticalGridSpacing: 16, // Vertical space between grid items
        horizontalGridMargin: 50, // Horizontal space around the grid
        verticalGridMargin: 50, // Vertical space around the grid
        minItemWidth:
            300, // The minimum item width (can be smaller, if the layout constraints are smaller)
        minItemsPerRow:
            2, // The minimum items to show in a single row. Takes precedence over minItemWidth
        maxItemsPerRow:
            5, // The maximum items to show in a single row. Can be useful on large screens
        gridItems: [
          Container(child: Text('Pokemon')),
          Text('Pokemon'),
          Text('Pokemon'),
          Text('Pokemon'),
          Text('Pokemon'),
          Text('Pokemon'),
          Text('Pokemon'),
        ], // The list of widgets in the grid
        builder: (context, items) {
          return Column(
            children: items,
          );
        },
      ),
    );
  }
}
