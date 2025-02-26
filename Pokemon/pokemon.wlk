class Pokemon{
  var property vidaMax
  var property vida = vidaMax
  const movimientos = []
  var property condicion = normal

  method perderVida(cant) {
    vida -= cant
  }

  method curar(ps) {
    self.vida((self.vida() + ps).min(vidaMax))
  }

  method atacar(danio, contrincante) {
    //contrincante.vida((self.vida() - danio).max(0))
    contrincante.perderVida(danio)
  }

  method setCondicion(condicionNueva){
    condicion = condicionNueva
  }

  method grositud() = vidaMax * movimientos.sum({movimiento => movimiento.poder()})

  method estaVivo() = vida > 0

  method luchaPorTurnos(contrincante){
    if(self.estaVivo() && condicion.intentaMoverse(self)){
      self.luchar(contrincante)
      if(contrincante.estaVivo() && contrincante.condicion().intentaMoverse(self)){
        contrincante.luchar(self)
      }
    }
  }

  method luchar(contrincante) {
    condicion.intentaNormalizar(self)
    const movAUsar = movimientos.find({mov => mov.estaDisponible()})
    movAUsar.usarMovimiento(self, contrincante)
  }

  method normalizar(){
    condicion = normal
  }

}

class Movimiento{
  var property atributoMov = null
  var property usos

  method efecto(usuario, contrincante)

  method usarMovimiento(usuario, contrincante) {
    if(self.estaDisponible()){  //no haria falta verificar si esta disponible porque en la lucha buscamos usar un movimiento disponible
      self.efecto(usuario, contrincante)
      usos -= 1
    }
  }

  method estaDisponible() = usos > 0
}

class MovCurativo inherits Movimiento{

  override method efecto(usuario, contrincante){
    usuario.curar(atributoMov)
  }

  method poder() = atributoMov
}

class MovDanino inherits Movimiento{

  override method efecto(usuario, contrincante){
    contrincante.atacar(atributoMov, contrincante)  
  }

  method poder() = atributoMov * 2
}

class MovEspecial inherits Movimiento{

  override method efecto(usuario, contrincante){
    contrincante.setCondicion(atributoMov)
  }

  method poder() = atributoMov.getPoder()  //el atributo aca es la condicion del pokemon
}

class CondicionEsp{
  method intentaMoverse(pokemon) = 0.randomUpTo(2).roundUp().even()

  method intentaNormalizar(pokemon){

  }
}

object paralisis inherits CondicionEsp{
  method getPoder() = 30
}

object suenio inherits CondicionEsp{
  method getPoder() = 50

  override method intentaNormalizar(pokemon) {
    pokemon.normalizar()
  }
}

object normal inherits CondicionEsp{
  override method intentaMoverse(pokemon) = true
  method getPoder() = 0
}

class Confusion{
  var property turnosMax
  var property turnos = turnosMax
  method getPoder() = 40 * turnosMax

  method intentaMoverse(pokemon){
    if(turnos > 0){
      pokemon.perderVida(20)
      turnos -= 1
      return false
    }
    else if(turnos == 0){
      return true
    }
    else{
      throw new DomainException(message = "Error de turnos negativos")
    }
  }

  method intentaNormalizar(pokemon){
    if(turnos == 0){  //no seria necesaria esta verificacion porque si pudo moverse, entonces significa que los turnos se acabaron
      pokemon.normalizar()
    }
  }
}