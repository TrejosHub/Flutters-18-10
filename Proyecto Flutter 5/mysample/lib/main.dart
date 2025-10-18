import 'package:flutter/material.dart';

/// Flutter code sample for [AppBar] with dynamic color, SnackBar, and Switch.

final List<int> _items = List<int>.generate(51, (int index) => index);

void main() => runApp(const AppBarApp());

class AppBarApp extends StatelessWidget {
  const AppBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorSchemeSeed: const Color(0xff00BCD4)),
      debugShowCheckedModeBanner:
          false, // Añadido para quitar el banner de debug
      home: const AppBarExample(),
    );
  }
}

class AppBarExample extends StatefulWidget {
  const AppBarExample({super.key});

  @override
  State<AppBarExample> createState() => _AppBarExampleState();
}

class _AppBarExampleState extends State<AppBarExample> {
  bool shadowColor = false;
  double? scrolledUnderElevation;
  Color appBarColor = Colors.blue;
  Color scaffoldBackgroundColor = Colors.grey[200]!;
  final List<Color> _appBarColors = [
    const Color.fromARGB(255, 25, 37, 211),
    const Color.fromARGB(255, 43, 78, 3),
    const Color.fromARGB(255, 240, 3, 3),
    Colors.purple,
    const Color.fromARGB(255, 179, 121, 34),
  ];
  final List<Color> _scaffoldColors = [
    const Color.fromARGB(255, 16, 224, 16)!,
    Colors.lightGreen[200]!,
    const Color.fromARGB(255, 199, 9, 72)!,
    Colors.teal[200]!,
    Colors.amber[200]!,
    Colors.black38,
  ];
  int _currentAppBarColorIndex = 0;
  int _currentScaffoldColorIndex = 0;

  void _changeAppBarColor(int newIndex, bool isAppBar) {
    setState(() {
      if (isAppBar) {
        _currentAppBarColorIndex = newIndex;
        appBarColor = _appBarColors[_currentAppBarColorIndex];
      } else {
        _currentScaffoldColorIndex = newIndex;
        scaffoldBackgroundColor = _scaffoldColors[_currentScaffoldColorIndex];
      }
    });
  }

  void _showElevationSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'scrolledUnderElevation: ${scrolledUnderElevation ?? 'default'}',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('AppBar Demo'),
        scrolledUnderElevation: scrolledUnderElevation,
        shadowColor: shadowColor ? Theme.of(context).colorScheme.shadow : null,
        backgroundColor: appBarColor,

        // 👇 AQUÍ ESTÁ EL CAMBIO (reemplazo de los 3 puntos por íconos)
        actions: [
          IconButton(
            icon: const Icon(Icons.color_lens_outlined),
            tooltip: 'Cambiar color del AppBar',
            onPressed: () {
              int newIndex =
                  (_currentAppBarColorIndex + 1) % _appBarColors.length;
              _changeAppBarColor(newIndex, true);
            },
          ),
          IconButton(
            icon: const Icon(Icons.format_paint_outlined),
            tooltip: 'Cambiar color de fondo',
            onPressed: () {
              int newIndex =
                  (_currentScaffoldColorIndex + 1) % _scaffoldColors.length;
              _changeAppBarColor(newIndex, false);
            },
          ),
        ],
      ),
      body: GridView.builder(
        itemCount: _items.length,
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.0,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Center(
              child: Text(
                'Scroll to see the Appbar in effect.',
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
            );
          }
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: _items[index].isOdd ? oddItemColor : evenItemColor,
            ),
            child: Text('Item $index'),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: OverflowBar(
            overflowAlignment: OverflowBarAlignment.center,
            alignment: MainAxisAlignment.center,
            overflowSpacing: 5.0,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Shadow Color'),
                  Switch(
                    value: shadowColor,
                    onChanged: (bool value) {
                      setState(() {
                        shadowColor = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(width: 5),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (scrolledUnderElevation == null) {
                      scrolledUnderElevation = 4.0;
                    } else {
                      scrolledUnderElevation = scrolledUnderElevation! + 1.0;
                    }
                    _showElevationSnackBar();
                  });
                },
                child: Text(
                  'scrolledUnderElevation: ${scrolledUnderElevation ?? 'default'}',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
