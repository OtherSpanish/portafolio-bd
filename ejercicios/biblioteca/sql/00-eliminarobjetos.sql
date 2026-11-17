-- Red de bibliotecas - Bases de Datos 1
-- 00: elimina vistas y tablas para volver a instalar desde cero
-- OJO: borra todos los datos.

USE biblioteca;

DROP VIEW IF EXISTS v_lector_edad;

-- las tablas se borran en orden inverso al de creacion
DROP TABLE IF EXISTS PRESTAMO;
DROP TABLE IF EXISTS AUTORIA;
DROP TABLE IF EXISTS EJEMPLAR;
DROP TABLE IF EXISTS LIBRO;
DROP TABLE IF EXISTS LEC_TELEFONO;
DROP TABLE IF EXISTS BIBLIOTECARIO;
DROP TABLE IF EXISTS LECTOR;
DROP TABLE IF EXISTS SEDE;
DROP TABLE IF EXISTS EDITORIAL;
DROP TABLE IF EXISTS AUTOR;
