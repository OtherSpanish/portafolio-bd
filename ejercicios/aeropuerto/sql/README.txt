=====================================================================
 Aeropuerto - Scripts de implementacion de la base de datos
 Bases de Datos 1 - Universidad El Bosque
 Juan Carlos Morales Melo
=====================================================================

1. DESCRIPCION
---------------------------------------------------------------------
Esta carpeta tiene los scripts que pasan el modelo relacional del
ejercicio Aeropuerto al modelo fisico en MySQL.

  RDBMS ............ MySQL 8.0
  Base de datos .... aeropuerto
  Codificacion ..... utf8mb4 / utf8mb4_0900_ai_ci
  Tablas ........... 9 (motor InnoDB)
  Registros ........ 64 (datos de prueba)

2. CONTENIDO
---------------------------------------------------------------------
  Archivo                          Tipo        Que hace
  -------------------------------- ----------- ------------------------------------
  00-eliminarobjetos.sql           Varios      Borra vistas y tablas (reinstalar)
  01-creacionobjetos.sql           Creacion    Crea la BD y las 9 tablas con PK,
                                               FK, UNIQUE y ENUM
  02-insercionregistros.sql        Insercion   Inserta los 64 registros de prueba
  03-usuariospermisos.sql          Varios      Usuarios con el minimo privilegio
  04-restriccionesadicionales.sql  Varios      CHECK y UNIQUE de los supuestos
  05-vistas.sql                    Varios      Vistas de consulta (OPCIONAL)
  06-verificacion.sql              Varios      Verificacion de solo lectura
  07-pruebasrestricciones.sql      Varios      Pruebas que deben fallar (ROLLBACK)

3. ORDEN DE EJECUCION
---------------------------------------------------------------------
  [00] -> 01 -> 02 -> 03 -> 04 -> [05] -> 06 -> [07]
  00 solo si la base ya existe y se quiere empezar de cero.
  05 y 07 son opcionales.

  Ejemplo desde la consola:
    mysql -u root -p < 01-creacionobjetos.sql
  El 07 se corre con --force para que siga despues de cada error:
    mysql -u root -p --force < 07-pruebasrestricciones.sql

4. RESULTADOS ESPERADOS
---------------------------------------------------------------------
  01  9 tablas creadas sin errores.
  02  64 registros insertados en una sola transaccion.
  03  Usuarios aeropuerto_app y aeropuerto_lectura. CAMBIE las contrasenas.
  04  Al final muestra 15 restricciones (9 CHECK y 6 UNIQUE).
  05  Cuatro vistas.
  06  9 tablas InnoDB y los conteos. Las secciones 3 a 7 no devuelven filas.
  07  Las 12 sentencias fallan con el error que dice su comentario
      (1062, 1452, 1451, 3819 o 1265). Termina en ROLLBACK.

5. NOTAS
---------------------------------------------------------------------
 - Ningun script tiene contrasenas reales.
 - Hay reglas que un CHECK no puede revisar porque miran otra tabla
   (solo los pilotos tripulan, solo los pasajeros reservan, un avion
   no es comercial y de carga a la vez). Esas se revisan con el 06.
