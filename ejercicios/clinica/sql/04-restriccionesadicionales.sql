-- Clínica - Bases de Datos 1
-- 04: restricciones adicionales de los supuestos
USE clinica;

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_medico CHECK (
  tipo_persona = 'paciente'
  OR (registro_medico IS NOT NULL AND anios_experiencia IS NOT NULL AND codigo_sede IS NOT NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_paciente CHECK (
  tipo_persona <> 'paciente'
  OR (registro_medico IS NULL AND anios_experiencia IS NULL AND codigo_sede IS NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_paciente CHECK (
  tipo_persona = 'medico' OR (correo IS NOT NULL AND visitas IS NOT NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_medico CHECK (
  tipo_persona <> 'medico' OR (correo IS NULL AND visitas IS NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_horas CHECK (anios_experiencia IS NULL OR anios_experiencia >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_visitas CHECK (visitas IS NULL OR visitas >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_correo CHECK (correo IS NULL OR correo LIKE '%_@_%._%');

ALTER TABLE OBSERVACION ADD CONSTRAINT ck_observacion_asientos CHECK (num_camillas > 0);
ALTER TABLE LABORATORIO ADD CONSTRAINT ck_laboratorio_capacidad CHECK (area_m2 > 0);

ALTER TABLE JORNADA ADD CONSTRAINT ck_jornada_especialidad CHECK (CHAR_LENGTH(TRIM(especialidad)) > 0);

ALTER TABLE ATENCION ADD COLUMN es_principal tinyint
  GENERATED ALWAYS AS (IF(rol = 'principal', 1, NULL)) VIRTUAL;
ALTER TABLE ATENCION ADD CONSTRAINT uq_atencion_principal UNIQUE (id_jornada, es_principal);

SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'clinica' AND CONSTRAINT_TYPE IN ('CHECK', 'UNIQUE')
ORDER BY TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME;
