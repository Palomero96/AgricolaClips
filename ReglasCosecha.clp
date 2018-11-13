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
(modify-instance ?almacenado (cantidad (- ?cantidad (+ (* 3 (- ?y ?z)) (* 1 ?z))))))

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
(modify-instance ?espacioAnimales (ocupacion 0) (animal "Ninguno")))

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
)

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
)

(defrule RecogerOvejaCosecha
(declare (salience 50))
?borrar <- (OvejaCosecha ?x)
?espacioAnimales <- (object (is-a EspacioAnimales) (animal ?tipo))
(test (eq ?tipo "Oveja"))
=>
(retract ?borrar)
(assert (AnimalVender (tipo "Oveja") (cantidad 1))))

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
(assert (AnimalVender (tipo "Cerdo") (cantidad 1))))

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
(assert (AnimalVender (tipo "Vaca") (cantidad 1))))

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
(modify-instance ?espacioCampo (cantidad (- ?canti 1)) (recogido True)))

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
)

(defrule ValorRecogido
(declare (salience 50))
?espacioCampo <- (object (is-a EspacioCampo) (tipo ?tipo) (cantidad ?canti) (recogido ?recogido))
(test (eq ?tipo "Cereal"))
(test (eq ?recogido True))
(InfoJuego (turno ?turno) (fase ?fase))
(test (eq ?fase 1))
=>
(modify-instance ?espacioCampo (recogido False)))