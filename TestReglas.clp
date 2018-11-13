;Regla para comprobar que se han recolocado todos
(defrule FinRecolocar2
(not (and (object (is-a Accion) (nombre ?nombreA) (disponible ?disponible) (cantidad ?cantidad) (recolocar ?recolocar) (recolocado ?recolocado) (acumulable ?acumulado))
(test (> ?recolocar 0))
(test (eq ?cantidad 0))
(test (eq ?disponible True))
(test (eq ?recolocado False))
(test (eq ?acumulado False))))
?info <- (InfoJuego (turno ?y) (fase ?x))
?a <- (object (is-a Accion) (nombre ?nombre) (disponible ?disponible) (cantidad ?cantidad) (recolocar ?recolocar) (recolocado ?recolocado))
(test (eq ?x 2))
=>
(modify ?info (fase (+ ?x 1))))