import 'package:flutter/material.dart';

import '../services/api_service.dart';
import 'analytics_screen.dart';
import 'history_screen.dart';
import 'inventory_screen.dart';
import 'jobs_screen.dart';
import 'login_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({required this.api, super.key});

  final ApiService api;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  var _isAuthenticated = false;
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) {
      return LoginScreen(
        api: widget.api,
        onAuthenticated: () => setState(() => _isAuthenticated = true),
      );
    }

    final screens = [
      InventoryScreen(api: widget.api),
      JobsScreen(api: widget.api),
      HistoryScreen(api: widget.api),
      AnalyticsScreen(api: widget.api),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Truck & Trailer Repair'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            onPressed: () {
              widget.api.token = null;
              setState(() => _isAuthenticated = false);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.local_shipping_outlined),
            selectedIcon: Icon(Icons.local_shipping),
            label: 'Inventory',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'Jobs',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights),
            label: 'Analytics',
          ),
        ],
      ),
    );
  }
}
