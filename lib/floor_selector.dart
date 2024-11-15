import 'package:flutter/material.dart';

class FloorSelector extends StatelessWidget {
  final String selectedFloor;
  final ValueChanged<String> onFloorSelected;

  const FloorSelector({
    super.key,
    required this.selectedFloor,
    required this.onFloorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => onFloorSelected("Segundo Piso"),
          child: Text(
            "Segundo Piso", 
            style: TextStyle(
              fontWeight: selectedFloor == "Segundo Piso"
                  ? FontWeight.bold
                  : FontWeight.normal,
              color:
                  selectedFloor == "Segundo Piso" ? Colors.black : Colors.grey,
            ),
          ),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: () => onFloorSelected("Tercer Piso"),
          child: Text(
            "Tercer Piso",
            style: TextStyle(
              fontWeight: selectedFloor == "Tercer Piso"
                  ? FontWeight.bold
                  : FontWeight.normal,
              color:
                  selectedFloor == "Tercer Piso" ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
