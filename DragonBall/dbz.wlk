class Guerrero{
    var property potencialOfensivo = 100
    var property xp = 10
    var property energia = 100
    var property traje

    method atacar(oponente){
        oponente.recibirDanio(oponente.traje().reducirDanio(0.1 * potencialOfensivo))
        self.aumentarXP(self.traje().XpAAumentar(self))
        oponente.traje().seDesgasta()
    }

    method recibirDanio(danioReducidoConTraje) {
      energia -= danioReducidoConTraje
    }

    method aumentarXP(cant) {
      xp += cant
    }

    method comerSemilla() {
      energia = 100
    }

    method elementos() = traje.elementos()

}

class Saiyan inherits Guerrero{  //le agregue que cuando esta en nivel 2 su poder aumente en un 75% y en nivel 3 aumente un 100%
    var estadoSuper = false
    var nivel = 0

    method convertirseEnSSJ(nivelQuerido) {
        if(energia > 100 * 0.01){
            nivel = nivelQuerido
            if(nivel == 1){
                potencialOfensivo *= 1.5
            }
            else if(nivel == 2){
                potencialOfensivo *= 1.75
            }
            else if(nivel == 3){
                potencialOfensivo *= 2
            }
            estadoSuper = true
        }
      
    }

    override method comerSemilla(){
        super()
        potencialOfensivo *= 1.5
    }

    override method recibirDanio(danio){
        if(nivel == 1){
            energia -= (danio * 0.95)
        }
        else if(nivel == 2){
            energia -= (danio * 0.93)
        }
        else if(nivel == 3){
            energia -= (danio * 0.85)
        }
        else if(nivel == 0){
            energia -= danio
        }

        if(energia < 100 * 0.01){
            self.volverAEstadoBase()
        }
    }

    method volverAEstadoBase() {
      estadoSuper = false
      nivel.times({i => self.potencialOfensivo(self.potencialOfensivo() / 1.5)})
      nivel = 0
    }

}

class Traje{
    var desgaste = 0

    method seDesgasta() {
        desgaste += 5
    }

    method estaGastado() = desgaste == 100

    method elementos() = 1
}

class TrajeComun inherits Traje{
    const porcentajeProteccion

    method reducirDanio(cantidadDanio){
        if(self.estaGastado()){
            return cantidadDanio
        }
        else{
            return ((porcentajeProteccion/100) * cantidadDanio)
        }
    }

    method XpAAumentar(guerrero) = 0
}

class TrajeEntrenamiento inherits Traje{ 
    const porcentajeAumentoXP = 200

    method reducirDanio(cantidadDanio) = cantidadDanio

    method XpAAumentar(guerrero) = porcentajeAumentoXP / 100
}

class TrajeModularizado{
    const piezas = []

    method reducirDanio(cantidadDanio){
        if(self.estaGastado()){
            return cantidadDanio
        }
        else{
            return cantidadDanio - self.piezasNoGastada().sum({pieza => pieza.resistencia()})
        }
    }

    method piezasNoGastada() = piezas.filter({pieza => pieza.estaGastado().negate()})

    method estaGastado() = piezas.all({pieza => pieza.estaGastado()})

    method XpAAumentar(guerrero) = (self.piezasNoGastada().size() / self.elementos())

    method elementos() = piezas.size()
}

class Piezas{
    const property resistencia
    const desgaste

    method estaGastado() = desgaste >= 20
}


class Torneo{
    const peleadores = []
    var property modalidad

    method participantes() = modalidad.getParticipantes(peleadores)
}

object powerIsBest{
    method getParticipantes(peleadores) = self.ordenarPeleadores(peleadores).take(16)

    method ordenarPeleadores(peleadores) = peleadores.sortBy({peleador => peleador.potencialOfensivo()})
}

object funny{
    method getParticipantes(peleadores) = self.peleadoresConMasElem(peleadores).take(16)

    method peleadoresConMasElem(peleadores) = peleadores.sortBy({peleador => peleador.elementos()})
}

object surprice{
    method getParticipantes(peleadores) = peleadores.shuffle().take(16)
}