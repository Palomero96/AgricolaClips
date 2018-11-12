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

;Reglas para colocar nuevos recursos y animales
(defrule Recolocar
(InfoJuego (turno ?y) (fase ?x))
(test (neq ?y 1))
(test (eq ?x 2))
?a <-(object (is-a Accion) (nombre ?nombreA) (disponible ?disponible) (cantidad ?cantidad) (recolocar ?recolocar) (recolocado ?recolocado) (acumulable ?acumulado))
(test (> ?recolocar 0))
(test (eq ?disponible True))
(test (eq ?recolocado False))
(test (eq ?acumulado True))
=>
(modify-instance ?a (cantidad (+ ?cantidad ?recolocar)) (recolocado True))
)
(defrule Recolocar2
(InfoJuego (turno ?y) (fase ?x))
(test (neq ?y 1))
(test (eq ?x 2))
?a <-(object (is-a Accion) (nombre ?nombreA) (disponible ?disponible) (cantidad ?cantidad) (recolocar ?recolocar) (recolocado ?recolocado) (acumulable ?acumulado))
(test (> ?recolocar 0))
(test (eq ?cantidad 0))
(test (eq ?disponible True))
(test (eq ?recolocado False))
(test (eq ?acumulado False))
=>
(modify-instance ?a (cantidad (+ ?cantidad ?recolocar)) (recolocado True)))

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
(modify ?info (fase (+ ?x 1))))

;Regla para cuando acabe de recolocar ponga los valores de recolocado a False 
(defrule ValoresRecolocado
(declare (salience 100))
(InfoJuego (turno ?y) (fase ?x))
(test (eq ?x 3))
?a <-(object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (recolocado ?recolocado))
(test (eq ?disponible True))
(test (eq ?recolocado True))
=>
(modify-instance ?a (recolocado False)))

;Regla para la accion de obtener madera
(defrule ObtenerMadera
?borrar <- (ObtenerMadera ?)
?almacenado <- (object (is-a Almacenado) (tipo ?tipo) (cantidad ?canti))
(test (eq ?tipo "Madera"))
?accion <- (object (is-a Accion) (nombre ?nombreA) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombreA "Bosque"))
=>
(retract ?borrar)
(modify-instance ?almacenado (cantidad (+ ?canti ?cantidad)))
(modify-instance ?accion (utilizado True) (cantidad 0)))

;Regla para la accion de recoger adobe
(defrule ObtenerAdobe
?borrar <- (ObteneAdobe ?)
?almacenado <- (object (is-a Almacenado) (tipo ?tipo) (cantidad ?canti))
(test (eq ?tipo "Adobe"))
?accion <- (object (is-a Accion) (nombre ?nombreA) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombreA "Mina"))
=>
(retract ?borrar)
(modify-instance ?almacenado (cantidad (+ ?canti ?cantidad)))
(modify-instance ?accion (utilizado True) (cantidad 0)))

;Regla para la accion de recoger juncal
(defrule ObtenerJuncal
?borrar <- (ObteneJuncal ?)
?almacenado <- (object (is-a Almacenado) (tipo ?tipo) (cantidad ?canti))
(test (eq ?tipo "Juncal"))
?accion <- (object (is-a Accion) (nombre ?nombreA) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombreA "Juncal"))
=>
(retract ?borrar)
(modify-instance ?almacenado (cantidad (+ ?canti ?cantidad)))
(modify-instance ?accion (utilizado True) (cantidad 0)))

;Regla para la accion de recoger piedra de una de las canteras (no la usamos)
;Como no la usamos solo vamos a crear una de las dos reglas
(defrule ObtenerPiedra
?borrar <- (ObtenerPiedra ?)
?almacenado <- (object (is-a Almacenado) (tipo ?tipo) (cantidad ?canti))
(test (eq ?tipo Piedra))
?accion <- (object (is-a Accion) (nombre ?nombreA) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombreA "CanteraOriental"))
=>
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
(test (eq ?nombreA "Labranza"))
=>
(retract ?borrar)
(retract ?espacios)
(assert (Vacios (- ?x 1)))
(modify-instance ?accion (utilizado True))
(make-instance ?x of EspacioCampo))

;Regla para recoger cereales
(defrule SemillasCereales
?borrar <- (SemillasCereales ?)
?almacenado <- (object (is-a Almacenado) (tipo ?tipo) (cantidad ?canti))
(test (eq ?tipo "Cereal"))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "SemillasCereales"))
=>
(retract ?borrar)
(modify-instance ?almacenado (cantidad (+ ?canti ?cantidad)))
(modify-instance ?accion (utilizado True) (cantidad 0)))

;Regla para recoger hortalizas
(defrule SemillasHortalizas
?borrar <- (SemillasHortalizas ?)
?almacenado <- (object (is-a Almacenado) (tipo ?tipo) (cantidad ?canti))
(test (eq ?tipo "Hortaliza"))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "SemillasHortalizas"))
=>
(retract ?borrar)
(modify-instance ?almacenado (cantidad (+ ?canti ?cantidad)))
(modify-instance ?accion (utilizado True) (cantidad 0)))

;Regla para recoger la comida del Jornalero
(defrule Jornalero
?borrar <- (Jornalero ?)
?almacenado <- (object (is-a Almacenado) (tipo ?tipo) (cantidad ?canti))
(test (eq ?tipo "Comida"))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "Jornalero"))
=>
(retract ?borrar)
(modify-instance ?almacenado (cantidad (+ ?canti ?cantidad)))
(modify-instance ?accion (utilizado True) (cantidad 0)))

;Regla para recoger comidas de la pesca
(defrule Pesca
?borrar <- (Pesca ?)
?almacenado <- (object (is-a Almacenado) (tipo ?tipo) (cantidad ?canti))
(test (eq ?tipo "Comida"))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "Pesca"))
=>
(retract ?borrar)
(modify-instance ?almacenado (cantidad (+ ?canti ?cantidad)))
(modify-instance ?accion (utilizado True) (cantidad 0)))

;Regla para ampliar el numero de habitaciones en una
(defrule AmpliarHabitacion
?borrar <- (AmpliarHabitacion ?)
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "AmpliacionGranja"))
?madera <- (object (is-a Almacenado) (tipo ?tipo) (cantidad ?cantim))
(test (eq ?tipo "Madera"))
?juncal <- (object (is-a Almacenado) (tipo ?tipo) (cantidad ?cantij))
(test (eq ?tipo "Juncal"))
(test (not (< ?cantim 5)))
(test (not (< ?cantij 2)))
?espacios <- (Vacios ?x)
(test (neq ?x 0))
=>
(modify-instance ?madera (cantidad (- ?cantim 5)))
(modify-instance ?juncal (cantidad (- ?cantij 2)))
(retract ?espacios)
(retract ?borrar)
(assert (Vacios (- ?x 1)))
(modify-instance ?accion (utilizado True))
(make-instance ?x of EspacioHabitacion))

;Regla para Comprar la Cocina
(defrule Cocina
?borrar <- (Cocina ?)
?adobe <- (object (is-a Almacenado) (tipo ?tipo) (cantidad ?canti))
(test (eq ?tipo "Adobe"))
?cocina <- (object (is-a AdquisicionMayor) (adquirido ?adquirido) (adobe ?coste))
(test (not (< ?canti ?coste)))
(test (eq False ?adquirido))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "AdquisicionMayor"))
=>
(retract ?borrar)
(modify-instance ?adobe (cantidad (- ?canti ?coste)))
(modify-instance ?cocina (adquirido True))
(modify-instance ?accion (utilizado True)))

;Regla la accion de ampliar familia planificada
(defrule AmpliacionPlanificada
?borrar <- (Planificada ?)
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq nombre "FamiliaPlanificada"))
(test (eq ?disponible True))
(test (eq ?utilizado False))
?habitacion <- (object (is-a EspacioHabitacion) (habitantes ?h))
?habita <- (Habitantes (total ?total) (nacidos ?n))
(test (eq ?h 0))
=>
(retract ?borrar)
(modify-instance ?habitacion (habitantes 1))
(modify-instance ?accion (utilizado True))
(modify ?habita (total (+ ?total 1)) (nacidos (+ ?n 1))))

;Regla para la accion de ampliar la familia de forma precipitada
(defrule AmpliacionPrecipitada
?borrar <- (Precipitada ?)
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq nombre "FamiliaPlanificada"))
(test (eq ?disponible True))
(test (eq ?utilizado False))
?habitacion <- (object (is-a EspacioHabitacion) (habitantes ?h))
?habita <- (Habitantes (total ?total) (nacidos ?n))
=>
(retract ?borrar)
(modify-instance ?habitacion (habitantes (+ ?h 1)))
(modify-instance ?accion (utilizado True))
(modify ?habita (total (+ ?total 1)) (nacidos (+ ?n 1))))

;Regla para colocar vallas (vamos a cerrar espacios de un tamaño maximo de 1 y que se usen 4 vallas que es lo necesario para cerrar)
(defrule Vallas
?borrar <- (Vallas ?)
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "Vallado"))
?madera <- (object (is-a Almacenado) (tipo ?tipo) (cantidad ?cantim))
(test (eq ?tipo "Madera"))
(test (not (< ?cantim 4)))
?espacios <- (Vacios ?x)
(test (neq ?x 0))
=>
(retract ?espacios)
(retract ?borrar)
(assert (Vacios (- ?x 1)))
(modify-instance ?accion (utilizado True))
(modify-instance ?madera (cantidad (- ?cantim 4)))
(make-instance ?x of EspacioAnimales (tamanio 1) (vallas 4) (habilitado True) (capacidad 2)))

;Regla para la accion de obtener ovejas
(defrule MercadoOvino
(ObtenerOvejas ?x)
(test (eq ?x 1))
?borrar <- (MercadoOvino ?)
?borrar1 <- (ObtenerOvejas ?)
?accion <- (object (is-a Accion) (nombre ?nombreA) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
=>
(retract ?borrar)
(retract ?x)
(retract ?borrar1)
(assert (AnimalColocar (tipo "Oveja") (cantidad 2)))
(assert (AnimalVender (tipo "Oveja") (cantidad (- ?cantidad 2))))
(assert (ColocarAnimal 1))
(assert (VenderAnimal 1)))

;Regla para la accion de obtener cerdos
(defrule MercadoPorcino
(ObtenerCerdos ?x)
(test (eq ?x 1))
?borrar <- (MercadoPorcino ?)
?borrar1 <- (ObtenerCerdos ?)
?accion <- (object (is-a Accion) (nombre ?nombreA) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
=>
(retract ?borrar)
(retract ?x)
(retract ?borrar1)
(assert (AnimalColocar (tipo "Cerdo") (cantidad 2)))
(assert (AnimalVender (tipo "Cerdo") (cantidad (- ?cantidad 2))))
(assert (ColocarAnimal 1))
(assert (VenderAnimal 1)))

;Regla para la accion de obtener vacas
(defrule MercadoBovino
(ObtenerVacas ?x)
(test (eq ?x 1))
?borrar1 <- (ObtenerVacas ?)
?borrar <- (MercadoBovino ?)
?accion <- (object (is-a Accion) (nombre ?nombreA) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
=>
(retract ?borrar)
(retract ?borrar1)
(assert (AnimalColocar (tipo "Vaca") (cantidad 2)))
(assert (AnimalVender(tipo "Vaca") (cantidad (- ?cantidad 2))))
(assert (ColocarAnimal 1))
(assert (VenderAnimal 1)))

;Regla para colocarAnimales
(defrule ColocarAnimales
(ColocarAnimal ?x)
(test (eq ?x 1))
?borrar <- (ColocarAnimal ?)
?espacioAnimales <-(object (is-a EspacioAnimales) (habilitado ?habilitado) (ocupacion ?ocupacion))
(test (eq ?habilitado True))
(test (eq ?ocupacion 0))
?animalColocar <- (AnimalColocar (tipo ?tipo) (cantidad ?cantidad))
(test (not (< ?cantidad 2)))
=>
(retract ?animalColocar)
(retract ?borrar)
(modify-instance ?espacioAnimales (habilitado False) (ocupacion 2) (animal ?tipo)))

;Regla para vender Ovejas
(defrule VenderOvejas
(VenderAnimal ?x)
(test (eq ?x 1))
?borrar <- (VenderAnimal ?)
?cocina <- (object (is-a AdquisicionMayor) (tipo ?tipoCocina) (adquirido ?adquirido))
(test (eq ?tipoCocina "Cocina"))
(test (eq ?adquirido True))
?animalVender<- (AnimalVender (tipo ?tipo) (cantidad ?cantidad))
(test (eq ?tipo "Oveja"))
(test (not (< ?cantidad 1)))
?almacenado <-(object (is-a Almacenado) (tipo ?tipoAlmacenado) (cantidad ?canti))
(test (eq ?tipoAlmacenado "Comida"))
=>
(retract ?animalVender)
(retract ?borrar)
(modify-instance ?almacenado (cantidad (+ ?canti (* 4 ?cantidad)))));No estoy seguro de esto

;Regla para venderAnimales
(defrule VenderCerdos
(VenderAnimal ?x)
(test (eq ?x 1))
?borrar <- (VenderAnimal ?)
?cocina <- (object (is-a AdquisicionMayor) (tipo ?tipoCocina) (adquirido ?adquirido))
(test (eq ?tipoCocina "Cocina"))
(test (eq ?adquirido True))
?animalVender<- (AnimalVender (tipo ?tipo) (cantidad ?cantidad))
(test (eq ?tipo "Cerdo"))
(test (not (< ?cantidad 1)))
?almacenado <-(object (is-a Almacenado) (tipo ?tipoAlmacenado) (cantidad ?canti))
(test (eq ?tipoAlmacenado "Comida"))
=>
(retract ?animalVender)
(retract ?borrar)
(modify-instance ?almacenado (cantidad (+ ?canti (* 3 ?cantidad))))); No estoy seguro de esto

;Regla para vender Vacas
(defrule VenderVacas
(VenderAnimal ?x)
(test (eq ?x 1))
?borrar <- (VenderAnimal ?)
?cocina <- (object (is-a AdquisicionMayor) (tipo ?tipoCocina) (adquirido ?adquirido))
(test (eq ?tipoCocina "Cocina"))
(test (eq ?adquirido True))
?animalVender<- (AnimalVender (tipo ?tipo) (cantidad ?cantidad))
(test (eq ?tipo "Vaca"))
(test (not (< ?cantidad 1)))
?almacenado <-(object (is-a Almacenado) (tipo ?tipoAlmacenado) (cantidad ?canti))
(test (eq ?tipoAlmacenado "Comida"))
=>
(retract ?animalVender)
(retract ?borrar)
(modify-instance ?almacenado (cantidad (+ ?canti (* 4 ?cantidad))))); No estoy seguro de esto


;Regla para sembrar el campo
(defrule Siembra
?borrar <- (Sembrar ?)
?espacioCampo <-(object (is-a EspacioCampo) (cantidad ?cantidad))
(test (eq ?cantidad 0))
?objetoSembrar <- (ObjetoSembrar (tipo ?tipo) (cantidad ?cantidad))
(test (not (< ?cantidad 1)))
=>
(retract ?objetoSembrar)
(retract ?borrar)
(modify-instance ?espacioCampo (tipo "Cereal") (cantidad 3)))

;Regla para hornear
(defrule Hornear
?borrar <- (Hornear ?x)
?cocina <- (object (is-a AdquisicionMayor) (tipo ?tipoCocina) (adquirido ?adquirido))
(test (eq ?tipoCocina "Cocina"))
(test (eq ?adquirido True))
?almacenado <-(object (is-a Almacenado) (tipo ?tipoAlmacenado) (cantidad ?canti))
(test (eq ?tipoAlmacenado "Comida"))
?almacenadoCereal <-(object (is-a Almacenado) (tipo ?tipoCereal) (cantidad ?cantiCereal))
(test (eq ?tipoCereal "Cereal"))
=>
(retract ?borrar)
(modify-instance ?almacenadoCereal (cantidad (- ?cantiCereal ?x)))
(modify-instance ?almacenado (cantidad (+ ?canti (* 2 ?x)))));

;Reglas auxiliares para decidir que hacer en cada turno
;Turno 1
(defrule Turno1
(declare (salience 30))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 1))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (eq 2 ?y))
=>
(assert (Jornalero 1))
(assert (Labranza 1))
(retract ?contador)
(assert (Contador (+ ?x 2))))

;Turno 2
(defrule Turno2Cereal
(declare (salience 30))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 2))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
=>
(assert (SemillaCereales 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno2Siembra
(declare (salience 20))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 2))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?nombre "Siembra"))
=>
(assert (Sembrar 1)) ;OJO AL NOMBRE QUE LE DAREMOS DESPUES EN LA REGLA
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno2Jornalero
(declare (salience 10))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 2))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
=>
(assert (Jornalero 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

;Turno 3
(defrule Turno3
(declare (salience 30))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 3))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (eq 2 ?y))
=>
(assert (ObtenerMadera 1))
(assert (ObtenerJuncal 1))
(retract ?contador)
(assert (Contador (+ ?x 2))))

;Turno 4
(defrule Turno4
(declare (salience 30))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 4))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (eq 2 ?y))
=>
(assert (Pesca 1))
(assert (AmpliarHabitacion 1))
(retract ?contador)
(assert (Contador (+ ?x 2))))

;Turno5
(defrule Turno5Adobe
(declare (salience 50))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 5))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
=>
(assert (ObtenerAdobe 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno5AmplacionFamilia
(declare (salience 40))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 5))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?nombre "FamiliaPlanificada"))
=>
(assert (Planificada 1))
(retract ?contador)
(assert (Contador (+ ?x 1)))
)

(defrule Turno5Cocina
(declare (salience 30))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 5))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?nombre "Cocina"))
=>
(assert (Cocina 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

;Turno 6
(defrule Turno6Madera
(declare (salience 60))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 6))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
=>
(assert (ObtenerMadera 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno6Cocina
(declare (salience 50))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 6))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
?cocina <- (object (is-a AdquisicionMayor) (adquirido ?adquirido))
(test (neq ?adquirido True))
=>
(assert (Cocina 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno6Ampliacion
(declare (salience 40))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 6))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
(test (neq ?y 3))
=>
(assert (Planificada 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno6Jornalero
(declare (salience 30))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 6))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
(object (is-a Almacenado) (tipo ?tipo) (cantidad ?canti))
(test (eq ?tipo "Comida"))
(test (eq ?canti 0))
=>
(assert (Jornalero 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno6Sembrado
(declare (salience 30))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 6))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
(object (is-a EspacioCampo) (tipo ?tipo))
(test (neq ?tipo "Ninguno"))
=>
(assert (Labranza 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno6SemillaCereal
(declare (salience 20))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 6))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
=>
(assert (SemillasCereales 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

;Turno 7
;Sin acabar, falta hacer la regla de la accion
(defrule Turno7Ovejas
(declare (salience 70))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 7))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
=>
(assert (ObtenerOvejas 1)) ;Mirar cuando se acabe la regla
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno7Vallas
(declare (salience 60))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 7))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
(test (eq ?y 3))
=>
(assert (Vallas 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno7AmpliacionPlanificada
(declare (salience 60))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 7))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
(test (neq ?y 3))
=>
(assert (Planificada 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno7Labranza
(declare (salience 50))
(AccionDisponible (nombre ?nombre) (turno ?disponible))
(test (eq ?nombre "FamiliaPlanificada"))
(test (eq ?disponible 5))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 7))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
(test (eq ?y 3))
(object (is-a EspacioCampo) (tipo ?tipo))
(test (neq ?tipo "Ninguno"))
=>
(assert (Labranza 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno7Sembrar
(declare (salience 45))
(AccionDisponible (nombre ?nombre) (turno ?disponible))
(test (eq ?nombre "FamiliaPlanificada"))
(test (eq ?disponible 5))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 7))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
(test (eq ?y 3))
(object (is-a EspacioCampo) (tipo ?tipo))
(test (eq ?tipo "Ninguno"))
(object (is-a Almacenado) (tipo ?tipo) (cantidad ?canti))
(test (eq ?tipo "Cereal"))
(test (neq ?canti 0))
=>
(assert (Sembrar 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno7SemillaCereal
(declare (salience 40))
(AccionDisponible (nombre ?nombre) (turno ?disponible))
(test (eq ?nombre "FamiliaPlanificada"))
(test (eq ?disponible 5))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 7))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
(test (eq ?y 3))
(object (is-a EspacioCampo) (tipo ?tipo))
(test (eq ?tipo "Ninguno"))
=>
(assert (SemillasCereales 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno7Jornalero
(declare (salience 50))
(AccionDisponible (nombre ?nombre) (turno ?disponible))
(test (eq ?nombre "FamiliaPlanificada"))
(test (eq ?disponible 6))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 7))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
(test (eq ?y 3))
(object (is-a Almacenado) (tipo ?tipo) (cantidad ?canti))
(test (eq ?tipo "Comida"))
(test (eq ?canti 0))
=>
(assert (SemillasCereales 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno7Labranza2
(declare (salience 50))
(AccionDisponible (nombre ?nombre) (turno ?disponible))
(test (eq ?nombre "FamiliaPlanificada"))
(test (eq ?disponible 6))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 7))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
(test (eq ?y 3))
(object (is-a EspacioCampo) (tipo ?tipo))
(test (neq ?tipo "Ninguno"))
=>
(assert (Labranza 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno7SemillaCereal2
(declare (salience 50))
(AccionDisponible (nombre ?nombre) (turno ?disponible))
(test (eq ?nombre "FamiliaPlanificada"))
(test (eq ?disponible 6))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 7))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
(test (eq ?y 3))
(object (is-a EspacioCampo) (tipo ?tipo))
(test (eq ?tipo "Ninguno"))
=>
(assert (SemillasCereales 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

;Turno 8
(defrule Turno8SemillaCereal
(declare (salience 50))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 8))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
=>
(assert (SemillasCereales 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno8Labranza
(declare (salience 40))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 8))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
=>
(assert (Labranza 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno8Pesca
(declare (salience 30))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 8))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
=>
(assert (Pesca 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

;Turno 9
(defrule Turno9Madera
(declare (salience 50))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 9))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
=>
(assert (ObtenerMadera 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno9Hortaliza
(declare (salience 30))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 9))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
=>
(assert (SemillasHortalizas 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

;SIN ACABAR, esperar a realizar la accion
(defrule Turno9SembraryHornear
(declare (salience 30))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 9))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
=>
(assert (Sembrar 1))
(assert (Hornear 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

;Turno 10
(defrule Turno10Vallas
(declare (salience 50))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 10))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
=>
(assert (Vallas 1)) ;Insertamos dos hechos para que se ejecute la regla vallas 2 veces y asi crear dos espacios de animales nuevos
(assert (Vallas 2))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno10Labranza
(declare (salience 20))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 10))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
=>
(assert (Labranza 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno10SemillasCereales
(declare (salience 10))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 10))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
=>
(assert (SemillasCereales 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

;Turno 11
;Sin acabar, falta hacer la regla de la accion
(defrule Turno11Cerdos
(declare (salience 50))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 11))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
=>
(assert (ObtenerCerdos 1)) 
(retract ?contador)
(assert (Contador (+ ?x 1))))

;Sin acabar, falta hacer la regla de la accion
(defrule Turno11Sembraryhornear
(declare (salience 40))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 11))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
=>
(assert (Sembrar 1))
(assert (Hornear 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))


(defrule Turno11Vacas
(declare (salience 30))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 11))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
(object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq "MercadoBovino" ?nombre))
(test (not (< ?cantidad 2)))
=>
(assert (ObtenerVacas 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))


(defrule Turno11Hortaliza
(declare (salience 20))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 11))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
=>
(assert (SemillasHortalizas 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

;Turno 12
(defrule Turno12SemillasCereales
(declare (salience 40))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 12))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
=>
(assert (SemillasCereales 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno12SemillasHortalizas
(declare (salience 30))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 12))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
=>
(assert (SemillasHortalizas 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno12Precipitada
(declare (salience 20))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 12))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
(object (is-a Accion) (nombre ?nombre) (disponible ?disponible))
(test (eq "FamiliaPrecipitada" ?nombre))
(test (eq ?disponible True))
=>
(assert (Precipitada 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))


(defrule Turno12ArarySEmbrar
(declare (salience 20))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 12))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
=>
(assert (Labranza 1))
(assert (Sembrar 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

;Turno 13
(defrule Turno13SemillasCereales
(declare (salience 40))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 13))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
=>
(assert (SemillasCereales 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno13SemillasHortalizas
(declare (salience 30))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 13))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
=>
(assert (SemillasHortalizas 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno13Precipitada
(declare (salience 20))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 13))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
(test (eq ?y 4))
(object (is-a Accion) (nombre ?nombre) (disponible ?disponible))
(test (eq "FamiliaPrecipitada" ?nombre))
(test (eq ?disponible True))
=>
(assert (Precipitada 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))


(defrule Turno13SembraryHornear
(declare (salience 10))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 13))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
=>
(assert (Sembrar 1))
(assert (Hornear 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

;Turno 14
(defrule Turno14Ovejas
(declare (salience 30))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 14))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
=>
(assert (ObtenerOvejas 1)) 
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno14Vacas
(declare (salience 30))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 14))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
=>
(assert (ObtenerVacas 1)) ;
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno14Cerdos
(declare (salience 30))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 14))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
=>
(assert (ObtenerCerdos 1)) 
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno14Pesca
(declare (salience 30))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 14))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
=>
(assert (Pesca 1)) 
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno14ArarySembrar
(declare (salience 30))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 14))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (neq ?x ?y))
=>
(assert (Labranza 1))
(assert (Sembrar 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

;Regla para saber cuando acaba la fase tres
(defrule FinFase3
(not (and  (ObtenerMadera ?) (ObtenerAdobe ?) (ObtenerJuncal ?) (ObtenerPiedra ?) (Labranza ?)
(SemillasCereales ?) (SemillasHortalizas ?) (Jornalero ?) (Pesca ?) (AmpliarHabitacion ?) (Cocina ?) (Planificada ?) (Precipitada ?) (Vallas ?) (Hornear ?) (Sembrar ?) (Labranza ?) (ObtenerCerdos ?) (ObtenerVacas ?) (ObtenerOvejas ?) 
)) ;Poner todos los hechos que falten
?juego <- (InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y))
(test (eq ?x ?y))
=>
(modify ?juego (fase (+ ?fase 1)))
(retract ?contador)
(assert (Contador 0)))

;Regla para reestablecer los valores de las acciones para el siguiente turno
(defrule ValorUtilizado
(declare (salience 90))
?juego <- (InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?fase 4))
?accion <- (object (is-a Accion) (disponible ?disponible) (utilizado ?utilizado))
(test (eq ?utilizado True))
=>
(modify-instance ?accion (utilizado False)))

;Regla para cambiar de turno si no es turno de Cosecha y por lo tanto no hay fase 4
(defrule TurnodeNoCosecha
(declare (salience 70))
?habitantes <-(Habitantes (total ?tot) (nacidos ?nac))
(not (and (InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?fase 4))
(Cosecha ?x)
(test (eq ?turno ?x))))
?juego <- (InfoJuego (turno ?turno) (fase ?fase))
=>
(modify ?juego (turno (+ ?turno 1)) (fase 1))
(modify ?habitantes (total (+ ?tot ?nac)) (nacidos (- ?nac ?nac))))