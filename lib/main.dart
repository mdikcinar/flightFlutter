import 'package:flutter/material.dart';

import 'core/device/theme/theme.dart';
import 'google_maps/view/google_maps.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flight App',
      home: GoogleMaps(),
      theme: myTheme,
    );
  }
}
