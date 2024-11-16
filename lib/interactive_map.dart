import 'package:flutter/material.dart';
import 'info_rect.dart';

class InteractiveMap extends StatefulWidget {
  @override
  _InteractiveMapState createState() => _InteractiveMapState();
}

class _InteractiveMapState extends State<InteractiveMap> {
  final List<InfoRect> squares = [
    InfoRect(rect: Rect.fromLTWH(116, 51, 40, 30), info: 'Aula C210'),
    InfoRect(rect: Rect.fromLTWH(116, 81, 40, 30), info: 'Aula C209'),
    InfoRect(rect: Rect.fromLTWH(116, 108, 40, 48), info: 'Aula C208'),
    InfoRect(rect: Rect.fromLTWH(116, 156, 40, 30), info: 'Aula C207'),
    InfoRect(rect: Rect.fromLTWH(116, 200, 40, 48), info: 'Aula C206'),
    InfoRect(rect: Rect.fromLTWH(116, 250, 40, 30), info: 'Aula C205'),
    InfoRect(rect: Rect.fromLTWH(116, 290, 40, 48), info: 'Aula C204'),
  ];

  String? selectedSquareId; // Variable para mantener el cuadrado seleccionado

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
    return InteractiveViewer(
      panEnabled: true,
      minScale: 0.5,
      maxScale: 3.0,
      child: Stack(
        children: [
          Image.asset('assets/mapaPiso2.jpg'), // Imagen de fondo
          ...squares.map((infoRect) {
            Rect square = infoRect.rect;
            bool isSelected = selectedSquareId == infoRect.info; // Verifica si el cuadrado está seleccionado

            return Positioned(
              left: square.left,
              top: square.top,
              width: square.width,
              height: square.height,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    // Cambiar la selección del cuadrado
                    selectedSquareId = isSelected ? null : infoRect.info; // Desmarcar si ya está seleccionado
                    _showMessage(context, infoRect.info);
                  });
                },
                child: Draggable(
                  data: infoRect.info,
                  feedback: Container(
                    width: square.width,
                    height: square.height,
                    color: Colors.transparent,
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  childWhenDragging: Container(), // Se puede definir un widget cuando se arrastra
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: isSelected ? Colors.red : Colors.transparent, // Resalta el borde si está seleccionado
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
