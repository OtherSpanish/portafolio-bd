-- Gimnasio - Bases de Datos 1
-- 00: elimina vistas y tablas para volver a instalar desde cero
-- OJO: borra todos los datos.

USE gimnasio;

DROP VIEW IF EXISTS v_maquina;
DROP VIEW IF EXISTS v_fuerza_anios_uso;
DROP VIEW IF EXISTS v_cardio_anios_uso;
DROP VIEW IF EXISTS v_socio_edad;

-- las tablas se borran en orden inverso al de creacion
DROP TABLE IF EXISTS ASESORIA;
DROP TABLE IF EXISTS ENTRENADOR;
DROP TABLE IF EXISTS ASISTENCIA;
DROP TABLE IF EXISTS SOC_TELEFONO;
DROP TABLE IF EXISTS FUERZA;
DROP TABLE IF EXISTS CARDIO;
DROP TABLE IF EXISTS SEDE;
DROP TABLE IF EXISTS SOCIO;
DROP TABLE IF EXISTS PLAN;
