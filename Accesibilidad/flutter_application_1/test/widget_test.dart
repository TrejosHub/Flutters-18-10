import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ayuda_auditiva/main.dart';

void main() {
  testWidgets('Verifica que la app cargue correctamente', (
    WidgetTester tester,
  ) async {
    // Carga la aplicación
    await tester.pumpWidget(MyApp());

    // Verifica que el título del formulario esté presente
    expect(find.text('FORMULARIO ACCESIBLE WEB'), findsOneWidget);

    // Verifica que exista el campo de nombre
    expect(find.textContaining('Nombre'), findsWidgets);

    // Verifica que exista el botón de enviar
    expect(find.text('ENVIAR FORMULARIO'), findsOneWidget);
  });
}
