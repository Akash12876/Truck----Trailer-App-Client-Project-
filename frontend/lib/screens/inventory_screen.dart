import 'package:flutter/material.dart';

import '../models/vehicle.dart';
import '../services/api_service.dart';
import '../widgets/section_card.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({required this.api, super.key});

  final ApiService api;

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final _client = TextEditingController();
  final _contact = TextEditingController();
  final _registration = TextEditingController();
  final _vin = TextEditingController();
  final _inspection = TextEditingController();
  var _type = VehicleType.truck;
  late Future<List<Vehicle>> _vehicles;

  @override
  void initState() {
    super.initState();
    _vehicles = widget.api.fetchVehicles();
  }

  @override
  void dispose() {
    _client.dispose();
    _contact.dispose();
    _registration.dispose();
    _vin.dispose();
    _inspection.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    await widget.api.admitVehicle({
      'type': _type.value,
      'client_name': _client.text.trim(),
      'client_contact': _contact.text.trim(),
      'registration_number': _registration.text.trim(),
      'vin': _vin.text.trim(),
      'initial_inspection': _inspection.text.trim(),
    });
    _client.clear();
    _contact.clear();
    _registration.clear();
    _vin.clear();
    _inspection.clear();
    setState(() => _vehicles = widget.api.fetchVehicles());
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionCard(
          title: 'Vehicle Intake',
          child: Column(
            children: [
              DropdownButtonFormField<VehicleType>(
                value: _type,
                decoration: const InputDecoration(labelText: 'Vehicle type'),
                items: VehicleType.values
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(type.value),
                      ),
                    )
                    .toList(),
                onChanged: (type) {
                  if (type != null) setState(() => _type = type);
                },
              ),
              const SizedBox(height: 12),
              TextField(controller: _client, decoration: const InputDecoration(labelText: 'Client name')),
              const SizedBox(height: 12),
              TextField(controller: _contact, decoration: const InputDecoration(labelText: 'Client contact')),
              const SizedBox(height: 12),
              TextField(controller: _registration, decoration: const InputDecoration(labelText: 'Registration number')),
              const SizedBox(height: 12),
              TextField(controller: _vin, decoration: const InputDecoration(labelText: 'VIN')),
              const SizedBox(height: 12),
              TextField(
                controller: _inspection,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Initial inspection'),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.add),
                  label: const Text('Admit'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'Current Inventory',
          child: FutureBuilder<List<Vehicle>>(
            future: _vehicles,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final vehicles = snapshot.data!;
              if (vehicles.isEmpty) return const Text('No vehicles admitted yet.');
              return Column(
                children: vehicles
                    .map(
                      (vehicle) => ListTile(
                        leading: Icon(
                          vehicle.type == VehicleType.truck
                              ? Icons.local_shipping
                              : Icons.rv_hookup,
                        ),
                        title: Text(vehicle.clientName),
                        subtitle: Text(vehicle.registrationNumber ?? vehicle.vin ?? 'No identifier'),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}
