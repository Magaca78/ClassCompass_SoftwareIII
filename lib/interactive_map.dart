import 'package:flutter/material.dart';
import 'info_rect.dart';

class InteractiveMap extends StatefulWidget {
  final String floor;
  final String searchQuery;
  final ValueChanged<String> onFloorChanged;

  const InteractiveMap({
    Key? key,
    required this.floor,
    required this.searchQuery,
    required this.onFloorChanged,
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
      InfoRect(rect: Rect.fromLTWH(0.376, 0.182, 0.1245, 0.067), info: 'Aula C209'),
      InfoRect(rect: Rect.fromLTWH(0.376, 0.248, 0.1245, 0.112), info: 'Aula C208'),
      InfoRect(rect: Rect.fromLTWH(0.376, 0.358, 0.1245, 0.0655), info: 'Aula C207'),
      InfoRect(rect: Rect.fromLTWH(0.376, 0.423, 0.1245, 0.11), info: 'Aula C206'),
      InfoRect(rect: Rect.fromLTWH(0.376, 0.531, 0.1245, 0.0665), info: 'Aula C205'),
      InfoRect(rect: Rect.fromLTWH(0.376, 0.595, 0.1245, 0.113), info: 'Aula C204'),
      InfoRect(rect: Rect.fromLTWH(0.376, 0.706, 0.1245, 0.0655), info: 'Aula C203'),
      InfoRect(rect: Rect.fromLTWH(0.376, 0.769, 0.1245, 0.068), info: 'Aula C202'),
      InfoRect(rect: Rect.fromLTWH(0.376, 0.835, 0.158, 0.089), info: 'Aula C201'),
      InfoRect(rect: Rect.fromLTWH(0.533, 0.835, 0.091, 0.089), info: 'Baños Piso 2'),
    ],
    "Tercer Piso": [
      InfoRect(rect: Rect.fromLTWH(0.376, 0.074, 0.187, 0.0455), info: 'Aula C311'),
      InfoRect(rect: Rect.fromLTWH(0.376, 0.119, 0.1245, 0.0655), info: 'Aula C310'),
      InfoRect(rect: Rect.fromLTWH(0.376, 0.182, 0.1245, 0.067), info: 'Aula C309'),
      InfoRect(rect: Rect.fromLTWH(0.376, 0.248, 0.1245, 0.089), info: 'Aula C308'),
      InfoRect(rect: Rect.fromLTWH(0.376, 0.335, 0.1245, 0.067), info: 'Aula C307'),
      InfoRect(rect: Rect.fromLTWH(0.376, 0.4, 0.1245, 0.089), info: 'Aula C306'),
      InfoRect(rect: Rect.fromLTWH(0.376, 0.488, 0.1245, 0.0665), info: 'Sala K'),
      InfoRect(rect: Rect.fromLTWH(0.376, 0.553, 0.1245, 0.11), info: 'Sala J'),
      InfoRect(rect: Rect.fromLTWH(0.376, 0.662, 0.1245, 0.11), info: 'Sala I'),
      InfoRect(rect: Rect.fromLTWH(0.376, 0.769, 0.1245, 0.068), info: 'Sala H'),
      InfoRect(rect: Rect.fromLTWH(0.376, 0.835, 0.159, 0.089), info: 'Oficina Post Grados'),
      InfoRect(rect: Rect.fromLTWH(0.533, 0.835, 0.091, 0.089), info: 'Baños Piso 3'),
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
        if (filteredRects.isEmpty) {
          // Buscar en otros pisos
          for (String floor in floorRectangles.keys) {
            if (floor != widget.floor) {
              final List<InfoRect> otherFloorRects = floorRectangles[floor] ?? [];
              final List<InfoRect> foundRects = otherFloorRects
                  .where((rect) => rect.info.toLowerCase().contains(query.toLowerCase()))
                  .toList();
              if (foundRects.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  widget.onFloorChanged(floor);
                });
                break;
              }
            }
          }
        }
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