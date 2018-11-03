;Clase para los espacios donde guardaremos animales
(defclass EspacioAnimales (is-a INITIAL-OBJECT) 
(slot tamanio
(type INTEGER)
(allowed-values 1 2)
(create-accessor read-write))
(slot establos
(type INTEGER)
(allowed-values 0 1 2)
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
(allowed-strings "Vaca" "Oveja" "Cerdo" "Ninguno")
(default "Ninguno")
(create-accessor read-write))
)

;Clase para guardar toda la informacion acerca de los campos
(defclass EspacioCampo (is-a INITIAL-OBJECT)
(slot tipo
(type STRING)
(allowed-strings "Cereal" "Hortaliza" "Ninguno")
(default "Ninguno")
(create-accessor read-write))
(slot cantidad 
(type INTEGER)
(default 0)
(create-accessor read-write))
)

;Clase para guardar toda la informacion acerca de las habitaciones
(defclass EspacioHabitacion (is-a INITIAL-OBJECT)
(slot tipo
(type STRING)
(allowed-strings "Piedra" "Madera" "Adobe")
(create-accessor read-write))
(slot habitante
(type SYMBOL)
(allowed-symbols True False)
(default False)
(create-accessor read-write)))

;Clase para representar la información con respecto a las adquisiciones
(defclass AdquisicionMayor (is-a INITIAL-OBJECT)
(slot tipo
(type STRING)
(allowed-strings "Hogar" "Cocina" "Pozo" "Cesteria" "Alfareria" "HornoPiedra" "Ebanisteria" "HornoAdobe"))
(slot puntos
(type INTEGER))
(slot adobe
(type INTEGER)
(default 0))
(slot juncal
(type INTEGER)
(default 0))
(slot madera
(type INTEGER)
(default 0))
(slot piedra
(type INTEGER)
(default 0))
(slot disponible
(type SYMBOL)
(allowed-symbols True False)
(default True)
(create-accessor read-write)))

;Clase para representar la información de las acciones, el atributo cantidad tendra valor 0 para aquellas acciones como por ejemplo reformar casa o reformar granja que no requieren tener un contador para contabilizar la acumulacion de los recursos correspondientes
(defclass Accion (is-a INITIAL-OBJECT)
(slot nombre
(type STRING))
(slot disponible
(type SYMBOL)
(allowed-symbols True False)
(create-accessor read-write))
(slot utilizado
(type SYMBOL)
(allowed-symbols True False)
(default False)
(create-accessor read-write))
(slot cantidad
(type INTEGER)
(default 0)
(create-accessor read-write))
(slot recolocar
(default 0)
(type INTEGER))
(slot recolocado
(type SYMBOL)
(allowed-symbols True False)
(default False)
(create-accessor read-write))
)

;Clase para contabilizar el inventario de materiales y de siembra
(defclass Almacenado (is-a INITIAL-OBJECT)
(slot tipo
(type STRING)
(allowed-strings "Madera" "Adobe" "Piedra" "Junco" "Comida" "Cereal" "Hortaliza"))
(slot cantidad 
(type INTEGER)
(default 0)
(create-accessor read-write))
)

;Plantilla para controlar el numero de ronda y fase en cada momento
(deftemplate InfoJuego
(slot turno
(type INTEGER))
(slot fase
(type INTEGER))
)

;Plantilla para saber cuando estaran disponibles las acciones
(deftemplate AccionDisponible
(slot nombre
(type STRING))
(slot turno
(type INTEGER))
)

;Plantilla para saber contabilizar los habitantes y los recien nacidos
(deftemplate Habitantes
(slot total
(type INTEGER))
(slot nacidos
(type INTEGER))
)
