class TurnoData {
  final String turno;
  final String origen;

  TurnoData({required this.turno, required this.origen});

  Map<String, dynamic> toJson() => {
    'turno': turno,
    'origen': origen
  };

  factory TurnoData.fromJson(Map<String, dynamic> json)
  => TurnoData(turno: json['turno'], origen: json['origen']);
}
