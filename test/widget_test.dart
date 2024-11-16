import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


import 'package:proyecto_final/main.dart';


void main() {
  testWidgets('FE001 - Verificar que el mapa de fondo se muestra correctamente al iniciar la aplicación', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());


    // Verifica que la imagen de fondo está presente.
    expect(find.byType(Image), findsOneWidget);
  });


  testWidgets('FE002 - Verificar el rango de zoom permitido en InteractiveViewer', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());


    // Encuentra el widget InteractiveViewer
    final interactiveViewer = tester.widget<InteractiveViewer>(find.byType(InteractiveViewer));


    // Verifica que el minScale es 0.5 y maxScale es 3.0
    expect(interactiveViewer.minScale, 0.5);
    expect(interactiveViewer.maxScale, 3.0);
  });


 /* testWidgets('FE003 - Verificar que se muestra un diálogo con información al tocar un aula', (WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());


  // Toca el área interactiva del aula C210
  await tester.tap(find.byType(GestureDetector).first);
  await tester.pump();


  // Verifica que el diálogo muestra la información esperada
  expect(find.text('Información del Aula'), findsOneWidget);
  expect(find.text('Aula C210'), findsOneWidget);
  }); */


  /*testWidgets('FE004 - Verificar que el diálogo se cierra al tocar el botón "Cerrar"', (WidgetTester tester) async {
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
}