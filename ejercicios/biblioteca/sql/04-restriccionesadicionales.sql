-- Red de bibliotecas - Bases de Datos 1
-- 04: restricciones adicionales de los supuestos
USE biblioteca;

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_bibliotecario CHECK (
  tipo_persona = 'lector'
  OR (registro IS NOT NULL AND anios_experiencia IS NOT NULL AND codigo_sede IS NOT NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_lector CHECK (
  tipo_persona <> 'lector'
  OR (registro IS NULL AND anios_experiencia IS NULL AND codigo_sede IS NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_lector CHECK (
  tipo_persona = 'bibliotecario' OR (correo IS NOT NULL AND prestamos IS NOT NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_bibliotecario CHECK (
  tipo_persona <> 'bibliotecario' OR (correo IS NULL AND prestamos IS NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_horas CHECK (anios_experiencia IS NULL OR anios_experiencia >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_prestamos CHECK (prestamos IS NULL OR prestamos >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_correo CHECK (correo IS NULL OR correo LIKE '%_@_%._%');

ALTER TABLE SALA_COMPUTO ADD CONSTRAINT ck_sala_computo_asientos CHECK (num_equipos > 0);
ALTER TABLE SALA_INFANTIL ADD CONSTRAINT ck_sala_infantil_capacidad CHECK (area_m2 > 0);

ALTER TABLE TALLER ADD CONSTRAINT ck_taller_tema CHECK (CHAR_LENGTH(TRIM(tema)) > 0);

ALTER TABLE ORIENTACION ADD COLUMN es_principal tinyint
  GENERATED ALWAYS AS (IF(rol = 'principal', 1, NULL)) VIRTUAL;
ALTER TABLE ORIENTACION ADD CONSTRAINT uq_orientacion_principal UNIQUE (id_taller, es_principal);

SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'biblioteca' AND CONSTRAINT_TYPE IN ('CHECK', 'UNIQUE')
ORDER BY TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME;
