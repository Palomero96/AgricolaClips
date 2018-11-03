;Regla para habilitar la nueva accion correspondiente en cada rnda
(defrule AccionesRonda
?info <- (InfoJuego (turno ?y) (fase ?x))
(test (eq ?x 1))
(AccionesDisponibles (nombre ?nombre) (turno ?turno))
(test (eq ?y ?turno))
?a <-(object (is-a Accion) (nombre ?nombreA))
(test (eq ?nombreA ?nombre))
=>
(modify-instance ?a (disponible True))
(modify ?info (fase (+ ?x 1)))
)


