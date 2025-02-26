class Persona{
  var property monedas = 20
  var property edad = 0
  var property responsabilidad = new SinOficio()

  method getRecursos() = responsabilidad.getRecursos(self)

  method esDestacado() = responsabilidad.esDestacado(self)

  method ganarMonedas(cantidad) {
    monedas += cantidad
  }
  method gastarMonedas(cantidad) {
    monedas = (monedas - cantidad).max(0)
  }

  method cumplirAnios() {
    edad += 1
  }

  method trabajarEnPlaneta(planeta, persona, tiempo){
    responsabilidad.trabajarEnPlaneta(planeta, persona, tiempo)
  }
}

class SinOficio{
  method getRecursos(persona) = persona.monedas()
  method esDestacado(persona) = (persona.edad()).between(18, 65) && persona.getRecursos() > 30

  method trabajarEnPlaneta(planeta, tiempo, persona) {}
}

class Constructor inherits SinOficio{
  var property construccionesRealizadas
  var property ubicacion = null
  const property inteligencia

  override method getRecursos(persona) = super(persona) + 10 * construccionesRealizadas
  override method esDestacado(persona) = construccionesRealizadas > 5

  override method trabajarEnPlaneta(planeta, tiempo, persona) {
    planeta.agregarConstruccion(ubicacion.getConstruccion(self, tiempo))
    persona.gastarMonedas(5)
    self.construccionesRealizadas(self.construccionesRealizadas()+1)
  }
}

object montania{
  method getConstruccion(persona, tiempo) = new Muralla(longitud = tiempo / 2)
}

object costa{
  method getConstruccion(persona, tiempo) = new Museo(superficie = tiempo, indiceDeImportancia = 1)
}

object llanura{
  method getConstruccion(persona, tiempo){
      if(persona.esDestacado()){
          return new Museo(superficie = tiempo, indiceDeImportancia = self.proporcional(persona.getRecursos()))
      }
      else{
          return new Muralla(longitud = tiempo / 2)
      }
  }

  method proporcional(monto) = (monto / 100).floor().min(5).max(1) 
}

object meseta{
  method getConstruccion(persona, tiempo) = new Muralla(longitud = persona.inteligencia() * 2)
}

class Productor inherits SinOficio{
  const tecnicas = ["cultivo"]
  
  override method getRecursos(persona) = super(persona) * tecnicas.size()
  override method esDestacado(persona) = super(persona) && tecnicas.size() > 5

  method tieneTecnica(tecnica) = tecnicas.contains(tecnica)

  method realizarTecnica(tecnica, tiempo, persona) {
    if(self.tieneTecnica(tecnica)){
      persona.ganarMonedas(3 * tiempo)
    }
    else{
      persona.gastarMonedas(1)
    }
  }

  method aprenderTecnica(tecnica) {
    tecnicas.add(tecnica)
  }

  override method trabajarEnPlaneta(planeta, persona, tiempo) {
    if((planeta.getHabitantes()).contains(persona)){
      self.realizarTecnica(tecnicas.last(), tiempo, persona)
    }
  }
}

class Construcciones{
  method valor() = self.algoMult1() * self.algoMult2()

  method algoMult1()
  method algoMult2()
}

class Muralla inherits Construcciones{
  const longitud

  override method algoMult1() = 10
  override method algoMult2() = longitud
}

class Museo inherits Construcciones{
  const superficie
  const indiceDeImportancia

  override method algoMult1() = superficie
  override method algoMult2() = indiceDeImportancia
}

class Planeta{
  const habitantes = []
  const construcciones = []

  method getHabitantes() = habitantes

  method agregarConstruccion(nuevaConstruccion) {
    construcciones.add(nuevaConstruccion)
  }

  method habitanteConMasRecursos() = habitantes.max({habitante => habitante.getRecursos()})

  method delegacionDiplomatica() = (self.habitantesDestacados() + [self.habitanteConMasRecursos()]).asSet()

  method habitantesDestacados() = habitantes.filter({habitante => habitante.esDestacado()})

  method esValioso() = construcciones.sum({construccion => construccion.valor()}) > 100

  method delegacionATrabajar(tiempo) = self.delegacionTrabajarEnPlaneta(self, tiempo)

  method delegacionTrabajarEnPlaneta(planeta, tiempo) = (planeta.delegacionDiplomatica()).forEach({persona => persona.trabajarEnPlaneta(planeta, tiempo, persona)})

  method invadir(otroPlaneta, tiempo) {
    self.delegacionTrabajarEnPlaneta(otroPlaneta, tiempo)
  }
}