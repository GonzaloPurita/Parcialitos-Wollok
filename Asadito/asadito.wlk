class Persona{
  var property posicion = 0
  var property elementos = []
  var property criterioElem
  var property comidasConsumidas = []
  var property criterioComida
  const nombre

  method tieneElemento(elemento) = elementos.contains(elemento)

  method pedirPasarCosas(otraPersona, elemento) {
    if(otraPersona.tieneElemento(elemento)){
      criterioElem.realizarCriterio(self, otraPersona, elemento)
    }
  }

  method comer(comida){
    criterioComida.puedeComer(self, comida)
  }

  method estaPipon() = comidasConsumidas.any({comida => comida.esPesada()})

  method laEstaPasandoBien() = comidasConsumidas.isEmpty().negate() && nombre.cumpleCondicion(self)
}

//CONDICION PARA SABER SI ESTA BIEN
object osky{
  method cumpleCondicion(persona) = true
}

object moni{
  method cumpleCondicion(persona) = persona.posicion() == "1@1"
}

object facu{
  method cumpleCondicion(persona) = persona.comidasConsumidas().any({comida => comida.esCarne()})
}

object vero{
  method cumpleCondicion(persona) = persona.elementos().size() <= 3
}

//CRITERIOS PARA ELEGIR LA COMIDA
object criterioVegetariano{
  method puedeComer(persona, comida) {
    if(comida.esCarne().negate()){
      persona.comidasConsumidas().add(comida)
    }
  }
}

object criterioDietetico{
  method puedeComer(persona, comida) {
    if(comida.calorias() <= oms.caloriasRecomendadas()){
      persona.comidasConsumidas().add(comida)
    }
  }
}

class CriterioAlternado{
  var flag = true

  method puedeComer(persona, comida) {
    if(flag){
      persona.comidasConsumidas().add(comida)
      flag = false
    }
    else{
      flag = true
    }
  }
}

object criterioVegXDietetico{  //invente una combinacion
  method puedeComer(persona, comida) {
    if(comida.calorias() <= oms.caloriasRecomendadas() && comida.esCarne().negate()){
      persona.comidasConsumidas().add(comida)
    }
  }
}


//CRITERIOS PARA PASAR COMIDA
object criterioSordo{
  method realizarCriterio(pedidor, otraPersona, elemento){
    const elemetoElegido = otraPersona.elementos().first()
    pedidor.elementos().add(elemetoElegido)
    otraPersona.elementos().remove(elemetoElegido)
  }
}

object criterioTranquilidad{
  method realizarCriterio(pedidor, otraPersona, elemento){
    pedidor.elementos(pedidor.elementos() + otraPersona.elementos())
    //pedidor.elementos().toSet().toList()     para no repetir elementos
  }
}

object criterioChange{
  method realizarCriterio(pedidor, otraPersona, elemento){
    const aux = pedidor.posicion()
    pedidor.posicion(otraPersona.posicion())
    otraPersona.posicion(aux)
  }
}

object criterioNormal{
  method realizarCriterio(pedidor, otraPersona, elemento){
    pedidor.elementos().add(elemento)
    otraPersona.elementos().remove(elemento)
  }
}

class Comida{
  var property calorias
  var property esCarne = true

  method esPesada() = calorias > oms.caloriasRecomendadas()
}

object oms{
  const property caloriasRecomendadas = 500
}