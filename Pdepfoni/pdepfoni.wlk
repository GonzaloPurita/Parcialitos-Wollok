object pdepfoni{
  const property precioXSeg = 0.05
  const property precioFijo = 1
  const property precioXMB = 0.1
}

class Linea{
  const property telefono
  const packs = []
  const property consumos = []
  var property plan = comun

  method costoPromedio(fechaInicial, fechaFinal) = self.consumoEntreDias(fechaInicial, fechaFinal) / consumos.size()
  method consumoEntreDias(fechaInicial, fechaFinal) = (self.consumosDentroDeRango(fechaInicial, fechaFinal)).sum({consumo => consumo.costo()})
  method consumosDentroDeRango(fechaInicial, fechaFinal) = consumos.filter({consumo => consumo.fecha().between(fechaInicial, fechaFinal)})

  method costoUltimoMes() = self.consumoEntreDias(new Date().minusMonths(1), new Date())

  method agregarPack(nuevoPack) {
    packs.add(nuevoPack)
  }

  method puedeHacerConsumo(consumo) = packs.any({pack => pack.satisfaceConsumo(consumo)})

  method realizarConsumo(consumo) {
    plan.realizarConsumo(consumo, self)
  }

  method gastoPack(consumo){
    const packsAlReves = packs.reverse()
    const packConsumir = packsAlReves.find{pack => pack.satisfaceConsumo(consumo)}
    packConsumir.consumir(consumo)
  }

  /*method limpiezaPacks() {
    const nuevaListaPacks = packs.filter{pack => pack.estaVencido().negate() || pack.estaAcabado().negate()}
    packs = nuevaListaPacks
  }*/
  method limpiezaPacks() {
    packs.removeAllSuchThat{pack => pack.estaVencido() || pack.estaAcabado()}
  }
}

object comun{
  method realizarConsumo(consumo, linea) {
    if(linea.puedeHacerConsumo(consumo)){
      linea.consumos().add(consumo)
      linea.gastoPack(consumo)
    }
    else{
      throw new DomainException(message = "No puede realizarse el consumo")
    }
  }
}

class Black{
  var deuda = 0

  method realizarConsumo(consumo, linea) {
    if(linea.puedeHacerConsumo(consumo)){
      linea.consumos().add(consumo)
      linea.gastoPack(consumo)
    }
    else{
      linea.consumos().add(consumo)
      deuda += consumo.costo()
    }
  }
}

object platinum{
  method realizarConsumo(consumo, linea) {
    linea.consumos().add(consumo)
    linea.gastoPack(consumo)
  }
}

class Pack{
  const fechaVencimiento

  method satisfaceConsumo(consumo){
    if(self.noVence() || self.estaVencido().negate()){
      return self.satisface(consumo)
    }
    else{
      return false
    }
  }

  method consumir(consumo) {
    
  }

  method satisface(consumo) 

  method noVence() = fechaVencimiento == null  // en esta implementacion supongamos que un pack vence cuando su fecha de vencimiento esta inicializada en null
  method estaVencido() = fechaVencimiento < new Date() && fechaVencimiento != null
  method estaAcabado() = false
}

class PackCreditos inherits Pack{
  var property credito

  override method satisface(consumo) = credito >= consumo.costo()

  override method consumir(consumo) {
    credito -= consumo.costo()
  }

  override method estaAcabado() = credito <= 0
}

class PackMBLibre inherits Pack{
  var property cantMB

  override method satisface(consumo) = consumo.leSirveElPackMBLibre(cantMB)

  override method consumir(consumo) {
    cantMB -= (consumo.costo() / pdepfoni.precioXMB())
  }

  override method estaAcabado() = cantMB <= 0
}

class PackMBLibreMas inherits PackMBLibre{
  override method satisface(consumo) = consumo.leSirveElPackMBLibreMas()

  override method estaAcabado() = false
}

class PackCallFree inherits Pack{
  override method satisface(consumo) = consumo.leSirveElPackCallFree()
}

class PackInternetFindes inherits Pack{
  override method satisface(consumo) = consumo.fecha().dayOfWeek() == "saturday" || consumo.fecha().dayOfWeek() == "sunday"
}

class Consumo{
  const property fecha

  method leSirveElPackMBLibre(cantMB) = false
  method leSirveElPackMBLibreMas() = false
  method leSirveElPackCallFree() = false
}
class ConsumoInternet inherits Consumo{
  const megabits

  method costo() = megabits * pdepfoni.precioXMB()

  override method leSirveElPackMBLibre(cantMB) = megabits <= cantMB
  override method leSirveElPackMBLibreMas() = megabits <= 0.1
}

class ConsumoLlamadas inherits Consumo{
  const tiempoLlamada

  method costo() = pdepfoni.precioFijo() + self.tiempoRestante() * pdepfoni.precioXSeg()
  method tiempoRestante() = (tiempoLlamada - 30).max(0)

  override method leSirveElPackMBLibre(cantMB) = self.costo() <= cantMB * pdepfoni.precioXMB()
  override method leSirveElPackMBLibreMas() = self.costo() <= 0.1 * pdepfoni.precioXMB()
  override method leSirveElPackCallFree() = true
}