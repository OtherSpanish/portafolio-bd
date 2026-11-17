-- Escuela de conducción - Bases de Datos 1
-- 04: restricciones adicionales de los supuestos
USE autoescuela;

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_instructor CHECK (
  tipo_persona = 'alumno'
  OR (licencia IS NOT NULL AND horas_instruccion IS NOT NULL AND codigo_sede IS NOT NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_alumno CHECK (
  tipo_persona <> 'alumno'
  OR (licencia IS NULL AND horas_instruccion IS NULL AND codigo_sede IS NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_alumno CHECK (
  tipo_persona = 'instructor' OR (correo IS NOT NULL AND horas_practica IS NOT NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_instructor CHECK (
  tipo_persona <> 'instructor' OR (correo IS NULL AND horas_practica IS NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_horas CHECK (horas_instruccion IS NULL OR horas_instruccion >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_horas_practica CHECK (horas_practica IS NULL OR horas_practica >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_correo CHECK (correo IS NULL OR correo LIKE '%_@_%._%');

ALTER TABLE CARRO ADD CONSTRAINT ck_carro_asientos CHECK (num_puertas > 0);
ALTER TABLE MOTO ADD CONSTRAINT ck_moto_capacidad CHECK (cilindraje_cc > 0);

ALTER TABLE PRACTICA ADD CONSTRAINT ck_practica_recorrido CHECK (CHAR_LENGTH(TRIM(recorrido)) > 0);

ALTER TABLE INSTRUCCION ADD COLUMN es_principal tinyint
  GENERATED ALWAYS AS (IF(rol = 'principal', 1, NULL)) VIRTUAL;
ALTER TABLE INSTRUCCION ADD CONSTRAINT uq_instruccion_principal UNIQUE (id_practica, es_principal);

SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'autoescuela' AND CONSTRAINT_TYPE IN ('CHECK', 'UNIQUE')
ORDER BY TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME;
