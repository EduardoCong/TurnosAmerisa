class Cliente {
  final String documento;
  final int numero;
  final String pnombre;
  final String snombre;
  final String papellido;
  final String sapellido;

  Cliente({
    required this.documento,
    required this.numero,
    required this.pnombre,
    required this.snombre,
    required this.papellido,
    required this.sapellido,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      documento: json['documento'],
      numero: json['numero'],
      pnombre: json['pnombre'],
      snombre: json['snombre'],
      papellido: json['papellido'],
      sapellido: json['sapellido'],
    );
  }
}

class Servicio {
  final int id;
  final String nombre;
  final String color;
  final String icono;
  final String letra;

  Servicio({
    required this.id,
    required this.nombre,
    required this.color,
    required this.icono,
    required this.letra
  });

  factory Servicio.fromJson(Map<String, dynamic> json) {
    return Servicio(
      id: int.parse(json['id']),
      nombre: json['nombre_servicio'],
      color: json['color_servicio'],
      icono: json['icono_servicio'],
      letra: json['letra_servicio'],
    );
  }
}

class Turno {
  final int id;
  final String turno;
  final String estado;

  Turno({
    required this.id,
    required this.turno,
    required this.estado,
  });

  factory Turno.fromJson(Map<String, dynamic> json) {
    return Turno(
      id: json['id'],
      turno: json['turno'],
      estado: json['estado_turno'],
    );
  }
}
