import bots_HarryPotter.*
import hechizos_HarryPotter.*
import hogwarts.*
import materias_HarryPotter.*

class Casa{
    const integrantes = []

    method getIntegrantes() = integrantes

    method esPeligrosa() = integrantes.count({estudiante => estudiante.aceitePuro().negate()}) > integrantes.count({estudiante => estudiante.aceitePuro()})
}
object gryffindor inherits Casa{
    override method esPeligrosa() = false
}

object slytherin inherits Casa{
    override method esPeligrosa() = true
}

object ravenclaw inherits Casa{

}

object hufflepuff inherits Casa{
  
}