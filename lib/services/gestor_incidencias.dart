import '../data/almacen_local.dart';
import '../model/incidencia.dart';

class GestorIncidencias {
  final AlmacenLocal datos = AlmacenLocal();
  List<Incidencia> incidencias = [];

  Future<void> iniciar() async {
    incidencias = await datos.leer();
  }

  // Aqupi se tiene que poner las otras opciones de búsqueda
  List<Incidencia> buscar(String texto, String filtroEstado, String filtroPrioridad){
    String textoBusqueda = texto.trim().toLowerCase();
    
    // Si no hay búsqueda
    // if (textoBusqueda.isEmpty && filtroEstado == 'Todos' && filtroPrioridad == 'Todas') return incidencias;

    List<Incidencia> resultado = incidencias;

    // Texto
    if(textoBusqueda.isNotEmpty){
      resultado = resultado.where((x) => x.titulo.toLowerCase().contains(textoBusqueda) || x.descripcion.toLowerCase().contains(textoBusqueda)).toList();
    }

    // Estado
    if(filtroEstado != 'Todos'){
      resultado = resultado.where((x) => x.estado == filtroEstado).toList();
    }

    // Prioridad
    if(filtroPrioridad != 'Todas'){
      resultado = resultado.where((x) => x.prioridad == filtroPrioridad).toList();
    }

    return resultado;
  }

  Incidencia? porId(String id) {
    for (var x in incidencias) {
      if (x.id == id) return x;
    }
    return null;
  }

  int contar(String estado) {
    return incidencias.where((x) => x.estado == estado).length;
  }

  Future<void> cambiarEstado(String id, String estado) async {
    for (var i = 0; i < incidencias.length; i++) {
      if (incidencias[i].id == id) {
        incidencias[i].estado = estado;
        break;
      }
    }

    await datos.guardar(incidencias);
  }

  Future<void> cambiarPrioridad(String id, String prioridad) async {
    for (var i = 0; i < incidencias.length; i++) {
      if (incidencias[i].id == id) {
        incidencias[i].prioridad = prioridad;
        break;
      }
    }

    await datos.guardar(incidencias);
  }

  Future<void> crear(String titulo, String descripcion, String cliente,
      String categoria, String prioridad) async {
    final nuevo = Incidencia(
      id: 'INC-${DateTime.now().microsecondsSinceEpoch}',
      titulo: titulo,
      descripcion: descripcion,
      cliente: cliente,
      categoria: categoria,
      estado: 'Pendiente',
      fecha: DateTime.now().toIso8601String().split('T').first,
      prioridad: prioridad
    );
    incidencias.insert(0, nuevo);
    await datos.guardar(incidencias);
  }

  Future<void> reiniciarDemo() async {
    await datos.restaurarDatosDeEjemplo();
    await iniciar();
  }
}
