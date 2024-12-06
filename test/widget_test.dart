import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:proyecto_final/main.dart';
import 'package:proyecto_final/interactive_map.dart'; // Importa tu widget

void main() {
  /*
  testWidgets('FE001 - Verificar que el mapa de fondo se muestra correctamente al iniciar la aplicación', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verifica que la imagen de fondo está presente.
    expect(find.byType(Image), findsOneWidget);
  });
  */
  /*
  testWidgets('FE002 - Verificar el rango de zoom permitido en InteractiveViewer', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Encuentra el widget InteractiveViewer
    final interactiveViewer = tester.widget<InteractiveViewer>(find.byType(InteractiveViewer));

    // Verifica que el minScale es 0.5 y maxScale es 3.0
    expect(interactiveViewer.minScale, 0.5);
    expect(interactiveViewer.maxScale, 3.0);
  });
  */
  // Comentado porque no corresponde
  /* testWidgets('FE003 - Verificar que se muestra un diálogo con información al tocar un aula', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Toca el área interactiva del aula C210
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pump();

    // Verifica que el diálogo muestra la información esperada
    expect(find.text('Información del Aula'), findsOneWidget);
    expect(find.text('Aula C210'), findsOneWidget);
  }); */

  // Comentado porque no corresponde
  /* testWidgets('FE004 - Verificar que el diálogo se cierra al tocar el botón "Cerrar"', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Toca el área interactiva para abrir el diálogo
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pump();

    // Toca el botón "Cerrar" en el diálogo
    await tester.tap(find.text('Cerrar'));
    await tester.pump();

    // Verifica que el diálogo ya no está presente
    expect(find.text('Información del Aula'), findsNothing);
    expect(find.text('Aula C210'), findsNothing);
  }); */

testWidgets('FE005 - Verificar que se muestran correctamente los diferentes pisos en el mapa', (WidgetTester tester) async {
  // Configurar un tamaño de superficie fijo
  await tester.binding.setSurfaceSize(const Size(800, 600));
  
  // Cargar la aplicación
  await tester.pumpWidget(const MaterialApp(home: MyApp()));

  // Esperas y diagnóstico
  await tester.pump(const Duration(seconds: 1));
  await tester.pumpAndSettle(const Duration(seconds: 10));

  // Diagnóstico de widgets
  final widgetTree = tester.allWidgets;
  debugPrint('Total de widgets encontrados: ${widgetTree.length}');

  // Verificar selector de pisos
  final tercerPisoFinder = find.text('Tercer Piso');
  expect(tercerPisoFinder, findsOneWidget, reason: 'El selector de Tercer Piso no se encontró');

  // Tocar Tercer Piso
  await tester.tap(tercerPisoFinder);
  await tester.pumpAndSettle(const Duration(seconds: 5));

  // Verificaciones
  final mapFinder = find.byType(InteractiveMap);
  expect(mapFinder, findsOneWidget, reason: 'El mapa interactivo no se encontró');

  final imageFinder = find.image(const AssetImage('assets/mapaPiso3.jpg'));
  expect(imageFinder, findsOneWidget, reason: 'La imagen del mapa del Tercer Piso no se encontró');
});

  testWidgets('FE006 - Verificar que la búsqueda de un aula por código muestra el aula correcta en el mapa', (WidgetTester tester) async {
    // Construir la app
    await tester.pumpWidget(const MyApp());

    // Escribir en la barra de búsqueda
    await tester.enterText(find.byType(TextField), 'C210');
    await tester.pumpAndSettle(); // Esperar que la búsqueda se procese

    // Verificar que el aula "C210" aparece correctamente en el mapa
    expect(find.text('Aula C210'), findsOneWidget); // Verifica que el aula está presente

    // Verificar que el rectángulo interactivo correspondiente al aula está presente
    expect(find.byWidgetPredicate((widget) => widget is Positioned), findsOneWidget);

  });

  testWidgets('FE007 - Verificar que la búsqueda no retorna resultados cuando no se encuentra el aula en el mapa', (WidgetTester tester) async {
    // Construir la app
    await tester.pumpWidget(const MyApp());

    // Escribir en la barra de búsqueda un código de aula inexistente
    await tester.enterText(find.byType(TextField), 'C999');
    await tester.pumpAndSettle(); // Esperar que la búsqueda se procese

    // Verificar que no se muestra ningún resultado
    expect(find.text('C999'), findsNothing); // Asegurarse de que no aparece ningún aula
    expect(find.byWidgetPredicate((widget) => widget is Positioned), findsNothing); // Verificar que no hay rectángulos de aula
  });
}
