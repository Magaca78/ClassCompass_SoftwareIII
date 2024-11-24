import 'package:flutter/material.dart';
import 'info_rect.dart';

class InteractiveMap extends StatelessWidget {
  final String floor; // Parámetro para indicar el piso seleccionado

  InteractiveMap({required this.floor, super.key});

  // Lista de aulas (puedes ajustarla según el piso)
  final List<InfoRect> squares = [
    InfoRect(rect: Rect.fromLTWH(116, 51, 40, 30), info: 'Aula C210'),
    InfoRect(rect: Rect.fromLTWH(116, 81, 40, 30), info: 'Aula C209'),
    InfoRect(rect: Rect.fromLTWH(116, 109, 40, 48), info: 'Aula C208'),
    InfoRect(rect: Rect.fromLTWH(116, 156, 40, 30), info: 'Aula C207'),
  ];

  @override
  Widget build(BuildContext context) {
    // Selección dinámica de la imagen según el piso
    final String floorImage = floor == "Segundo Piso"
        ? 'assets/mapaPiso2.jpg'
        : 'assets/mapaPiso3.jpg';

    return InteractiveViewer(
      panEnabled: true,
      minScale: 0.5,
      maxScale: 3.0,
      child: Stack(
        children: [
          // Muestra la imagen correspondiente al piso
          Image.asset(floorImage), 
          ...squares.map((infoRect) {
            Rect square = infoRect.rect;
            return Positioned(
              left: square.left,
              top: square.top,
              width: square.width,
              height: square.height,
              child: GestureDetector(
                onTap: () {
                  // Mostrar información del aula (puedes expandir esta funcionalidad)
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Información del Aula'),
                        content: Text(infoRect.info),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("Cerrar"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
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
