class Libro {
  final String id;
  final String autor;
  final String estado;
  final String imagenPortada;
  final int paginasLeidas;
  final int paginasTotales;
  final String titulo;

  Libro({
    required this.id,
    required this.autor,
    required this.estado,
    required this.imagenPortada,
    required this.paginasLeidas,
    required this.paginasTotales,
    required this.titulo,
  });

  factory Libro.fromJson(Map<String, dynamic> json, {required String id}) {
    return Libro(
      id: id,
      titulo: json['titulo'] ?? '',
      autor: json['autor'] ?? '',
      estado: json['estado'] ?? '',
      imagenPortada: json['imagenPortada'] ?? '',
      paginasLeidas: json['paginasLeidas'] ?? 0,
      paginasTotales: json['paginasTotales'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'autor': autor, 
      'estado': estado, 
      'imagenPortada': imagenPortada,
      'paginasLeidas': paginasLeidas,
      'paginasTotales': paginasTotales,
      'titulo': titulo,
    };
  }
}