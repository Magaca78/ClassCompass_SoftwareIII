import 'package:flutter/material.dart';
import 'info_rect.dart';

class InteractiveMap extends StatelessWidget {
  final List<InfoRect> squares = [
    InfoRect(rect: Rect.fromLTWH(152, 68, 110, 40), info: 'Aula C210'),
    InfoRect(rect: Rect.fromLTWH(152, 108, 110, 40), info: 'Aula C209'),
    InfoRect(rect: Rect.fromLTWH(152, 148, 110, 40), info: 'Aula C208'),
    InfoRect(rect: Rect.fromLTWH(152, 188, 110, 40), info: 'Aula C207'),
    // Agrega más rectángulos según las posiciones y aulas que quieras
  ];

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

            return Positioned(
              left: square.left,
              top: square.top,
              width: square.width,
              height: square.height,
              child: GestureDetector(
                onTap: () {
                  _showMessage(context, infoRect.info);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.transparent,
                      width: 2,
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
