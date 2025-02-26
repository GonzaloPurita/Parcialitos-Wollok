import casas_HarryPotter.*
import hechizos_HarryPotter.*
import hogwarts.*
import materias_HarryPotter.*

class Bot{
  var property cargaElectrica = 100
  var property aceitePuro = true

  method reducirCarga(num) {
    cargaElectrica = 0.max(cargaElectrica - num)
  }

  method estaInactivo() = cargaElectrica == 0

  method cambioAceite(nuevoEstado) {
    aceitePuro = nuevoEstado
  }
}

class BotHechicero inherits Bot{
  const hechizos = []
  const property casa = sombrero.elegirCasa()

  method agregarHechizo(nuevoHechizo){
    hechizos.add(nuevoHechizo)
  } 

  method lanzarHechizo(hechizo, objetivo) {
    if(self.tieneHechizo(hechizo) && self.estaActivo() && hechizo.cumpleCondicion(self)){
      hechizo.efecto(objetivo)
    }
    else{
      throw new DomainException(message = "No puede utilizar este hechizo")
    }
  }

  method tieneHechizo(hechizo) = hechizos.contains(hechizo)
  method estaActivo() = true  // no tengo info

  method perteneceACasaPeligrosa() = casa.esPeligrosa()

  method esExperimentado() = hechizos.size() > 3 && cargaElectrica > 50

  method getHechizos() = hechizos
}

class Profesor inherits BotHechicero{
  var property materiasDictadas

  override method esExperimentado() = super() && materiasDictadas > 2

  override method reducirCarga(num){
    if(num >= cargaElectrica){
      cargaElectrica = cargaElectrica / 2
    }
  }
}

class Estudiante inherits BotHechicero{
  method irAClase(materia) {
    materia.aprender(self)
  }
    
}

object sombrero inherits Bot{
  const casas = [gryffindor, slytherin, ravenclaw, hufflepuff]
  var posicionAMandar = 0

  method elegirCasa(){
    const casaRetornada = casas.get(posicionAMandar)
    if(posicionAMandar == 3){
      posicionAMandar = 0
    }
    else{
      posicionAMandar += 1
    }
    return casaRetornada
  }

  override method cambioAceite(nuevoEstado) {

  }
}

object severus inherits Profesor(hechizos = [sectumSempra, avadakedabra, legardiumLebiosa, inmobilus], casa = slytherin, materiasDictadas = defensaContraLosHackeosOscuros){

}