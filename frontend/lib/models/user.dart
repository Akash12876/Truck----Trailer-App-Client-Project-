enum UserRole {
  superAdmin('super_admin'),
  admin('admin'),
  technician('technician');

  const UserRole(this.value);
  final String value;
}
