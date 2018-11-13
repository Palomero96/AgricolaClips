;Regla para establecer la estrategia y el comando para escribir en un archivo
(defrule inicio
(declare (salience 100))
=>
(set-strategy random)
(dribble-on "salida-PruebaX.txt")
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
(printout t "Turno " ?y ", Fase " ?x crlf)
(printout t "Nueva AccionDisponible: " ?nombre crlf)
(printout t crlf)
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
(modify ?info (fase (+ ?x 1)))
(printout t "Turno " ?y ", Fase " ?x crlf)
(printout t "Fin de Fase de Reabastecimiento de Materias Primas" crlf)
(printout t crlf)
(printout t "Turno " ?y ", Fase " (+ ?x 1) crlf)
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
(modify-instance ?accion (cantidad 0))
(printout t "Realizamos la accion " ?nombreA " y obtenemos " ?cantidad " maderas."crlf)
)

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
(modify-instance ?accion (cantidad 0))
(printout t "Realizamos la accion " ?nombreA " y obtenemos " ?cantidad " adobes."crlf))

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
(modify-instance ?accion (cantidad 0))
(printout t "Realizamos la accion " ?nombreA " y obtenemos " ?cantidad " juncos."crlf))

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
(modify-instance ?accion (cantidad 0))
(printout t "Realizamos la accion " ?nombreA " y obtenemos " ?cantidad " piedras."crlf))

;Regla para la accion de labrar un campo
(defrule Labranza
?borrar <- (Labranza ?)
?espacios <- (Vacios ?x)
(test (neq ?x 0))
=>
(retract ?borrar)
(retract ?espacios)
(assert (Vacios (- ?x 1)))
(make-instance of EspacioCampo)
(printout t "Nuevo Campo Labrado"crlf))

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
(modify-instance ?accion (utilizado True) (cantidad 0))
(printout t "Realizamos la accion " ?nombre " y obtenemos " ?cantidad " cereal."crlf))

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
(modify-instance ?accion (cantidad 0))
(printout t "Realizamos la accion " ?nombre " y obtenemos " ?cantidad " hortaliza."crlf))

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
(modify-instance ?accion (utilizado True) (cantidad 0))
(printout t "Realizamos la accion " ?nombre " y obtenemos " ?cantidad " comidas."crlf))

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
(modify-instance ?accion (utilizado True) (cantidad 0))
(printout t "Realizamos la accion " ?nombre " y obtenemos " ?cantidad " comidas."crlf))

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
(make-instance of EspacioHabitacion)
(printout t "Gastamos 5 maderas y 2 juncos y creamos una nueva Habitacion."crlf))

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
(modify-instance ?cocina (adquirido True))
(printout t "Gastamos "?coste" adobes y adquirimos la Cocina." crlf))

;Regla la accion de ampliar familia planificada
(defrule AmpliacionPlanificada
?borrar <- (Planificada ?)
?habita <- (Habitantes (total ?total) (nacidos ?n))
?habitacion <- (object (is-a EspacioHabitacion) (habitantes ?h))
(test (eq ?h 0))
=>
(retract ?borrar)
(modify-instance ?habitacion (habitantes 1))
(modify ?habita (total (+ ?total 1)) (nacidos (+ ?n 1)))
(printout t "Ampliamos la familia de manera planificada "crlf))

;Regla para la accion de ampliar la familia de forma precipitada
(defrule AmpliacionPrecipitada
?borrar <- (Precipitada ?)
?habitacion <- (object (is-a EspacioHabitacion) (habitantes ?h))
?habita <- (Habitantes (total ?total) (nacidos ?n))
=>
(retract ?borrar)
(modify-instance ?habitacion (habitantes (+ ?h 1)))
(modify ?habita (total (+ ?total 1)) (nacidos (+ ?n 1)))
(printout t "Ampliamos la familia de manera precipitada"crlf))

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
(make-instance of EspacioAnimales (tamanio 1) (vallas 4) (habilitado True) (capacidad 2))
(printout t "Creamos un nuevo Espacio para animales"crlf))

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
(printout t "Obtenemos " ?cantidad " ovejas." crlf)
(assert (AnimalColocar (tipo "Oveja") (cantidad 2)))
(assert (AnimalVender (tipo "Oveja") (cantidad (- ?cantidad 2)))))

(defrule MercadoOvinoTurno7
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 7))
?borrar <- (ObtenerOvejas ?)
?accion <- (object (is-a Accion) (nombre ?nombre) (cantidad ?cantidad))
(test (eq ?nombre "MercadoOvino"))

=>
(retract ?borrar)
(printout t "Obtenemos " ?cantidad " ovejas." crlf)
(assert (AnimalVender (tipo "Oveja") (cantidad ?cantidad))))

;Regla para la accion de obtener cerdos
(defrule MercadoPorcino
?borrar <- (ObtenerCerdos ?)
?accion <- (object (is-a Accion) (nombre ?nombre) (cantidad ?cantidad))
(test (eq ?nombre "MercadoPorcino"))
=>
(modify-instance ?accion (cantidad 0))
(retract ?borrar)
(printout t "Obtenemos " ?cantidad " cerdos." crlf)
(assert (AnimalColocar (tipo "Cerdo") (cantidad 2)))
(assert (AnimalVender (tipo "Cerdo") (cantidad (- ?cantidad 2)))))

;Regla para la accion de obtener vacas
(defrule MercadoBovino
?borrar <- (ObtenerVacas ?)
?accion <- (object (is-a Accion) (nombre ?nombre) (cantidad ?cantidad))
(test (eq ?nombre "MercadoBovino"))
=>
(modify-instance ?accion (cantidad 0))
(retract ?borrar)
(printout t "Obtenemos " ?cantidad " vacas." crlf)
(assert (AnimalColocar (tipo "Vaca") (cantidad 2)))
(assert (AnimalVender(tipo "Vaca") (cantidad (- ?cantidad 2)))))

;Regla para colocarAnimales
(defrule ColocarAnimales
?espacioAnimales <-(object (is-a EspacioAnimales) (habilitado ?habilitado) (ocupacion ?ocupacion))
(test (eq ?habilitado True))
(test (eq ?ocupacion 0))
?animalColocar <- (AnimalColocar (tipo ?tipo) (cantidad ?cantidad))
(test (not (< ?cantidad 2)))
=>
(retract ?animalColocar)
(modify-instance ?espacioAnimales (habilitado False) (ocupacion 2) (animal ?tipo))
(printout t "Colocamos 2 " ?tipo " en un Espacio para animales."crlf))

;Regla para vender Ovejas
(defrule VenderOvejas
(declare (salience 10))
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
(modify-instance ?almacenado (cantidad (+ ?canti (* 2 ?cantidad))))
(printout t "Vendemos " ?cantidad " ovejas."crlf))

;Regla para vender cerdos
(defrule VenderCerdos
(declare (salience 10))
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
(modify-instance ?almacenado (cantidad (+ ?canti (* 3 ?cantidad))))
(printout t "Vendemos " ?cantidad " cerdos."crlf))

;Regla para vender Vacas
(defrule VenderVacas
(declare (salience 10))
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
(modify-instance ?almacenado (cantidad (+ ?canti (* 4 ?cantidad))))
(printout t "Vendemos " ?cantidad " vacas."crlf))


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
(modify-instance ?espacioCampo (tipo "Cereal") (cantidad 3))
(printout t "Sembranos un cereal en un campo."crlf))

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
(modify-instance ?almacenado (cantidad (+ ?canti (* 2 (- ?cantiCereal 1)))))
(printout t "Horneamos " (- ?cantiCereal 1) " cereales."crlf))

;Regla para el caso de que no podemos colocar los animales en un espacio
(defrule NoEspacioAnimales
(declare (salience 90))
?borrar <- (AnimalColocar (tipo ?tipo) (cantidad ?cantidad))
(not (and (object (is-a EspacioAnimales) (ocupacion ?ocupacion))
(test (eq 0 ?ocupacion))))
=>
(assert (AnimalVender (tipo ?tipo) (cantidad ?cantidad)))
(retract ?borrar)
(printout t "No hay espacio suficiente para guardarlos y vendemos " ?cantidad " " ?tipo "."crlf)
)

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
(declare (salience 20))
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
(declare (salience 30))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 13))
(test (eq ?fase 3))
?contador <- (Contador ?x)
(Habitantes (total ?y) (nacidos ?nac))
(test (neq ?x (- ?y ?nac)))
(test (<= ?y 4))
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



;Reglas de la fase de cosecha

(defrule Cosecha
(declare (salience 60))
(not (ComidaHecha ?))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?fase 4))
(Habitantes (total ?y) (nacidos ?z))
?almacenado <- (object (is-a Almacenado) (tipo ?tipo) (cantidad ?cantidad))
(test (eq ?tipo "Comida"))
(test (<= (+ (* 3 (- ?y ?z)) (* 1 ?z)) ?cantidad))
=>
(assert (ComidaHecha 1))
(assert (OvejaCosecha 1))
(assert (CerdoCosecha 1))
(assert (VacaCosecha 1))
(assert (CerealCosecha 1))
(modify-instance ?almacenado (cantidad (- ?cantidad (+ (* 3 (- ?y ?z)) (* 1 ?z)))))
(printout t crlf)
(printout t "Turno " ?turno ", Fase " ?fase crlf)
(printout t "Les damos de comer a los habitantes correctamente. Les damos " (+ (* 3 (- ?y ?z)) (* 1 ?z)) " comidas."crlf))

(defrule VenderHortalizasParaComer
(declare (salience 50))
(not (ComidaHecha ?))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?fase 4))
?almacenado <- (object (is-a Almacenado) (tipo ?tipo) (cantidad ?cantidad))
(test (eq ?tipo "Hortaliza"))
(test (< 0 ?cantidad))
?almacenadoComida <- (object (is-a Almacenado) (tipo ?tipoComida) (cantidad ?cantidadComida))
(test (eq ?tipoComida "Comida"))
=>
(modify-instance ?almacenado (cantidad (- ?cantidad 1)))
(modify-instance ?almacenadoComida (cantidad (* ?cantidadComida 3))))

(defrule VenderOvejasParaComer
(declare (salience 40))
(not (ComidaHecha ?))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?fase 4))
?espacioAnimales <- (object (is-a EspacioAnimales) (animal ?tipo))
(test (eq ?tipo "Oveja"))
=>
(assert (AnimalVender (tipo "Oveja") (cantidad 2)))
(modify-instance ?espacioAnimales (ocupacion 0) (animal "Ninguno"))
(printout t "Vendemos 2 ovejas para obtener mas comida." crlf))

(defrule VenderCerdosParaComer
(declare (salience 30))
(not (ComidaHecha ?))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?fase 4))
?espacioAnimales <- (object (is-a EspacioAnimales) (animal ?tipo))
(test (eq ?tipo "Cerdo"))
=>
(assert (AnimalVender (tipo "Cerdo") (cantidad 2)))
(modify-instance ?espacioAnimales (ocupacion 0) (animal "Ninguno"))
(printout t "Vendemos 2 cerdos para obtener mas comida." crlf))

(defrule VenderVacasParaComer
(declare (salience 20))
(not (ComidaHecha ?))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?fase 4))
?espacioAnimales <- (object (is-a EspacioAnimales) (animal ?tipo))
(test (eq ?tipo "Vaca"))
=>
(assert (AnimalVender (tipo "Vaca") (cantidad 2)))
(modify-instance ?espacioAnimales (ocupacion 0) (animal "Ninguno"))
(printout t "Vendemos 2 vacas para obtener mas comida." crlf)
)

(defrule RecogerOvejaCosecha
(declare (salience 50))
?borrar <- (OvejaCosecha ?x)
?espacioAnimales <- (object (is-a EspacioAnimales) (animal ?tipo))
(test (eq ?tipo "Oveja"))
=>
(retract ?borrar)
(assert (AnimalVender (tipo "Oveja") (cantidad 1)))
(printout t "Recogemos oveja de la cosecha." crlf))

(defrule NoOvejaCosecha
(declare (salience 30))
?borrar <- (OvejaCosecha ?x)
(not (and (object (is-a EspacioAnimales) (animal ?tipo))
(test (eq ?tipo "Oveja"))))
=>
(retract ?borrar))

(defrule RecogerCerdoCosecha
(declare (salience 50))
?borrar <- (CerdoCosecha ?x)
?espacioAnimales <- (object (is-a EspacioAnimales) (animal ?tipo))
(test (eq ?tipo "Cerdo"))
=>
(retract ?borrar)
(assert (AnimalVender (tipo "Cerdo") (cantidad 1)))
(printout t "Recogemos cerdo de la cosecha." crlf))

(defrule NoCerdoCosecha
(declare (salience 30))
?borrar <- (CerdoCosecha ?x)
(not (and (object (is-a EspacioAnimales) (animal ?tipo))
(test (eq ?tipo "Cerdo"))))
=>
(retract ?borrar))

(defrule RecogerVacaCosecha
(declare (salience 50))
?borrar <- (VacaCosecha ?x)
?espacioAnimales <- (object (is-a EspacioAnimales) (animal ?tipo))
(test (eq ?tipo "Vaca"))
=>
(retract ?borrar)
(assert (AnimalVender (tipo "Vaca") (cantidad 1)))
(printout t "Recogemos vaca de la cosecha." crlf))

(defrule NoVacaCosecha
(declare (salience 30))
?borrar <- (VacaCosecha ?x)
(not (and (object (is-a EspacioAnimales) (animal ?tipo))
(test (eq ?tipo "Vaca"))))
=>
(retract ?borrar))

(defrule RecogerCereal
(declare (salience 50))
(CerealCosecha ?x)
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?fase 4))
?espacioCampo <- (object (is-a EspacioCampo) (tipo ?tipo) (cantidad ?canti) (recogido ?recogido))
(test (< 0 ?canti))
(test (eq ?tipo "Cereal"))
(test (eq ?recogido False))
?almacenado <- (object (is-a Almacenado) (tipo ?tipoAlmacenado) (cantidad ?cantidadAlmacenada))
(test (eq ?tipoAlmacenado "Cereal"))
=>
(modify-instance ?almacenado (cantidad (+ ?cantidadAlmacenada 1)))
(modify-instance ?espacioCampo (cantidad (- ?canti 1)) (recogido True))
(printout t "Recogemos cereal de la cosecha." crlf))

(defrule NoCereal
(declare (salience 40))
?borrar <- (CerealCosecha ?x)
(not (and (object (is-a EspacioCampo) (tipo ?tipo) (cantidad ?canti) (recogido ?recogido))
(test (< 0 ?canti))
(test (eq ?tipo "Cereal"))
(test (eq ?recogido False))))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?fase 4))
=>
(retract ?borrar)
)

;Regla para saber cuando se acaba la cosecha si les hemos dado de comer
(defrule FinCosechaComida
?comida <- (ComidaHecha ?)
?habitantes <-(Habitantes (total ?tot) (nacidos ?nac))
?infoJuego <- (InfoJuego (turno ?turno) (fase ?fase))
(not (and (OvejaCosecha ?) (CerdoCosecha ?) (VacaCosecha ?) (CerealCosecha ?)))
(test (eq ?fase 4))
=>
(retract ?comida)
(modify ?infoJuego (turno (+ ?turno 1)) (fase 1))
(modify ?habitantes (nacidos (- ?nac ?nac)))
)
;Regla para saber cuando se acaba la cosecha si hemos fallado
(defrule FinCosechaSinComida
?comida <- (SinComida ?)
?habitantes <-(Habitantes (total ?tot) (nacidos ?nac))
?infoJuego <- (InfoJuego (turno ?turno) (fase ?fase))
(not (and (OvejaCosecha ?) (CerdoCosecha ?) (VacaCosecha ?) (CerealCosecha ?)))
(test (eq ?fase 4))
=>
(retract ?comida)
(modify ?infoJuego (turno (+ ?turno 1)) (fase 1))
(modify ?habitantes (nacidos (- ?nac ?nac)))
)

;Regla para el caso de no tener comida
(defrule SinComida
(not (ComidaHecha ?))
(not (SinComida ?))
?fallos <- (Fallos ?f)
?habitantes <-(Habitantes (total ?tot) (nacidos ?nac))
?almacenado <- (object (is-a Almacenado) (tipo ?tipoAlmacenado) (cantidad ?cantidadAlmacenada))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?fase 4))
(not (and (Habitantes (total ?y) (nacidos ?z)) (object (is-a Almacenado) (tipo ?tipo) (cantidad ?cantidad))
(test (eq ?tipo "Comida"))
(test (< (+ (* 3 (- ?tot ?nac)) (* 1 ?nac)) ?cantidadAlmacenada))))
=>
(assert (OvejaCosecha 1))
(assert (CerdoCosecha 1))
(assert (VacaCosecha 1))
(assert (CerealCosecha 1))
(assert (SinComida 1))
(retract ?fallos)
(assert (Fallos (+ (/ (- (+ (* 3 (- ?tot ?nac)) (* 1 ?nac)) ?cantidadAlmacenada) ?tot) ?f)))
(printout t crlf)
(printout t "Turno " ?turno ", Fase " ?fase crlf)
(printout t "Hemos fallado al darles de comer."crlf))

(defrule ValorRecogido
(declare (salience 50))
?espacioCampo <- (object (is-a EspacioCampo) (tipo ?tipo) (cantidad ?canti) (recogido ?recogido))
(test (eq ?tipo "Cereal"))
(test (eq ?recogido True))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?fase 1))
=>
(modify-instance ?espacioCampo (recogido False)))

;Regla para terminar la ejecucion del programa
(defrule Acabar
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?turno 15))
=>
(printout t crlf)
(printout t "Fin del juego." crlf)
(dribble-off)
(halt)
)