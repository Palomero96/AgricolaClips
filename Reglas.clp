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


