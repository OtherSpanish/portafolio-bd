-- Universidad - Bases de Datos 1
-- 04: restricciones adicionales de los supuestos
USE universidad;

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_profesor CHECK (
  tipo_persona = 'estudiante'
  OR (registro IS NOT NULL AND anios_experiencia IS NOT NULL AND codigo_sede IS NOT NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_estudiante CHECK (
  tipo_persona <> 'estudiante'
  OR (registro IS NULL AND anios_experiencia IS NULL AND codigo_sede IS NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_estudiante CHECK (
  tipo_persona = 'profesor' OR (correo IS NOT NULL AND creditos IS NOT NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_profesor CHECK (
  tipo_persona <> 'profesor' OR (correo IS NULL AND creditos IS NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_horas CHECK (anios_experiencia IS NULL OR anios_experiencia >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_creditos CHECK (creditos IS NULL OR creditos >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_correo CHECK (correo IS NULL OR correo LIKE '%_@_%._%');

ALTER TABLE LABORATORIO ADD CONSTRAINT ck_laboratorio_asientos CHECK (num_equipos > 0);
ALTER TABLE AUDITORIO ADD CONSTRAINT ck_auditorio_capacidad CHECK (area_m2 > 0);

ALTER TABLE CURSO ADD CONSTRAINT ck_curso_asignatura CHECK (CHAR_LENGTH(TRIM(asignatura)) > 0);

ALTER TABLE DOCENCIA ADD COLUMN es_titular tinyint
  GENERATED ALWAYS AS (IF(rol = 'titular', 1, NULL)) VIRTUAL;
ALTER TABLE DOCENCIA ADD CONSTRAINT uq_docencia_titular UNIQUE (id_curso, es_titular);

SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'universidad' AND CONSTRAINT_TYPE IN ('CHECK', 'UNIQUE')
ORDER BY TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME;
