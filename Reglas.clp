;Regla para establecer la estrategia y el comando para escribir en un archivo
(defrule inicio
(declare (salience 100))
=>
(set-strategy random)
;(dribble-on "dribble.txt")
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
(declare (salience 40))
(InfoJuego (turno ?y) (fase ?x))
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
(declare (salience 40))
(InfoJuego (turno ?y) (fase ?x))
(test (eq ?x 2))
?a <-(object (is-a Accion) (nombre ?nombreA) (disponible ?disponible) (cantidad ?cantidad) (recolocar ?recolocar) (recolocado ?recolocado) (acumulable ?acumulado))
(test (> ?recolocar 0))
(test (eq ?cantidad 0))
(test (eq ?disponible True))
(test (eq ?recolocado False))
(test (eq ?acumulado False))
=>
(modify-instance ?a (cantidad ?recolocar) (recolocado True)))

;Regla el final de FinRecolocar. Nota: Sabemos que lo podemos hacer con un (not (and )) pero no hemos sido capaces de que funcione en determinados casos, por eso lo hemos puesto con salience
(defrule FinRecolocar
?info <- (InfoJuego (turno ?y) (fase ?x))
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
?accion <- (object (is-a Accion) (nombre ?nombreA) (cantidad ?cantidad))
(test (eq ?nombreA "Bosque"))
=>
(retract ?borrar)
(modify-instance ?almacenado (cantidad (+ ?canti ?cantidad)))
(modify-instance ?accion (cantidad 0)))

;Regla para la accion de recoger adobe
(defrule ObtenerAdobe
?borrar <- (ObtenerAdobe ?)
?almacenado <- (object (is-a Almacenado) (tipo ?tipo) (cantidad ?canti))
(test (eq ?tipo "Adobe"))
?accion <- (object (is-a Accion) (nombre ?nombreA) (cantidad ?cantidad))
(test (eq ?nombreA "Mina"))
=>
(retract ?borrar)
(modify-instance ?almacenado (cantidad (+ ?canti ?cantidad)))
(modify-instance ?accion (cantidad 0)))

;Regla para la accion de recoger juncal
(defrule ObtenerJuncal
?borrar <- (ObtenerJuncal ?)
?almacenado <- (object (is-a Almacenado) (tipo ?tipo) (cantidad ?canti))
(test (eq ?tipo "Junco"))
?accion <- (object (is-a Accion) (nombre ?nombreA) (cantidad ?cantidad))
(test (eq ?nombreA "Juncal"))
=>
(retract ?borrar)
(modify-instance ?almacenado (cantidad (+ ?canti ?cantidad)))
(modify-instance ?accion (cantidad 0)))

;Regla para la accion de recoger piedra de una de las canteras (no la usamos)
;Como no la usamos solo vamos a crear una de las dos reglas
(defrule ObtenerPiedra
?borrar <- (ObtenerPiedra ?)
?almacenado <- (object (is-a Almacenado) (tipo ?tipo) (cantidad ?canti))
(test (eq ?tipo Piedra))
?accion <- (object (is-a Accion) (nombre ?nombreA) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?nombreA "CanteraOriental"))
=>
(retract ?borrar)
(modify-instance ?almacenado (cantidad (+ ?canti ?cantidad)))
(modify-instance ?accion (cantidad 0)))

;Regla para la accion de labrar un campo
(defrule Labranza
?borrar <- (Labranza ?)
?espacios <- (Vacios ?x)
(test (neq ?x 0))
=>
(retract ?borrar)
(retract ?espacios)
(assert (Vacios (- ?x 1)))
(make-instance of EspacioCampo))

;Regla para recoger cereales
(defrule SemillasCereales
?borrar <- (SemillasCereales ?)
?almacenado <- (object (is-a Almacenado) (tipo ?tipo) (cantidad ?canti))
(test (eq ?tipo "Cereal"))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
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
(test (eq ?nombre "SemillasHortalizas"))
=>
(retract ?borrar)
(modify-instance ?almacenado (cantidad (+ ?canti ?cantidad)))
(modify-instance ?accion (cantidad 0)))

;Regla para recoger la comida del Jornalero
(defrule Jornalero
?borrar <- (Jornalero ?)
?almacenado <- (object (is-a Almacenado) (tipo ?tipo) (cantidad ?canti))
(test (eq ?tipo "Comida"))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
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
(test (eq ?nombre "Pesca"))
=>
(retract ?borrar)
(modify-instance ?almacenado (cantidad (+ ?canti ?cantidad)))
(modify-instance ?accion (utilizado True) (cantidad 0)))

;Regla para ampliar el numero de habitaciones en una
(defrule AmpliarHabitacion
?borrar <- (AmpliarHabitacion ?)
?madera <- (object (is-a Almacenado) (tipo ?tipo) (cantidad ?cantim))
(test (eq ?tipo "Madera"))
?juncal <- (object (is-a Almacenado) (tipo ?tipob) (cantidad ?cantij))
(test (eq ?tipob "Junco"))
(test (>= ?cantim 5))
(test (>= ?cantij 2))
?espacios <- (Vacios ?x)
(test (neq ?x 0))
=>
(modify-instance ?madera (cantidad (- ?cantim 5)))
(modify-instance ?juncal (cantidad (- ?cantij 2)))
(retract ?espacios)
(retract ?borrar)
(assert (Vacios (- ?x 1)))
(make-instance of EspacioHabitacion))

;Regla para Comprar la Cocina
(defrule Cocina
?borrar <- (Cocina ?)
?adobe <- (object (is-a Almacenado) (tipo ?tipo) (cantidad ?canti))
(test (eq ?tipo "Adobe"))
?cocina <- (object (is-a AdquisicionMayor) (adquirido ?adquirido) (adobe ?coste))
(test (not (< ?canti ?coste)))
(test (eq False ?adquirido))
=>
(retract ?borrar)
(modify-instance ?adobe (cantidad (- ?canti ?coste)))
(modify-instance ?cocina (adquirido True)))

;Regla la accion de ampliar familia planificada
(defrule AmpliacionPlanificada
?borrar <- (Planificada ?)
?habita <- (Habitantes (total ?total) (nacidos ?n))
?habitacion <- (object (is-a EspacioHabitacion) (habitantes ?h))
(test (eq ?h 0))
=>
(retract ?borrar)
(modify-instance ?habitacion (habitantes 1))
(modify ?habita (total (+ ?total 1)) (nacidos (+ ?n 1))))

;Regla para la accion de ampliar la familia de forma precipitada
(defrule AmpliacionPrecipitada
?borrar <- (Precipitada ?)
?habitacion <- (object (is-a EspacioHabitacion) (habitantes ?h))
?habita <- (Habitantes (total ?total) (nacidos ?n))
=>
(retract ?borrar)
(modify-instance ?habitacion (habitantes (+ ?h 1)))
(modify ?habita (total (+ ?total 1)) (nacidos (+ ?n 1))))

;Regla para colocar vallas (vamos a cerrar espacios de un tamaño maximo de 1 y que se usen 4 vallas que es lo necesario para cerrar)
(defrule Vallas
?borrar <- (Vallas ?)
?madera <- (object (is-a Almacenado) (tipo ?tipo) (cantidad ?cantim))
(test (eq ?tipo "Madera"))
(test (not (< ?cantim 4)))
?espacios <- (Vacios ?x)
(test (neq ?x 0))
=>
(retract ?espacios)
(retract ?borrar)
(assert (Vacios (- ?x 1)))
(modify-instance ?madera (cantidad (- ?cantim 4)))
(make-instance of EspacioAnimales (tamanio 1) (vallas 4) (habilitado True) (capacidad 2)))

;Regla para la accion de obtener ovejas
(defrule MercadoOvino
(InfoJuego (turno ?turno) (fase ?fase))
(test (neq ?turno 7))
?borrar <- (ObtenerOvejas ?)
?accion <- (object (is-a Accion) (nombre ?nombre) (cantidad ?cantidad))
(test (eq ?nombre "MercadoOvino"))
=>
(modify-instance ?accion (cantidad 0))
(retract ?borrar)
(assert (AnimalColocar (tipo "Oveja") (cantidad 2)))
(assert (AnimalVender (tipo "Oveja") (cantidad (- ?cantidad 2))))
(assert (ColocarAnimal 1))
(assert (VenderAnimal 1)))

(defrule MercadoOvinoTurno7
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 7))
?borrar <- (ObtenerOvejas ?)
?accion <- (object (is-a Accion) (nombre ?nombre) (cantidad ?cantidad))
(test (eq ?nombre "MercadoOvino"))

=>
(retract ?borrar)
(assert (AnimalVender (tipo "Oveja") (cantidad ?cantidad)))
(assert (VenderAnimal 1)))

;Regla para la accion de obtener cerdos
(defrule MercadoPorcino
?borrar <- (ObtenerCerdos ?)
?accion <- (object (is-a Accion) (nombre ?nombre) (cantidad ?cantidad))
(test (eq ?nombre "MercadoPorcino"))
=>
(modify-instance ?accion (cantidad 0))
(retract ?borrar)
(assert (AnimalColocar (tipo "Cerdo") (cantidad 2)))
(assert (AnimalVender (tipo "Cerdo") (cantidad (- ?cantidad 2))))
(assert (ColocarAnimal 1))
(assert (VenderAnimal 1)))

;Regla para la accion de obtener vacas
(defrule MercadoBovino
?borrar <- (ObtenerVacas ?)
?accion <- (object (is-a Accion) (nombre ?nombre) (cantidad ?cantidad))
(test (eq ?nombre "MercadoBovino"))
=>
(modify-instance ?accion (cantidad 0))
(retract ?borrar)
(assert (AnimalColocar (tipo "Vaca") (cantidad 2)))
(assert (AnimalVender(tipo "Vaca") (cantidad (- ?cantidad 2))))
(assert (ColocarAnimal 1))
(assert (VenderAnimal 1)))

;Regla para colocarAnimales
(defrule ColocarAnimales
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
(declare (salience 10))
?borrar <- (VenderAnimal ?)
?cocina <- (object (is-a AdquisicionMayor) (tipo ?tipoCocina) (adquirido ?adquirido))
(test (eq ?tipoCocina "Cocina"))
(test (eq ?adquirido True))
?animalVender<- (AnimalVender (tipo ?tipo) (cantidad ?cantidad))
(test (eq ?tipo "Oveja"))
(test (>= ?cantidad 1))
?almacenado <-(object (is-a Almacenado) (tipo ?tipoAlmacenado) (cantidad ?canti))
(test (eq ?tipoAlmacenado "Comida"))
=>
(retract ?animalVender)
(retract ?borrar)
(modify-instance ?almacenado (cantidad (+ ?canti (* 2 ?cantidad)))))

;Regla para venderAnimales
(defrule VenderCerdos
(declare (salience 10))
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
(declare (salience 10))
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
?almacenado <-(object (is-a Almacenado) (tipo ?tipoAlmacenado) (cantidad ?canti))
(test (eq ?tipoAlmacenado "Cereal"))
(test (not (< ?canti 1)))
=>
(modify-instance ?almacenado (cantidad (- ?canti 1)))
(retract ?borrar)
(modify-instance ?espacioCampo (tipo "Cereal") (cantidad 3)))

;Regla para hornear
(defrule Hornear
?borrar <- (Hornear ?)
?cocina <- (object (is-a AdquisicionMayor) (tipo ?tipoCocina) (adquirido ?adquirido))
(test (eq ?tipoCocina "Cocina"))
(test (eq ?adquirido True))
?almacenado <-(object (is-a Almacenado) (tipo ?tipoAlmacenado) (cantidad ?canti))
(test (eq ?tipoAlmacenado "Comida"))
?almacenadoCereal <-(object (is-a Almacenado) (tipo ?tipoCereal) (cantidad ?cantiCereal))
(test (eq ?tipoCereal "Cereal"))
=>
(retract ?borrar)
(modify-instance ?almacenadoCereal (cantidad 1))
(modify-instance ?almacenado (cantidad (+ ?canti (* 2 (- ?cantiCereal 1))))))

;Reglas auxiliares para decidir que hacer en cada turno
;Turno 1
(defrule Turno1
(declare (salience 30))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 1))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "Jornalero"))
?accionB <- (object (is-a Accion) (nombre ?nombreB) (disponible ?disponibleB) (utilizado ?utilizadoB))
(test (eq ?disponibleB True))
(test (eq ?utilizadoB False))
(test (eq ?nombreB "Labranza"))
=>
(assert (Jornalero 1))
(assert (Labranza 1))
(retract ?contador)
(modify-instance ?accion (utilizado True))
(modify-instance ?accionB (utilizado True))
(assert (Contador (+ ?x 2))))

;Turno 2
(defrule Turno2Cereal
(declare (salience 30))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 2))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accionB <- (object (is-a Accion) (nombre ?nombreB) (disponible ?disponibleB) (utilizado ?utilizadoB))
(test (eq ?disponibleB True))
(test (eq ?utilizadoB False))
(test (eq ?nombreB "SemillasCereales"))
=>
(assert (SemillasCereales 1))
(modify-instance ?accionB (utilizado True))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno2Siembra
(declare (salience 20))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 2))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "Siembra"))
=>
(modify-instance ?accion (utilizado True))
(assert (Sembrar 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno2Jornalero
(declare (salience 10))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 2))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "Jornalero"))
=>
(modify-instance ?accion (utilizado True))
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
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "Bosque"))
?accionb <- (object (is-a Accion) (nombre ?nombreb) (disponible ?disponibleb) (utilizado ?utilizadob))
(test (eq ?disponibleb True))
(test (eq ?utilizadob False))
(test (eq ?nombreb "Juncal"))
=>
(modify-instance ?accion (utilizado True))
(modify-instance ?accionb (utilizado True))
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
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "Pesca"))
?accionb <- (object (is-a Accion) (nombre ?nombreb) (disponible ?disponibleb) (utilizado ?utilizadob))
(test (eq ?disponibleb True))
(test (eq ?utilizadob False))
(test (eq ?nombreb "AmpliacionGranja"))
=>
(modify-instance ?accion (utilizado True))
(modify-instance ?accionb (utilizado True))
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
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "Mina"))
=>
(assert (ObtenerAdobe 1))
(modify-instance ?accion (utilizado True))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno5AmplacionFamilia
(declare (salience 40))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 5))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "FamiliaPlanificada"))
(object (is-a EspacioHabitacion) (habitantes ?h))
(test (eq ?h 0))
=>
(modify-instance ?accion (utilizado True))
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
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "AdquisicionMayor"))
=>
(assert (Cocina 1))
(modify-instance ?accion (utilizado True))
(retract ?contador)
(assert (Contador (+ ?x 1))))

;Turno 6
(defrule Turno6Madera
(declare (salience 60))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 6))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "Bosque"))
=>
(assert (ObtenerMadera 1))
(modify-instance ?accion (utilizado True))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno6Cocina
(declare (salience 50))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 6))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?cocina <- (object (is-a AdquisicionMayor) (adquirido ?adquirido))
(test (neq ?adquirido True))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "AdquisicionMayor"))
=>
(assert (Cocina 1))
(modify-instance ?accion (utilizado True))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno6Ampliacion
(declare (salience 40))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 6))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
(test (neq ?y 3))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "FamiliaPlanificada"))
(object (is-a EspacioHabitacion) (habitantes ?h))
(test (eq ?h 0))
=>
(assert (Planificada 1))
(modify-instance ?accion (utilizado True))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno6Jornalero
(declare (salience 30))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 6))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
(object (is-a Almacenado) (tipo ?tipo) (cantidad ?canti))
(test (eq ?tipo "Comida"))
(test (eq ?canti 0))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "Jornalero"))
=>
(assert (Jornalero 1))
(modify-instance ?accion (utilizado True))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno6Sembrado
(declare (salience 35))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 6))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
(object (is-a EspacioCampo) (tipo ?tipo))
(test (neq ?tipo "Ninguno"))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "Labranza"))
=>
(assert (Labranza 1))
(modify-instance ?accion (utilizado True))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno6SemillaCereal
(declare (salience 20))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 6))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "SemillasCereales"))
=>
(assert (SemillasCereales 1))
(modify-instance ?accion (utilizado True))
(retract ?contador)
(assert (Contador (+ ?x 1))))

;Turno 7
(defrule Turno7Ovejas
(declare (salience 70))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 7))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "MercadoOvino"))
=>
(assert (ObtenerOvejas 1))
(modify-instance ?accion (utilizado True))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno7Vallas
(declare (salience 60))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 7))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
(test (eq ?y 3))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "Vallado"))
=>
(modify-instance ?accion (utilizado True))
(assert (Vallas 1))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno7AmpliacionPlanificada
(declare (salience 65))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 7))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
(test (neq ?y 3))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "FamiliaPlanificada"))
(object (is-a EspacioHabitacion) (habitantes ?h))
(test (eq ?h 0))
=>
(modify-instance ?accion (utilizado True))
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
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
(test (eq ?y 3))
(not (and (object (is-a EspacioCampo) (tipo ?tipo))
(test (eq ?tipo "Ninguno"))))
?accion <- (object (is-a Accion) (nombre ?nombreb) (disponible ?disponibleb) (utilizado ?utilizadob) (cantidad ?cantidad))
(test (eq ?disponibleb True))
(test (eq ?utilizadob False))
(test (eq ?nombre "Labranza"))
=>
(assert (Labranza 1))
(modify-instance ?accion (utilizado True))
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
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
(test (eq ?y 3))
(object (is-a EspacioCampo) (tipo ?tipo))
(test (eq ?tipo "Ninguno"))
(object (is-a Almacenado) (tipo ?tipo) (cantidad ?canti))
(test (eq ?tipo "Cereal"))
(test (neq ?canti 0))
?accion <- (object (is-a Accion) (nombre ?nombreb) (disponible ?disponibleb) (utilizado ?utilizadob) (cantidad ?cantidad))
(test (eq ?disponibleb True))
(test (eq ?utilizadob False))
(test (eq ?nombreb "Siembra"))
=>
(assert (Sembrar 1))
(modify-instance ?accion (utilizado True))
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
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
(test (eq ?y 3))
(object (is-a EspacioCampo) (tipo ?tipo))
(test (eq ?tipo "Ninguno"))
?accion <- (object (is-a Accion) (nombre ?nombreb) (disponible ?disponibleb) (utilizado ?utilizadob) (cantidad ?cantidad))
(test (eq ?disponibleb True))
(test (eq ?utilizadob False))
(test (eq ?nombreb "SemillasCereales"))
=>
(assert (SemillasCereales 1))
(modify-instance ?accion (utilizado True))
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
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
(test (eq ?y 3))
(object (is-a Almacenado) (tipo ?tipo) (cantidad ?canti))
(test (eq ?tipo "Comida"))
(test (eq ?canti 0))
?accion <- (object (is-a Accion) (nombre ?nombreb) (disponible ?disponibleb) (utilizado ?utilizadob) (cantidad ?cantidad))
(test (eq ?disponibleb True))
(test (eq ?utilizadob False))
(test (eq ?nombreb "Jornalero"))
=>
(assert (Jornalero 1))
(modify-instance ?accion (utilizado True))
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
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
(test (eq ?y 3))
(object (is-a EspacioCampo) (tipo ?tipo))
(test (neq ?tipo "Ninguno"))
?accion <- (object (is-a Accion) (nombre ?nombreb) (disponible ?disponibleb) (utilizado ?utilizadob) (cantidad ?cantidad))
(test (eq ?disponibleb True))
(test (eq ?utilizadob False))
(test (eq ?nombreb "Labranza"))
=>
(assert (Labranza 1))
(modify-instance ?accion (utilizado True))
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
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
(test (eq ?y 3))
(object (is-a EspacioCampo) (tipo ?tipo))
(test (eq ?tipo "Ninguno"))
?accion <- (object (is-a Accion) (nombre ?nombreb) (disponible ?disponibleb) (utilizado ?utilizadob) (cantidad ?cantidad))
(test (eq ?disponibleb True))
(test (eq ?utilizadob False))
(test (eq ?nombre "SemillasCereales"))
=>
(assert (SemillasCereales 1))
(modify-instance ?accion (utilizado True))
(retract ?contador)
(assert (Contador (+ ?x 1))))

;Turno 8
(defrule Turno8SemillaCereal
(declare (salience 50))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 8))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "SemillasCereales"))
=>
(assert (SemillasCereales 1))
(modify-instance ?accion (utilizado True))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno8Labranza
(declare (salience 40))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 8))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "Labranza"))
=>
(assert (Labranza 1))
(modify-instance ?accion (utilizado True))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno8Pesca
(declare (salience 30))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 8))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "Pesca"))
=>
(assert (Pesca 1))
(modify-instance ?accion (utilizado True))
(retract ?contador)
(assert (Contador (+ ?x 1))))

;Turno 9
(defrule Turno9Madera
(declare (salience 50))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 9))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "Bosque"))
=>
(assert (ObtenerMadera 1))
(modify-instance ?accion (utilizado True))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno9Hortaliza
(declare (salience 30))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 9))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "SemillasHortalizas"))
=>
(assert (SemillasHortalizas 1))
(modify-instance ?accion (utilizado True))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno9SembraryHornear
(declare (salience 30))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 9))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "Siembra"))
=>
(assert (Sembrar 1))
(assert (Hornear 1))
(modify-instance ?accion (utilizado True))
(retract ?contador)
(assert (Contador (+ ?x 1))))

;Turno 10
(defrule Turno10Vallas
(declare (salience 50))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 10))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "Vallado"))
=>
(assert (Vallas 1)) 
(assert (Vallas 2))
(modify-instance ?accion (utilizado True))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno10Labranza
(declare (salience 20))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 10))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "Labranza"))
=>
(assert (Labranza 1))
(modify-instance ?accion (utilizado True))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno10SemillasCereales
(declare (salience 10))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 10))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "SemillasCereales"))
=>
(assert (SemillasCereales 1))
(modify-instance ?accion (utilizado True))
(retract ?contador)
(assert (Contador (+ ?x 1))))

;Turno 11
(defrule Turno11Cerdos
(declare (salience 50))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 11))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "MercadoPorcino"))
=>
(assert (ObtenerCerdos 1)) 
(modify-instance ?accion (utilizado True))
(retract ?contador)
(assert (Contador (+ ?x 1))))

;Sin acabar, falta hacer la regla de la accion
(defrule Turno11Sembraryhornear
(declare (salience 40))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 11))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "Siembra"))
=>
(assert (Sembrar 1))
(assert (Hornear 1))
(modify-instance ?accion (utilizado True))
(retract ?contador)
(assert (Contador (+ ?x 1))))


(defrule Turno11Vacas
(declare (salience 30))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 11))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq "MercadoBovino" ?nombre))
(test (not (< ?cantidad 2)))
(test (eq ?disponible True))
(test (eq ?utilizado False))
=>
(assert (ObtenerVacas 1))
(modify-instance ?accion (utilizado True))
(retract ?contador)
(assert (Contador (+ ?x 1))))


(defrule Turno11Hortaliza
(declare (salience 20))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 11))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "SemillasHortalizas"))
=>
(assert (SemillasHortalizas 1))
(modify-instance ?accion (utilizado True))
(retract ?contador)
(assert (Contador (+ ?x 1))))

;Turno 12
(defrule Turno12SemillasCereales
(declare (salience 40))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 12))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "SemillasCereales"))
=>
(assert (SemillasCereales 1))
(modify-instance ?accion (utilizado True))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno12SemillasHortalizas
(declare (salience 30))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 12))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado) (cantidad ?cantidad))
(test (eq ?disponible True))
(test (eq ?utilizado False))
(test (eq ?nombre "SemillasHortalizas"))
=>
(assert (SemillasHortalizas 1))
(modify-instance ?accion (utilizado True))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno12Precipitada
(declare (salience 20))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 12))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado))
(test (eq "FamiliaPrecipitada" ?nombre))
(test (eq ?disponible True))
(test (eq ?utilizado False))
=>
(assert (Precipitada 1))
(modify-instance ?accion (utilizado True))
(retract ?contador)
(assert (Contador (+ ?x 1))))


(defrule Turno12ArarySEmbrar
(declare (salience 20))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 12))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado))
(test (eq "Cultivo" ?nombre))
(test (eq ?disponible True))
(test (eq ?utilizado False))
=>
(assert (Labranza 1))
(assert (Sembrar 1))
(modify-instance ?accion (utilizado True))
(retract ?contador)
(assert (Contador (+ ?x 1))))

;Turno 13
(defrule Turno13SemillasCereales
(declare (salience 40))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 13))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado))
(test (eq "SemillasCereales" ?nombre))
(test (eq ?disponible True))
(test (eq ?utilizado False))
=>
(assert (SemillasCereales 1))
(modify-instance ?accion (utilizado True))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno13SemillasHortalizas
(declare (salience 30))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 13))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado))
(test (eq "SemillasHortalizas" ?nombre))
(test (eq ?disponible True))
(test (eq ?utilizado False))
=>
(assert (SemillasHortalizas 1))
(modify-instance ?accion (utilizado True))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno13Precipitada
(declare (salience 20))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 13))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
(test (eq ?y 4))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado))
(test (eq "FamiliaPrecipitada" ?nombre))
(test (eq ?disponible True))
(test (eq ?utilizado False))
=>
(assert (Precipitada 1))
(modify-instance ?accion (utilizado True))
(retract ?contador)
(assert (Contador (+ ?x 1))))


(defrule Turno13SembraryHornear
(declare (salience 10))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 13))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado))
(test (eq "Siembra" ?nombre))
(test (eq ?disponible True))
(test (eq ?utilizado False))
=>
(assert (Sembrar 1))
(assert (Hornear 1))
(modify-instance ?accion (utilizado True))
(retract ?contador)
(assert (Contador (+ ?x 1))))

;Turno 14
(defrule Turno14Ovejas
(declare (salience 30))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 14))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado))
(test (eq "MercadoOvino" ?nombre))
(test (eq ?disponible True))
(test (eq ?utilizado False))
=>
(assert (ObtenerOvejas 1))
(modify-instance ?accion (utilizado True)) 
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno14Vacas
(declare (salience 30))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 14))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado))
(test (eq "MercadoBovino" ?nombre))
(test (eq ?disponible True))
(test (eq ?utilizado False))
=>
(assert (ObtenerVacas 1))
(modify-instance ?accion (utilizado True))
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno14Cerdos
(declare (salience 30))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 14))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado))
(test (eq "MercadoPorcino" ?nombre))
(test (eq ?disponible True))
(test (eq ?utilizado False))
=>
(assert (ObtenerCerdos 1))
(modify-instance ?accion (utilizado True)) 
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno14Pesca
(declare (salience 30))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 14))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado))
(test (eq "Pesca" ?nombre))
(test (eq ?disponible True))
(test (eq ?utilizado False))
=>
(assert (Pesca 1))
(modify-instance ?accion (utilizado True)) 
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule Turno14ArarySembrar
(declare (salience 30))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 14))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado))
(test (eq "Cultivo" ?nombre))
(test (eq ?disponible True))
(test (eq ?utilizado False))
=>
(assert (Labranza 1))
(assert (Sembrar 1))
(modify-instance ?accion (utilizado True))
(retract ?contador)
(assert (Contador (+ ?x 1))))

;Reglas de relleno por si son necesarias
(defrule JornaleroExtra
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado))
(test (eq "Jornalero" ?nombre))
(test (eq ?disponible True))
(test (eq ?utilizado False))
=>
(assert (Jornalero 1)) 
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule HortalizasExtra
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado))
(test (eq "SemillasHortalizas" ?nombre))
(test (eq ?disponible True))
(test (eq ?utilizado False))
=>
(assert (SemillasHortalizas 1)) 
(retract ?contador)
(assert (Contador (+ ?x 1))))

(defrule SemillasCerealesExtra
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
?accion <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (utilizado ?utilizado))
(test (eq "SemillasCereales" ?nombre))
(test (eq ?disponible True))
(test (eq ?utilizado False))
=>
(assert (SemillasCereales 1)) 
(retract ?contador)
(assert (Contador (+ ?x 1))))

;Regla para saber cuando acaba la fase tres
(defrule FinFase3
(not (Jornalero ?))
(not (Labranza ?))
(not (ObtenerMadera ?))
(not (ObtenerAdobe ?))
(not (ObtenerJuncal ?))
(not (ObtenerPiedra ?))
(not (SemillasCereales ?))
(not (SemillasHortalizas ?))
(not (Pesca ?))
(not (AmpliarHabitacion ?))
(not (Cocina ?))
(not (Planificada ?))
(not (Vallas ?))
(not (Sembrar ?))
(not (Hornear ?))
(not (ObtenerCerdos ?))
(not (ObtenerVacas ?))
(not (ObtenerOvejas ?))
?juego <- (InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (eq ?x (- ?y ?nac)))
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
(Cosecha ?x)
(test (eq ?turno ?x))))
?juego <- (InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?fase 4))
=>
(modify ?juego (turno (+ ?turno 1)) (fase 1))
(modify ?habitantes (nacidos (- ?nac ?nac))))

;Regla para terminar la ejecucion del programa
(defrule Acabar
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 15))
=>
(dribble-off)
(halt)
)