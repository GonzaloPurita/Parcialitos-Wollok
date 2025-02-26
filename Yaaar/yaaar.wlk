class Barco{
  const tripulantes = []
  var mision = null
  const property capacidad

  method agregarTripulante(newTripulante) {
    if(self.admiteUnoMas())
      tripulantes.add(newTripulante)
  }

  method getMision() = mision
  method cambiarMision(newMision){
    mision = newMision
      //tripulantes = tripulantes.filter({tripulante => mision.esUtil(tripulante)})
    tripulantes.removeAllSuchThat({tripulante => mision.esUtil(tripulante).negate()})
  }

  method getTripulantes() = tripulantes

  method esTemible() = mision.condicionRealizar(self) && tripulantes.filter({tripulante => mision.esUtil(tripulante)}).size() >= 5

  method animarASaquear(tripulante) = tripulante.estaPasado() && tripulante.tieneItem("botella")

  method esVulnerable(otroBarco) = tripulantes.size() <= (otroBarco.getTripulantes().size() / 2)

  method admiteUnoMas() = tripulantes.size() < capacidad

  method itemMasRaro() = self.itemsTripulantes().min({item => self.cantidadDeTripulantesQueTienen(item)})  // voy a devolver el item que menos tripulantes tengan
  method itemsTripulantes() = tripulantes.flatMap({tripulante => tripulante.getItems()})  //flatMap transforma la lista de tripulantes y acopla las listas de items en una sola lista, podria usar un map y tambien el metodo flatten
  method cantidadDeTripulantesQueTienen(item) = tripulantes.count({tripulante => tripulante.tieneItem(item)})  //count me dice la cantidad de tripulantes que cumplen la condicion

  method masEbrio() = tripulantes.max({tripulante => tripulante.nivelEbriedad()})

  method anclar(ciudad) {
    tripulantes.forEach({tripulante => tripulante.aumentarNivelEbriedad(5, ciudad)})
    tripulantes.remove(self.masEbrio())
    ciudad.agregarHabitante(self.masEbrio())
  }
  
  method tieneSufucienteTripulacion() = tripulantes >= capacidad * 0.9
}

class Mision{
  method condicionRealizar(barco) = barco.tieneSufucienteTripulacion()
}

object misionBusqueda inherits Mision{
  method esUtil(tripulante) = #{"brujula", "mapa", "botella"}.any({item => tripulante.tieneItem(item)}) && tripulante.dinero() <= 5

  override method condicionRealizar(barco) = super(barco) && barco.getTripulantes().any({tripulante => tripulante.tieneItem("llave")})
}

class MisionSerLeyenda inherits Mision{
  const itemObligatorio

  method esUtil(tripulante) = tripulante.getItems().size() >= 10 && tripulante.tieneItem(itemObligatorio)
}

class MisionSaqueos inherits Mision{
  const victima
  var property cantDeterminada

  method esUtil(tripulante) = tripulante.dinero() < cantDeterminada && tripulante.seAnimaASaquear(victima)

  override method condicionRealizar(barco) = super(barco) && victima.esVulnerable(barco)
}

class CiudadCostera{
  const habitantes = []
  const property precioTrago

  method agregarHabitante(newHabitante) {
    habitantes.add(newHabitante)
  }

  method animarASaquear(tripulante) = tripulante.nivelEbriedad() >= 50

  method esVulnerable(barco) = barco.getTripulantes().size() >= habitantes.size() * 0.4 || barco.getTripulantes().all({tripulante => tripulante.estaPasado()})
}

class Pirata{
  const items = []
  var property nivelEbriedad
  var property dinero

    method gastarMonedas(cant) {
      dinero = (dinero - cant).max(0)
    }

    method agregarItems(newItem) {
      items.add(newItem)
    }
  method getItems() = items

  method tieneItem(item) = items.contains(item)

  method estaPasado() = nivelEbriedad >= 90

  method seAnimaASaquear(victima) = victima.animarASaquear(self)

  method puedeFormarParteDeUnBarco(barco) = barco.admiteUnoMas() && barco.getMision().esUtil(self)     //self.esUtil(barco.getMision())

  method aumentarNivelEbriedad(cant, ciudad) {
    if(dinero >= ciudad.precioTrago()){
      nivelEbriedad += cant
      self.gastarMonedas(ciudad.precioTrago())
    }
  }
  
  method esUtil(mision) = mision.esUtil(self)
}

class PirataEspia inherits Pirata{
  override method estaPasado() = false
  override method seAnimaASaquear(victima) = super(victima) && self.tieneItem("permisoDeLaCorona")
}