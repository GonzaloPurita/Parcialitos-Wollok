class Fiesta{
    const ubicacion
    var property fecha = new Date()
    const invitados = []

    method esUnBodrio() = invitados.all({invitado => invitado.estaSatisfechoConElDisfraz().negate()})

    method mejorDisfraz() = (invitados.max({invitado => invitado.puntuacionDisfraz()})).disfraz()

    method sePuedecambioDeTrajes(asistente1, asistente2) = invitados.contains(asistente1) && invitados.contains(asistente2) && self.algunoEstaDisconforme(asistente1, asistente2) && self.seSolucionaCambiandoTraje(asistente1, asistente2)

    method algunoEstaDisconforme(asistente1, asistente2) = asistente1.estaSatisfechoConElDisfraz().negate() || asistente2.estaSatisfechoConElDisfraz().negate()

    method seSolucionaCambiandoTraje(asistente1, asistente2){
        const aux = asistente1.disfraz()
        asistente1.disfraz(asistente2.disfraz())
        asistente2.disfraz(aux)
        return (asistente1.estaSatisfechoConElDisfraz() && asistente2.estaSatisfechoConElDisfraz())
    }

    method agregarAsistente(asistente){
        if(asistente.tieneDisfraz() && asistente.noEstaCargado()){  // cargado??
            invitados.add(asistente)
        }
    }

    method esInolvidable() = invitados.all({invitado => invitado.esSexy() && invitado.estaSatisfechoConElDisfraz()})
}

class Invitado{
    var property disfraz 
    var property edad
    var property fiesta
    var property personalidad

    method puntuacionDisfraz() = disfraz.puntaje(self)

    method esSexy() = personalidad.esSexy(self)

    method estaSatisfechoConElDisfraz() = self.puntuacionDisfraz() > 10

    method tieneDisfraz() = disfraz != null
}

class Caprichoso inherits Invitado{
    override method estaSatisfechoConElDisfraz() = super() && disfraz.nombre().size().even()
}

class Pretencioso inherits Invitado{
    const hoy = new Date()
    const unMesAtras = new Date().minusMonths(1)

    override method estaSatisfechoConElDisfraz() = super() && disfraz.fechaFabricacion().between(unMesAtras,hoy)
}

class Numerologo inherits Invitado{
    var property cifraDeterminada

    override method estaSatisfechoConElDisfraz() = super() && self.puntuacionDisfraz() == cifraDeterminada
}

// PERSONALIDADES

object alegre{
    method esSexy(persona) = false
}

object taciturno{
    method esSexy(persona) = persona.edad() < 30
}


class Disfraz{
    const property fechaFabricacion
    const caracteristicas = []
    const property nombre

    method puntaje(persona){
        if(caracteristicas.isEmpty()){
            return 0
        }
        else{
            return caracteristicas.sum({caracteristica => caracteristica.puntajeCaracteristica(persona)})
        }
    }
}

// CARACTERISTICAS
class Gracioso inherits Disfraz{
    const gracia

    method puntajeCaracteristica(persona){
        if(persona.edad() > 50){
            return gracia * 3
        }
        else{
            return gracia
        }
    }
}

class Tobara inherits Disfraz{
    const fechaCompra

    method puntajeCaracteristica(persona){
        if(fechaCompra <= persona.fiesta().fecha().minusDays(2)){
            return 5
        }
        else{
            return 3
        }
    }
}

class Careta inherits Disfraz{
    const personajeQueImita

    method puntajeCaracteristica(persona){
        return personajeQueImita.puntajePersonaje()
    }
}

object mickey{
    method puntajePersonaje() = 8
}

object osoCarolina{
    method puntajePersonaje() = 6
}

class Sexy inherits Disfraz{
    method puntajeCaracteristica(persona){
        if(persona.esSexy()){
            return 15
        }
        else{
            return 2
        }
    }
}