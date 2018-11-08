;Regla para establecer la estrategia y el comando 
(defrule inicio
(declare (salience 100))
=>
(set-strategy random)
(dribble-on "dribble.txt")
)

;Regla para habilitar la nueva accion correspondiente en cada ronda
(defrule AccionesRonda
?info <- (InfoJuego (turno ?y) (fase ?x))
(test (eq ?x 1))
(AccionDisponible (nombre ?nombre) (turno ?turno))
(test (eq ?y ?turno))
?a <-(object (is-a Accion) (nombre ?nombreA))
(test (eq ?nombreA ?nombre))
=>
(modify-instance ?a (disponible True))
(modify ?info (fase (+ ?x 1)))
)

;Regla para colocar nuevos recursos y animales
(defrule Recolocar
(InfoJuego (turno ?y) (fase ?x))
(test (neq ?y 1))
(test (eq ?x 2))
?a <-(object (is-a Accion) (nombre ?nombreA) (disponible ?disponible) (cantidad ?cantidad) (recolocar ?recolocar) (recolocado ?recolocado))
(test (> ?recolocar 0))
(test (eq ?disponible True))
(test (eq ?recolocado False))
=>
(modify-instance ?a (cantidad (+ ?cantidad ?recolocar)) (recolocado True))
)

;Regla para comprobar que se han recolocado todos
(defrule FinRecolocar
(not (and (InfoJuego (turno ?y) (fase ?x))
(test (neq ?y 1))
(test (eq ?x 2))
(object (is-a Accion) (nombre ?nombreA) (disponible ?disponible) (cantidad ?cantidad) (recolocar ?recolocar) (recolocado ?recolocado))
(test (> ?recolocar 0))
(test (eq ?disponible True))
(test (eq ?recolocado False))))
?info <- (InfoJuego (turno ?y) (fase ?x))
?a <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (cantidad ?cantidad) (recolocar ?recolocar) (recolocado ?recolocado))
(test (eq ?x 2))
=>
(modify ?info (fase (+ ?x 1)))
)
;Regla para cuando acabe de recolocar ponga los valores de recolocado a False 
(defrule ValoresRecolocado
(declare (salience 100))
(InfoJuego (turno ?y) (fase ?x))
(test (eq ?x 3))
?a <-(object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (recolocado ?recolocado))
(test (eq ?disponible True))
(test (eq ?recolocado True))
=>
(modify-instance ?a (recolocado False))
)

;Regla para la accion de obtener madera
(defrule ObtenerMadera
?borrar <- (ObtenerMadera ?)
?almacenado <- (object (is-a Almacenado) (tipo ?tipo) (cantidad ?canti))
(test (eq ?tipo Madera))
?accion <- (object (is-a Accion) (nombre ?nombreA) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombreA Bosque))
(Habitantes (total ?total))
?contador <- (Contador ?conta)
(test (eq ?total ?conta))
=>
(retract ?contador)
(assert (Contador (+ ?conta 1)))
(retract ?borrar)
(modify-instance ?almacenado (cantidad (+ ?canti ?cantidad)))
(modify-instance ?accion (utilizado True) (cantidad 0)))

;Regla para la accion de recoger adobe
(defrule ObtenerAdobe
?borrar <- (ObteneAdobe ?)
?almacenado <- (object (is-a Almacenado) (tipo ?tipo) (cantidad ?canti))
(test (eq ?tipo Adobe))
?accion <- (object (is-a Accion) (nombre ?nombreA) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombreA Mina))
(Habitantes (total ?total))
?contador <- (Contador ?conta)
(test (eq ?total ?conta))
=>
(retract ?contador)
(assert (Contador (+ ?conta 1)))
(retract ?borrar)
(modify-instance ?almacenado (cantidad (+ ?canti ?cantidad)))
(modify-instance ?accion (utilizado True) (cantidad 0)))

;Regla para la accion de recoger juncal
(defrule ObtenerJuncal
?borrar <- (ObteneJuncal ?)
?almacenado <- (object (is-a Almacenado) (tipo ?tipo) (cantidad ?canti))
(test (eq ?tipo Juncal))
?accion <- (object (is-a Accion) (nombre ?nombreA) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombreA Juncal))
(Habitantes (total ?total))
?contador <- (Contador ?conta)
(test (eq ?total ?conta))
=>
(retract ?contador)
(assert (Contador (+ ?conta 1)))
(retract ?borrar)
(modify-instance ?almacenado (cantidad (+ ?canti ?cantidad)))
(modify-instance ?accion (utilizado True) (cantidad 0)))

;Regla para la accion de recoger piedra de una de las canteras (no la usamos)
;Como no la usamos solo vamos a crear una de las dos reglas
(defrule ObtenerPiedra1
?borrar <- (ObtenerPiedra ?)
?almacenado <- (object (is-a Almacenado) (tipo ?tipo) (cantidad ?canti))
(test (eq ?tipo Piedra))
?accion <- (object (is-a Accion) (nombre ?nombreA) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombreA CanteraOriental))
(Habitantes (total ?total))
?contador <- (Contador ?conta)
(test (eq ?total ?conta))
=>
(retract ?contador)
(assert (Contador (+ ?conta 1)))
(retract ?borrar)
(modify-instance ?almacenado (cantidad (+ ?canti ?cantidad)))
(modify-instance ?accion (utilizado True) (cantidad 0)))

;Regla para la accion de labrar un campo
(defrule Labranza
?borrar <- (Labranza ?)
?espacios <- (Vacios ?x)
(test (neq ?x 0))
?accion <- (object (is-a Accion) (nombre ?nombreA) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombreA Labranza))
(Habitantes (total ?total))
?contador <- (Contador ?conta)
(test (eq ?total ?conta))
=>
(retract ?contador)
(assert (Contador (+ ?conta 1)))
(retract ?borrar)
(retract ?espacios)
(assert (Vacios (- ?x 1)))
(modify-instance ?accion (utilizado True))
(make-instance ?x of EspacioCampo))

;Regla para recoger cereales
(defrule SemillasCereales
?borrar <- (SemillasCereales ?)
?almacenado <- (object (is-a Almacenado) (tipo ?tipo) (cantidad ?canti))
(test (eq ?tipo Cereal))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre SemillasCereales))
(Habitantes (total ?total))
?contador <- (Contador ?conta)
(test (eq ?total ?conta))
=>
(retract ?contador)
(assert (Contador (+ ?conta 1)))
(retract ?borrar)
(modify-instance ?almacenado (cantidad (+ ?canti ?cantidad)))
(modify-instance ?accion (utilizado True) (cantidad 0)))

;Regla para recoger hortalizas
(defrule SemillasHortalizas
?borrar <- (Hortalizas ?)
?almacenado <- (object (is-a Almacenado) (tipo ?tipo) (cantidad ?canti))
(test (eq ?tipo Hortaliza))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre SemillasHortalizas))
(Habitantes (total ?total))
?contador <- (Contador ?conta)
(test (eq ?total ?conta))
=>
(retract ?contador)
(assert (Contador (+ ?conta 1)))
(retract ?borrar)
(modify-instance ?almacenado (cantidad (+ ?canti ?cantidad)))
(modify-instance ?accion (utilizado True) (cantidad 0)))

;Regla para recoger la comida del Jornalero
(defrule Jornalero
?borrar <- (Jornalero ?)
?almacenado <- (object (is-a Almacenado) (tipo ?tipo) (cantidad ?canti))
(test (eq ?tipo Comida))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre Jornalero))
(Habitantes (total ?total))
?contador <- (Contador ?conta)
(test (eq ?total ?conta))
=>
(retract ?contador)
(assert (Contador (+ ?conta 1)))
(retract ?borrar)
(modify-instance ?almacenado (cantidad (+ ?canti ?cantidad)))
(modify-instance ?accion (utilizado True) (cantidad 0)))

;Regla para recoger comidas de la pesca
(defrule Pesca
?borrar <- (Pesca ?)
?almacenado <- (object (is-a Almacenado) (tipo ?tipo) (cantidad ?canti))
(test (eq ?tipo Comida))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre Pesca))
(Habitantes (total ?total))
?contador <- (Contador ?conta)
(test (eq ?total ?conta))
=>
(retract ?contador)
(assert (Contador (+ ?conta 1)))
(retract ?borrar)
(modify-instance ?almacenado (cantidad (+ ?canti ?cantidad)))
(modify-instance ?accion (utilizado True) (cantidad 0)))

;Regla para ampliar el numero de habitaciones en una
(defrule AmpliarHabitacion
?borrar <- (AmpliarHabitacion ?)
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre ReformarCasa))
?madera <- (object (is-a Almacenado) (tipo ?tipo) (cantidad ?cantim))
(test (eq ?tipo Madera))
?juncal <- (object (is-a Almacenado) (tipo ?tipo) (cantidad ?cantij))
(test (eq ?tipo Juncal))
(test (> ?cantim 5))
(test (> ?cantij 2))
?espacios <- (Vacios ?x)
(test (neq ?x 0))
=>
(modify-instance ?madera (cantidad (- ?cantim 5)))
(modify-instance ?juncal (cantidad (- ?cantij 2)))
(retract ?espacios)
(retract ?borrar)
(assert (Vacios (- ?x 1)))
(make-instance ?x of EspacioHabitacion))

;Regla para Comprar la Cocina
(defrule Cocina
?borrar <- (Cocina ?)
?adobe <- (object (is-a Almacenado) (tipo ?tipo) (cantidad ?canti))
(test (eq ?tipo Adobe))
?cocina <- (object (is-a AdquisicionMayor) (adquirido ?adquirido) (coste ?coste))
(test (> ?canti ?coste))
(test (eq False ?adquirido))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre AdquisicionMayor))
=>
(retract ?borrar)
(modify-instance ?adobe (cantidad (- ?canti ?coste)))
(modify-instance ?cocina (adquirido True))
)

;Regla la accion de ampliar familia planificada
(defrule AmpliacionPlanificada
?borrar <- (Planificada ?)
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq nombre FamiliaPlanificada))
(test (eq ?disponible True))
(test (eq ?utilizado False))
?habitacion <- (object (is-a EspacioHabitacion) (habitantes ?h))
?habita <- (Habitantes (total ?total) (nacidos ?n))
(test (eq ?h 0))
=>
(retract ?borrar)
(modify-instance ?habitacion (habitantes 1))
(modify ?habita (total (+ ?total 1)) (nacidos (+ ?n 1))))


;Reglas para pillar animales
;Regla para colocar vallas


;Regla para sembrar el campo (sin acabar)
(defrule SembrarCereales
?borrar <- (Sembrar ?)
?almacenado <- (object (is-a Almacenado) (tipo ?tipo) (cantidad ?canti))
(test (eq ?tipo Cereal))
(test (neq ?canti 0))
=>
(retract ?borrar)
(assert (SembrarCereales)))


