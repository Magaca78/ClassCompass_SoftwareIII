import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cambiar Color de fondo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ColorChangePage(),
    );
  }
}

class ColorChangePage extends StatefulWidget {
  @override
  _ColorChangePageState createState() => _ColorChangePageState();
}

class _ColorChangePageState extends State<ColorChangePage> {
  Color _backgroundColor = Colors.white;

  final List<Map<String, Color>> _colors = [
    {'Rojo': Colors.red},
    {'Verde': Colors.green},
    {'Azul': Colors.blue},
    {'Amarillo': Colors.yellow},
    {'Púrpura': Colors.purple},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cambiar color de fondo'),
      ),
      body: Container(
        color: _backgroundColor,
        child: ListView.builder(
          itemCount: _colors.length,
          itemBuilder: (context, index) {
            String colorName = _colors[index].keys.first;
            Color color = _colors[index][colorName]!;
            return ListTile(
              title: Text('Cambiar a $colorName'),
              onTap: () {
                setState(() {
                  _backgroundColor = color;
                });
              },
            );
          },
        ),
      ),
    );
  }
}
