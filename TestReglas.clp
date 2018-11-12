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
)