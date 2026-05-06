enum VehicleType {
  truck('truck'),
  trailer('trailer');

  const VehicleType(this.value);
  final String value;
}

class Vehicle {
  const Vehicle({
    required this.id,
    required this.type,
    required this.clientName,
    this.registrationNumber,
    this.chassisNumber,
    this.serialNumber,
    this.vin,
    this.clientContact,
    this.initialInspection,
  });

  final int id;
  final VehicleType type;
  final String clientName;
  final String? registrationNumber;
  final String? chassisNumber;
  final String? serialNumber;
  final String? vin;
  final String? clientContact;
  final String? initialInspection;

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] as int,
      type: VehicleType.values.firstWhere(
        (type) => type.value == json['type'],
        orElse: () => VehicleType.truck,
      ),
      clientName: json['client_name'] as String,
      registrationNumber: json['registration_number'] as String?,
      chassisNumber: json['chassis_number'] as String?,
      serialNumber: json['serial_number'] as String?,
      vin: json['vin'] as String?,
      clientContact: json['client_contact'] as String?,
      initialInspection: json['initial_inspection'] as String?,
    );
  }
}
