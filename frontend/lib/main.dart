import 'package:flutter/material.dart';

import 'screens/app_shell.dart';
import 'services/api_service.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const TruckTrailerApp());
}

class TruckTrailerApp extends StatelessWidget {
  const TruckTrailerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Truck & Trailer Repair',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: AppShell(api: ApiService()),
    );
  }
}
