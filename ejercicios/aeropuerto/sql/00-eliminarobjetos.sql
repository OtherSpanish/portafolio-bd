-- Aeropuerto - Bases de Datos 1
-- 00: elimina vistas y tablas para volver a instalar desde cero
-- OJO: borra todos los datos. Ejecutar con un usuario administrador.

USE aeropuerto;

DROP VIEW IF EXISTS v_ocupacion_vuelo;
DROP VIEW IF EXISTS v_tripulacion_vuelo;
DROP VIEW IF EXISTS v_tipo_avion;
DROP VIEW IF EXISTS v_persona_edad;

-- las tablas se borran en orden inverso al de creacion
DROP TABLE IF EXISTS RESERVA;
DROP TABLE IF EXISTS TRIPULACION;
DROP TABLE IF EXISTS VUELO;
DROP TABLE IF EXISTS AVION_CARGA;
DROP TABLE IF EXISTS AVION_COMERCIAL;
DROP TABLE IF EXISTS AVION;
DROP TABLE IF EXISTS PER_TELEFONO;
DROP TABLE IF EXISTS PERSONA;
DROP TABLE IF EXISTS BASE;
