-- Aeropuerto - Bases de Datos 1
-- 07: pruebas negativas. CADA sentencia debe fallar con el error indicado.
-- Ejecutar con --force para que el cliente siga despues de cada error.
-- Termina con ROLLBACK: no deja cambios.

USE aeropuerto;

START TRANSACTION;

-- P1 (1062) llave primaria repetida
INSERT INTO BASE VALUES ('BOG', 'Otra base', 'Bogota', 'Colombia');

-- P2 (1452) la base no existe
INSERT INTO AVION VALUES ('HK-9999', 'A321', 'Airbus', 'XXX');

-- P3 (1451) no se puede borrar una base que tiene aviones
DELETE FROM BASE WHERE codigo_base = 'BOG';

-- P4 (3819) piloto sin licencia
INSERT INTO PERSONA (documento, nombres, apellidos, fecha_nacimiento, tipo_persona)
VALUES ('3010', 'Ana', 'Perez', '1990-01-01', 'piloto');

-- P5 (3819) pasajero sin correo
INSERT INTO PERSONA (documento, nombres, apellidos, fecha_nacimiento, tipo_persona)
VALUES ('3020', 'Luis', 'Rios', '1995-02-02', 'pasajero');

-- P6 (1062) correo repetido
INSERT INTO PERSONA (documento, nombres, apellidos, fecha_nacimiento, tipo_persona, correo, millas)
VALUES ('3030', 'Eva', 'Mora', '1999-03-03', 'pasajero', 'mateo.sanchez@correo.co', 0);

-- P7 (1062) el mismo vuelo dos veces el mismo dia
INSERT INTO VUELO (codigo, fecha, hora_salida, destino, matricula, codigo_base_origen)
VALUES ('AV101', '2026-11-20', '07:00', 'Cartagena', 'HK-5001', 'BOG');

-- P8 (1062) dos pasajeros en el mismo asiento del mismo vuelo
INSERT INTO RESERVA VALUES ('2030', 1, '12A', 'economica');

-- P9 (1062) un segundo capitan en el vuelo 1
UPDATE TRIPULACION SET rol = 'capitan' WHERE documento = '1040' AND id_vuelo = 1;

-- P10 (1265) clase que no existe
INSERT INTO RESERVA VALUES ('2040', 1, '30A', 'primera');

-- P11 (3819) avion comercial sin asientos
INSERT INTO AVION_COMERCIAL VALUES ('HK-7001', 0);

-- P12 (3819) horas de vuelo negativas
UPDATE PERSONA SET horas_vuelo = -5 WHERE documento = '1010';

ROLLBACK;
