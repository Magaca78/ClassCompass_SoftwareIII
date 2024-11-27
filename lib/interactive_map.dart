import 'package:flutter/material.dart';
import 'info_rect.dart';

class InteractiveMap extends StatefulWidget {
  final String floor;
  final String searchQuery;

  const InteractiveMap({
    Key? key,
    required this.floor,
    required this.searchQuery,
  }) : super(key: key);

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
      InfoRect(rect: Rect.fromLTWH(0.376, 0.119, 0.1245, 0.0655), info: 'Aula C210'),
      InfoRect(rect: Rect.fromLTWH(0.376, 0.187, 0.1245, 0.0655), info: 'Aula C209'),
      InfoRect(rect: Rect.fromLTWH(0.376, 0.252, 0.1245, 0.112), info: 'Aula C208'),
      InfoRect(rect: Rect.fromLTWH(0.376, 0.363, 0.1245, 0.0655), info: 'Aula C207'),
      InfoRect(rect: Rect.fromLTWH(0.376, 0.428, 0.1245, 0.108), info: 'Aula C206'),
      InfoRect(rect: Rect.fromLTWH(0.376, 0.534, 0.1245, 0.0655), info: 'Aula C205'),
      InfoRect(rect: Rect.fromLTWH(0.376, 0.598, 0.1245, 0.108), info: 'Aula C204'),
      InfoRect(rect: Rect.fromLTWH(0.376, 0.704, 0.1245, 0.0655), info: 'Aula C203'),
      InfoRect(rect: Rect.fromLTWH(0.376, 0.769, 0.1245, 0.0655), info: 'Aula C202'),
      InfoRect(rect: Rect.fromLTWH(0.376, 0.833, 0.157, 0.0865), info: 'Aula C201'),
      InfoRect(rect: Rect.fromLTWH(0.376, 0.833, 0.088, 0.0865), info: 'Baños Piso 2'),
    ],
    "Tercer Piso": [
      InfoRect(rect: Rect.fromLTWH(0.376, 0.1243, 0.1245, 0.0655), info: 'Aula C310'),
      InfoRect(rect: Rect.fromLTWH(0.376, 0.187, 0.1245, 0.0655), info: 'Aula C309'),
    ],
  };

  double? imageWidth;
  double? imageHeight;
  late List<InfoRect> filteredRects; // Lista de rectángulos filtrados

  @override
  void initState() {
    super.initState();
    _loadImageDimensions();
    _filterAulas(widget.searchQuery);
  }

  @override
  void didUpdateWidget(covariant InteractiveMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery || oldWidget.floor != widget.floor) {
      _filterAulas(widget.searchQuery);
    }
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

  void _filterAulas(String query) {
    final List<InfoRect> allRects = floorRectangles[widget.floor] ?? [];
    setState(() {
      if (query.isEmpty) {
        filteredRects = allRects;
      } else {
        filteredRects = allRects
            .where((rect) => rect.info.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String imagePath = floorImages[widget.floor] ?? floorImages.values.first;

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        if (imageWidth == null || imageHeight == null) {
          return const Center(child: CircularProgressIndicator());
        }

        // Escala de la imagen
        double scaleX = screenWidth / imageWidth!;
        double scaleY = screenHeight / imageHeight!;
        double scale = (scaleX < scaleY) ? scaleX : scaleY;

        // Tamaño final de la imagen
        double imageDisplayWidth = imageWidth! * scale;
        double imageDisplayHeight = imageHeight! * scale;

        return InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 3.0,
          child: Stack(
            children: [
              // Imagen del mapa
              Image.asset(
                imagePath,
                width: imageDisplayWidth,
                height: imageDisplayHeight,
                fit: BoxFit.contain,
              ),
              // Rectángulos interactivos
              ...filteredRects.map((infoRect) {
                return Positioned(
                  left: infoRect.rect.left * imageDisplayWidth,
                  top: infoRect.rect.top * imageDisplayHeight,
                  width: infoRect.rect.width * imageDisplayWidth,
                  height: infoRect.rect.height * imageDisplayHeight,
                  child: GestureDetector(
                    onTap: () {
                      _showMessage(context, infoRect.info);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.red, width: 1),
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
}
