import 'package:flutter/material.dart';
import 'interactive_map.dart';
import 'search_bar.dart' as custom_search;  
import 'floor_selector.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String selectedFloor = "Segundo Piso";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('ClassCompass'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Acción adicional si es necesaria
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text(
                  'Sistema de búsqueda de salones',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const custom_search.SearchBar(),  // Usando el alias
                const SizedBox(height: 10),
                FloorSelector(
                  selectedFloor: selectedFloor,
                  onFloorSelected: (floor) {
                    setState(() {
                      selectedFloor = floor;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: InteractiveMap(),
          ),
        ],
      ),
    );
  }
}
