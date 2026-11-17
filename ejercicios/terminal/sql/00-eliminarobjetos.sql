-- Terminal de transporte - Bases de Datos 1
-- 00: elimina vistas y tablas para volver a instalar desde cero
-- OJO: borra todos los datos.

USE terminal;

DROP VIEW IF EXISTS v_persona_edad;

-- las tablas se borran en orden inverso al de creacion
DROP TABLE IF EXISTS TIQUETE;
DROP TABLE IF EXISTS PER_TELEFONO;
DROP TABLE IF EXISTS RUTA;
DROP TABLE IF EXISTS PERSONA;
DROP TABLE IF EXISTS TAQUILLA;
DROP TABLE IF EXISTS TERMINAL;
DROP TABLE IF EXISTS BUS;
DROP TABLE IF EXISTS EMPRESA;
