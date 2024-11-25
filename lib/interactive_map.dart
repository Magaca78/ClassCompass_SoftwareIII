import 'package:flutter/material.dart';
import 'info_rect.dart';

class InteractiveMap extends StatefulWidget {
  final String floor;

  const InteractiveMap({Key? key, required this.floor}) : super(key: key);

  @override
  _InteractiveMapState createState() => _InteractiveMapState();
}

class _InteractiveMapState extends State<InteractiveMap> {
  final Map<String, String> floorImages = {
    "Segundo Piso": "assets/mapaPiso2.jpg",
    "Tercer Piso": "assets/mapaPiso3.jpg",
  };

  final Map<String, List<InfoRect>> floorRectangles = {
    "Segundo Piso": [
      InfoRect(rect: Rect.fromLTWH(0.4, 0.105, 0.1, 0.075), info: 'Aula C210'),
      InfoRect(rect: Rect.fromLTWH(0.3, 0.2, 0.2, 0.1), info: 'Aula C209'),
    ],
    "Tercer Piso": [
      InfoRect(rect: Rect.fromLTWH(0.2, 0.3, 0.2, 0.1), info: 'Aula C310'),
      InfoRect(rect: Rect.fromLTWH(0.4, 0.5, 0.2, 0.1), info: 'Aula C309'),
    ],
  };

  double? imageWidth;
  double? imageHeight;
  Set<InfoRect> selectedRects = Set();

  @override
  void initState() {
    super.initState();
    _loadImageDimensions();
  }

  void _loadImageDimensions() {
    final String imagePath = floorImages[widget.floor] ?? floorImages.values.first;
    final Image image = Image.asset(imagePath);

    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        setState(() {
          imageWidth = info.image.width.toDouble();
          imageHeight = info.image.height.toDouble();
        });
      }),
    );
  }

  void _showMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Información del Aula'),
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
    final String imagePath = floorImages[widget.floor] ?? floorImages.values.first;
    final List<InfoRect> rectangles = floorRectangles[widget.floor] ?? [];

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        if (imageWidth == null || imageHeight == null) {
          return const Center(child: CircularProgressIndicator());
        }

        // Establecer el tamaño de la imagen basado en la pantalla, sin distorsión
        double scaleX = screenWidth / imageWidth!;
        double scaleY = screenHeight / imageHeight!;
        double scale = (scaleX < scaleY) ? scaleX : scaleY;

        // Establecer límites para evitar que la imagen sea demasiado grande
        double maxWidth = 1200;
        double maxHeight = 800;

        double imageDisplayWidth = imageWidth! * scale;
        double imageDisplayHeight = imageHeight! * scale;

        if (imageDisplayWidth > maxWidth) imageDisplayWidth = maxWidth;
        if (imageDisplayHeight > maxHeight) imageDisplayHeight = maxHeight;

        return InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 3.0,
          child: Stack(
            children: [
              // Imagen con bordes
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  imagePath,
                  width: imageDisplayWidth,
                  height: imageDisplayHeight,
                  fit: BoxFit.contain,
                ),
              ),
              // Cuadrados interactivos basados en la imagen
              ...rectangles.map((infoRect) {
                return Positioned(
                  left: infoRect.rect.left * imageDisplayWidth,  // Usar el tamaño de la imagen
                  top: infoRect.rect.top * imageDisplayHeight,   // Usar el tamaño de la imagen
                  width: infoRect.rect.width * imageDisplayWidth, // Usar el tamaño de la imagen
                  height: infoRect.rect.height * imageDisplayHeight, // Usar el tamaño de la imagen
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedRects.contains(infoRect)) {
                          selectedRects.remove(infoRect);
                        } else {
                          selectedRects.add(infoRect);
                        }
                        _showMessage(context, infoRect.info);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: selectedRects.contains(infoRect)
                            ? Border.all(color: Colors.green, width: 2)
                            : Border.all(color: Colors.red, width: 2),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}