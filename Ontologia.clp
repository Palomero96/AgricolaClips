(defclass EspacioAnimales (is-a INITIAL-OBJECT)
(slot establos
(type INTEGER)
(default 0)
(create-accessor read-write))
(slot tamaño
(type INTEGER)
(default 0)
(create-accessor read-write))
(slot vallas
(type INTEGER)
(default 0)
(create-accessor read-write))
(slot habilitado
(type SYMBOL)
(allowed-values True False)
(default False)
(create-accessor read-write))
(slot capacidad
(type INTEGER)
(default 0)
(create-accessor read-write))
(slot ocupacion
(type INTEGER)
(default 0)
(create-accessor read-write))
(slot animal
(type STRING)
(allowed-values Vaca Oveja Cerdo Ninguno)
(default Ninguno)
(create-accessor read-write))
)

(defclass EspacioCampo (is-a INITIAL-OBJECT)
(slot tipo
(type STRING)
(allowed-values Cereal Hortaliza Ninguno)
(default Ninguno)
(create-accessor read-write))
(slot cantidad 
(type INTEGER)
(default 0)
(create-accessor read-write))
)

(slot edad
(type INTEGER)
(range 1 100)
(default ?NONE))