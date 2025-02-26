import casas_HarryPotter.*
import hechizos_HarryPotter.*
import hogwarts.*
import bots_HarryPotter.*

class Materia{
  const profesor
  const hechizoMateria

  method aprender(estudiante) {
  estudiante.agregarHechizo(hechizoMateria)
}
}

object defensaContraLosHackeosOscuros inherits Materia(profesor = severus, hechizoMateria = inmobilus){

}