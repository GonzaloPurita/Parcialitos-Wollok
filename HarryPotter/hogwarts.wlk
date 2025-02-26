import casas_HarryPotter.*
import hechizos_HarryPotter.*
import bots_HarryPotter.*
import materias_HarryPotter.*

object hogwarts{
  const estudiantes = []

  method asistirAClase(materia) {
    estudiantes.forEach({est => est.irAClase(materia)})
  }

  method lanzarHechizoConjunto(casa, botMaligno) {
    casa.getIntegrantes().forEach({est => est.lanzarHechizo(est.getHechizos().last(), botMaligno)})
  }
}