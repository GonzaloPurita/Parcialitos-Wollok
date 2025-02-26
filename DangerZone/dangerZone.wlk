class Empleado{
  var property vida
  const habilidades = #{}
  var property puesto = null

  method getHabilidades() = habilidades

  method incapacitado() = vida < puesto.vidaCritica()

  method puedeUsarHabilidad(habilidad) = self.incapacitado().negate() && habilidades.contains(habilidad)

  method puedeCumplirMision(mision) = mision.getHabilidadesRequeridas().all({hab => habilidades.contains(hab) && self.puedeUsarHabilidad(hab)})

  method realizarMision(mision) {
    if(self.puedeCumplirMision(mision))
    self.perderVida(mision.nivelPeligrosidad())
  }

  method perderVida(cantidad) {
    vida = (vida - cantidad).max(0)
  }

  method recompensaSobrevivientes(mision){
    //self.realizarMision(mision)
    if(vida > 0)
    puesto.recompensa(mision, self)
  }
}

object espia{
  method recompensa(mision, emple) {
    mision.getHabilidadesRequeridas().forEach({hab => self.aprenderHabilidad(hab, emple.getHabilidades())})
  }

  method aprenderHabilidad(nuevaHabilidad, habilidades) {
    habilidades.add(nuevaHabilidad)
  }

  method vidaCritica() = 15
}

class Oficinista{
  var estrellas = 0

  method recompensa(mision, emple) {
    self.ganarEstrella()
  }

  method ganarEstrella() {
    estrellas += 1
  }

  method vidaCritica() = 40 - 5 * estrellas
}

class Jefe inherits Empleado{
  const subordinados = []

  override method puedeUsarHabilidad(habilidad) = super(habilidad) || subordinados.any({subordinado => subordinado.getHabilidades().contains(habilidad)})
}

class Equipo{
  const miembros = []

  method puedeCumplirMision(mision) = miembros.any({miembro => miembro.puedeCumplirMision(mision)})

  method realizarMision(mision) {
    if(self.puedeCumplirMision(mision))
    miembros.forEach({miembro => miembro.perderVida(mision.nivelPeligrosidad() * (1/3))})
  }

  method recompensaSobrevivientes(mision){
    //self.realizarMision(mision)
    miembros.forEach({miembro => miembro.recompensaSobrevivientes(mision)})
  }
}

class Mision{
  const habilidadesRequeridas = []
  var property nivelPeligrosidad = 0

  method getHabilidadesRequeridas() = habilidadesRequeridas
}