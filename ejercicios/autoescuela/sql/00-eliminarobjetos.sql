-- Escuela de conducción - Bases de Datos 1
-- 00: elimina vistas y tablas para volver a instalar desde cero
-- OJO: borra todos los datos.

USE autoescuela;

DROP VIEW IF EXISTS v_tipo_vehiculo;
DROP VIEW IF EXISTS v_instructor_edad;
DROP VIEW IF EXISTS v_alumno_edad;

-- las tablas se borran en orden inverso al de creacion
DROP TABLE IF EXISTS PRACTICA;
DROP TABLE IF EXISTS CAMION;
DROP TABLE IF EXISTS MOTO;
DROP TABLE IF EXISTS CARRO;
DROP TABLE IF EXISTS VEHICULO;
DROP TABLE IF EXISTS OFERTA;
DROP TABLE IF EXISTS ALU_TELEFONO;
DROP TABLE IF EXISTS INSTRUCTOR;
DROP TABLE IF EXISTS ALUMNO;
DROP TABLE IF EXISTS CURSO;
DROP TABLE IF EXISTS SEDE;
