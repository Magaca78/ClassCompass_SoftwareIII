import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mapa Interactivo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Mapa Interactivo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Rect> squares = [
    Rect.fromLTWH(187, 53, 110, 30), // Cuadrado 1
    Rect.fromLTWH(187, 83, 110, 30), // Cuadrado 2
  ];
  // Método para agregar un cuadrado en la posición especificada
  void _addSquare(Offset position) {
    print('Agregando cuadrado en $position');
    const double squareSize = 50; // Tamaño fijo del cuadrado
    setState(() {
      squares.add(Rect.fromLTWH(
        position.dx - squareSize / 2, // Centra el cuadrado en el punto de toque
        position.dy - squareSize / 2,
        squareSize,
        squareSize,
      ));
    });

    print((position.dx - squareSize / 2).toString() + " " + 
    (position.dy - squareSize / 2).toString() + " " + squareSize.toString());
  }

  // Método para mostrar un mensaje al tocar el cuadrado
  void _showMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 3.0,
          child: GestureDetector(
            onTapDown: (details) {
              // Captura la posición del toque en el área de la imagen
              Offset localPosition = details.localPosition;
              _addSquare(localPosition); // Agrega un cuadrado en la posición tocada
            },
            child: Stack(
              children: [
                Image.asset('assets/mapaPiso2.jpg'), // Imagen de fondo
                ...squares.asMap().entries.map((entry) {
                  int index = entry.key;
                  Rect square = entry.value;

                  return Positioned(
                    left: square.left,
                    top: square.top,
                    width: square.width,
                    height: square.height,
                    child: GestureDetector(
                      onTap: () {
                        // Acción al tocar el cuadrado
                        _showMessage(context, 'Cuadrado ${index + 1} tocado');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.3), // Color semitransparente
                          border: Border.all(
                            color: Colors.blue,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
