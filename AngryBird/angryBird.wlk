class Pajaro{
    var ira

    method fuerza() = ira * 2  

    method seEnoja() {
      ira *= 2
    }

    method tranquilizar(){
        ira -= 5
    }

    method puedeDerribarlo(obstaculo) = self.fuerza() >= obstaculo.resistencia()
}

class PajaroRencoroso inherits Pajaro{
    var cantVecesEnojado = 0

    override method seEnoja() {
        super()
        cantVecesEnojado += 1
    }
}

class Red inherits PajaroRencoroso{
    override method fuerza() = ira * 10 * cantVecesEnojado
}

class Terence inherits PajaroRencoroso{
    const multiplicador

    override method fuerza() = ira * multiplicador * cantVecesEnojado
}

class Bomb inherits Pajaro{
    const topeFuerza = 9000

    override method fuerza() = (ira * 2).min(topeFuerza)
}

class Chuck inherits Pajaro{
    var velocidad

    override method fuerza() = 150 + 5 * self.kmExcedente()

    method kmExcedente() = (velocidad - 80).max(0)

    override method seEnoja() {
        velocidad *= 2
    }

    override method tranquilizar(){

    }
}

class Matilda inherits Pajaro{
    const huevos = []

    override method fuerza() = (ira * 2) + huevos.sum({huevo => huevo.fuerza()})

    override method seEnoja() {
        huevos.add(new Huevo(peso = 2)) //2kg
    }
}

class Huevo{
    const peso
    method fuerza() = peso
}

// ISLA PAJARO

class IslaPajaro{
    var property pajaros = []

    method pajarosFuertes() = pajaros.filter({pajaro => pajaro.fuerza() > 50})

    method fuerza() = self.pajarosFuertes().sum({pajaro => pajaro.fuerza()})

    method hacerEvento(evento) {
      evento.realizarEvento(self)
    }

    method atacarIslaCerdito(islaCerdito){
      pajaros.forEach({pajaro => IslaCerdito.acabarObstaculo(pajaro)})
    }

    method seRecuperaronLosHuevos(islaCerdito) = islaCerdito.obstaculos().isEmpty()
}

// EVENTOS

object sesionDeManejoDeLaIra{
    method realizarEvento(isla) {
      isla.pajaros().forEach({pajaro => pajaro.tranquilizar()})
    }
}

class InvasionCerditos{
    const cantCerdosInvasores
    const contador = (cantCerdosInvasores / 100).floor()

    method realizarEvento(isla) {
        contador.times({i => isla.pajaros().forEach({pajaro => pajaro.seEnoja()})})
    }
}

object fiestaSorpresa{
    method realizarEvento(isla) {
        if(isla.pajarosHomenajeados().isEmpty()){
            throw new DomainException(message = "No se puede realizar la fiesta")
        }
        else{
            isla.pajarosHomenajeados().forEach({pajaro => pajaro.seEnoja()})  //no se quienes son los pajaros homenajeados
        }
    }
}

class SerieDeEventos{
    const eventos = []

    method realizarEvento(isla){
        eventos.forEach({evento => evento.realizarEvento(isla)})
    }
}

// OBSTACULOS

class Pared{
    const anchura

    method resistencia() = self.factorMult() * anchura

    method factorMult()
}

class ParedVidrio inherits Pared{
    override method factorMult() = 10
}

class ParedMadera inherits Pared{
    override method factorMult() = 25
}
class ParedPiedra inherits Pared{
    override method factorMult() = 50
}

class CerditoObrero{
    method resistencia() = 50
}

class CerditoArmado{
    const equipamiento

    method resistencia() = 10 * equipamiento.resistencia()
}

// EQUIPAMIENTO

class Casco{
    var property resistencia
}

class Escudo{
    var property resistencia
}

// ISLA CERDITO

class IslaCerdito{
    var property cerditos = []
    var property obstaculos = []

    method acabarObstaculo(pajaro) {
      if(obstaculos.last().resistencia() <= pajaro.fuerza()){
        obstaculos.remove(obstaculos.last())
      }
    }
}