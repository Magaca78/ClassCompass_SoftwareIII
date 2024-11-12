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
  // Lista de InfoRect que representan los rectángulos con información
  final List<InfoRect> squares = [
    InfoRect(
      rect: Rect.fromLTWH(152, 68, 110, 40),
      info: 'Aula C210',
    ),
    InfoRect(
      rect: Rect.fromLTWH(152, 108, 110, 40),
      info: 'Aula C209',
    ),
    InfoRect(
      rect: Rect.fromLTWH(152, 148, 110, 40),
      info: 'Aula C208',
    ),
    InfoRect(
      rect: Rect.fromLTWH(152, 188, 110, 40),
      info: 'Aula C207',
    ),
    // Agrega más rectángulos según las posiciones y aulas que quieras
  ];

  // Método para mostrar un mensaje al tocar el cuadrado
  void _showMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Información del Aula'),
          content: Text(message),
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
          child: Stack(
            children: [
              Image.asset('assets/mapaPiso2.jpg'), // Imagen de fondo
              ...squares.map((infoRect) {
                Rect square = infoRect.rect;

                return Positioned(
                  left: square.left,
                  top: square.top,
                  width: square.width,
                  height: square.height,
                  child: GestureDetector(
                    onTap: () {
                      // Muestra la información del cuadrado al tocarlo
                      _showMessage(context, infoRect.info);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent, // Fondo completamente transparente
                        border: Border.all(
                          color: Colors.transparent, // Borde completamente transparente
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
    );
  }
}

class InfoRect {
  final Rect rect;
  final String info;

  InfoRect({required this.rect, required this.info});
}
