class UserProfile {
  final String id;
  final String email;
  final String nombre;
  final String? apellido;
  final String? telefono;
  final DateTime fechaCreacion;
  final DateTime fechaActualizacion;

  UserProfile({
    required this.id,
    required this.email,
    required this.nombre,
    this.apellido,
    this.telefono,
    required this.fechaCreacion,
    required this.fechaActualizacion,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      email: json['email'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      telefono: json['telefono'],
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      fechaActualizacion: DateTime.parse(json['fecha_actualizacion']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nombre': nombre,
      'apellido': apellido,
      'telefono': telefono,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'fecha_actualizacion': fechaActualizacion.toIso8601String(),
    };
  }
}