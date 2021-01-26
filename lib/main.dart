import 'package:flutter/material.dart';

import 'google_maps/view/google_maps.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mustafa App',
      home: GoogleMaps(),
    );
  }
}
