import casas_HarryPotter.*
import bots_HarryPotter.*
import hogwarts.*
import materias_HarryPotter.*

object inmobilus{
  method efecto(hechicero){
    hechicero.reducirCarga(50)
  }

  method cumpleCondicion(hechicero) = true
}

object sectumSempra{
  method efecto(hechicero){
    if(hechicero.aceitePuro()){
      hechicero.cambioAceite(false)
    }
  }

  method cumpleCondicion(hechicero) = hechicero.esExperimentado()
}

object avadakedabra{
  method efecto(hechicero){
    hechicero.reducirCarga(100)
  }

  method cumpleCondicion(hechicero) = hechicero.aceitePuro().negate() || hechicero.perteneceACasaPeligrosa()
}

class HechizoComun{
  const cantDisminuye

  method efecto(hechicero){
    hechicero.reducirCarga(cantDisminuye)
  }

  method cumpleCondicion(hechicero) = hechicero.cargaElectrica() > cantDisminuye
}

object legardiumLebiosa{
  method efecto(hechicero){
    hechicero.aceitePuro(true)
  }

  method cumpleCondicion(hechicero) = hechicero.cargaElectrica() > 90
}