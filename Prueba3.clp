(deffacts Hechosiniciales
(AccionDisponible (nombre "MercadoOvino") (turno 1))		;periodo 1
(AccionDisponible (nombre "AdquisicionMayor") (turno 2))	;periodo 1
(AccionDisponible (nombre "Vallado") (turno 3))				;periodo 1
(AccionDisponible (nombre "Siembra") (turno 4))				;periodo 1
(AccionDisponible (nombre "ReformarCasa") (turno 5))		;periodo 2
(AccionDisponible (nombre "CanteraOriental") (turno 6))		;periodo 2
(AccionDisponible (nombre "FamiliaPlanificada") (turno 7))	;periodo 2
(AccionDisponible (nombre "MercadoPorcino") (turno 8))		;periodo 3
(AccionDisponible (nombre "SemillasHortalizas") (turno 9))	;periodo 3
(AccionDisponible (nombre "MercadoBovino") (turno 10))		;periodo 4
(AccionDisponible (nombre "CanteraOccidental") (turno 11))	;periodo 4
(AccionDisponible (nombre "Cultivo") (turno 12)	)			;periodo 5
(AccionDisponible (nombre "FamiliaPrecipitada") (turno 13))	;periodo 5
(AccionDisponible (nombre "ReformasGranja") (turno 14))		;periodo 6
(InfoJuego (turno 1) (fase 1))
(Vacios 13)
(Habitantes (total 2) (nacidos 0))
(Contador 0)
(Cosecha 4)
(Cosecha 7)
(Cosecha 9)
(Cosecha 11)
(Cosecha 13)
(Cosecha 14))


(definstances Acciones
(of Accion (nombre "AmpliacionGranja") (disponible True))
(of Accion (nombre "SemillasCereales") (disponible True) (cantidad 0) (recolocar 1) (acumulable False))
(of Accion (nombre "Bosque") (disponible True) (cantidad 0) (recolocar 2))
(of Accion (nombre "Labranza") (disponible True))
(of Accion (nombre "Mina") (disponible True) (cantidad 0) (recolocar 1))
(of Accion (nombre "Juncal") (disponible True) (cantidad 0) (recolocar 1))
(of Accion (nombre "Jornalero") (disponible True) (cantidad 0) (recolocar 2) (acumulable False))
(of Accion (nombre "Pesca") (disponible True) (cantidad 0) (recolocar 1))
(of Accion (nombre "AdquisicionMayor") (disponible False))
(of Accion (nombre "ReformarCasa") (disponible False))
(of Accion (nombre "MercadoPorcino") (disponible False) (cantidad 0) (recolocar 1))
(of Accion (nombre "MercadoBovino") (disponible False) (cantidad 0) (recolocar 1))
(of Accion (nombre "Cultivo") (disponible False))
(of Accion (nombre "ReformasGranja") (disponible False) (cantidad 0) (recolocar 1))
(of Accion (nombre "MercadoOvino") (disponible False) (cantidad 0) (recolocar 1))
(of Accion (nombre "FamiliaPlanificada") (disponible False))
(of Accion (nombre "SemillasHortalizas") (disponible False) (cantidad 0) (recolocar 1) (acumulable False))
(of Accion (nombre "CanteraOriental") (disponible False) (cantidad 0) (recolocar 1))
(of Accion (nombre "FamiliaPrecipitada") (disponible False))
(of Accion (nombre "Vallado") (disponible False))
(of Accion (nombre "CanteraOccidental") (disponible False) (cantidad 0) (recolocar 1))
(of Accion (nombre "Siembra") (disponible False))
)

(definstances AdquisicionesMayores
(of AdquisicionMayor (tipo "Cocina") (puntos 1) (adobe 4)))

(definstances RecursosIniciales
(of Almacenado (tipo "Madera"))
(of Almacenado (tipo "Adobe"))
(of Almacenado (tipo "Piedra"))
(of Almacenado (tipo "Junco"))
(of Almacenado (tipo "Comida"))
(of Almacenado (tipo "Cereal"))
(of Almacenado (tipo "Hortaliza")))


(definstances EspacioHabitacion
(of EspacioHabitacion (habitantes 1))
(of EspacioHabitacion (habitantes 1))
)
