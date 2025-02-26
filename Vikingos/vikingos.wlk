class Vikingo{
  var property casta
  var property armas
  var property monedas

  method ganarMonedas(cant) {
    monedas += cant
  }

  method esProductivo()

  method irAExpedicion(expedicion) {
    if(self.esProductivo()){
      casta.irAExpedicion(self, expedicion)
    }
    else
    {
      throw new DomainException(message = "no puede ir de expedicion")
    }
  }

  method ascender() {
    casta.ascender(self)
  }
}

object esclavo{
  method irAExpedicion(vikingo, expedicion) {
    if(vikingo.armas() == 0){
      expedicion.mandarVikingo(vikingo)
    }
    else{
      throw new DomainException(message = "No puede subirse a la expedicion por tener armas")
    }
  }

  method ascender(vikingo) {
    vikingo.casta(castaMedia)
    vikingo.recompensa()
  }
}

object castaMedia {
  method irAExpedicion(vikingo, expedicion) {
    expedicion.mandarVikingo(vikingo)
  }

  method ascender(vikingo) {
    vikingo.casta(noble)
  }
}

object noble {
  method irAExpedicion(vikingo, expedicion) {
    expedicion.mandarVikingo(vikingo)
  }

  method ascender(vikingo) {
    
  }
}

class Soldado inherits Vikingo{
  const vidasCobradas

  override method esProductivo() = vidasCobradas > 20 && armas > 0

  method recompensa(){
    armas += 10
  } 
}

class Granjero inherits Vikingo{
  var hijos
  var hectarias

  override method esProductivo() = hectarias >= hijos * 2

  method recompensa(){
    hijos += 2
    hectarias += 2
  } 
}

class Expediciones{
  const objetivos = []
  const integrantes = []

  method getIntegrantes() = integrantes

  method valeLaPena() = objetivos.all({objetivo => objetivo.valeLaPena(integrantes.size())})

  method realizarExpedicion() {
    objetivos.forEach({obj => obj.serInvadido(self)})
  }

  method repartirBotin(botin) {
    integrantes.forEach({vikingo => vikingo.ganarMonedas(botin / self.getIntegrantes().size())})
  }

  method mandarVikingo(vikingo){
    integrantes.add(vikingo)
  }
}

class ObjetivoInvasion{
  method serInvadiro(expedicion) {
    expedicion.repartirBotin(self.botin(expedicion.getIntegrantes().size()))
    self.destruir(expedicion.getIntegrantes().size())
  }

  method botin(cantInvasores) 

  method destruir(cantInvasores)
}

class Capital inherits ObjetivoInvasion{
  const factorDeRiqueza
  var defensores

  method valeLaPena(cantInvasores) = self.botin(cantInvasores) >= 3 * cantInvasores

  override method botin(cantInvasores) = self.defensoresDerrotados(cantInvasores) * factorDeRiqueza

  method defensoresDerrotados(cantInvasores) = cantInvasores.min(defensores)

  override method destruir(cantInvasores) {
    defensores -= self.defensoresDerrotados(cantInvasores)
  }
}

class Aldea inherits ObjetivoInvasion{
  var cantCrucifijos

  method valeLaPena(cantInvasores) = self.botin(cantInvasores) >= 15

  override method botin(cantInvasores) = cantCrucifijos

  override method destruir(cantInvasores){
    cantCrucifijos = 0
  }
}

class AldeaAmurallada inherits Aldea{
  const cantMinima

  override method valeLaPena(cantInvasores) = super(cantInvasores) && cantInvasores >= cantMinima
}

// 4) Si aparecen los castillos se puede implemetar agregando una nueva clase Castillo que herede de objetivoInvasion