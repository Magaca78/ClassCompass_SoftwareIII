import 'package:flutter/material.dart';
import 'interactive_map.dart';
import 'search_bar.dart' as custom_search;
import 'floor_selector.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String selectedFloor = "Tercer Piso"; 
  String searchQuery = ""; 
  List<dynamic> classrooms = [];  // Lista de aulas

  // Función para obtener la información de las aulas desde el backend
  Future<void> fetchClassrooms() async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/classrooms'));

    if (response.statusCode == 200) {
      setState(() {
        classrooms = jsonDecode(response.body);  // Asocia las aulas a la lista
      });
    } else {
      setState(() {
        classrooms = [];  // En caso de error, muestra lista vacía
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchClassrooms();  // Obtener las aulas al inicio
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 16, 115, 197),
        title: Row(
          children: [
            Image.asset(
              'assets/LogoUniversidadDeCaldas.png',
              height: 50,
            ),
            const SizedBox(width: 10),
            Text(
              'ClassCompass',
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
             
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
                // Barra de búsqueda
                custom_search.Search(
                  onSearchChanged: (query) {
                    setState(() {
                      searchQuery = query; // Actualiza el texto de búsqueda
                    });
                  },
                ),
                const SizedBox(height: 10),
                // Selector de pisos
                FloorSelector(
                  selectedFloor: selectedFloor,
                  onFloorSelected: (floor) {
                    setState(() {
                      selectedFloor = floor; // Cambia el piso seleccionado
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: InteractiveMap(
              floor: selectedFloor,
              searchQuery: searchQuery, // Pasa la búsqueda al mapa
              onFloorChanged: (floor) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    selectedFloor = floor; // Cambia el piso seleccionado
                  });
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}