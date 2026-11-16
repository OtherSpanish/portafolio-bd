-- Teatro - Bases de Datos 1
-- 04: restricciones adicionales de los supuestos
USE teatro;

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_actor CHECK (
  tipo_persona = 'espectador'
  OR (carnet IS NOT NULL AND anios_carrera IS NOT NULL AND codigo_teatro IS NOT NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_espectador CHECK (
  tipo_persona <> 'espectador'
  OR (carnet IS NULL AND anios_carrera IS NULL AND codigo_teatro IS NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_espectador CHECK (
  tipo_persona = 'actor' OR (correo IS NOT NULL AND puntos IS NOT NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_actor CHECK (
  tipo_persona <> 'actor' OR (correo IS NULL AND puntos IS NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_horas CHECK (anios_carrera IS NULL OR anios_carrera >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_puntos CHECK (puntos IS NULL OR puntos >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_correo CHECK (correo IS NULL OR correo LIKE '%_@_%._%');

ALTER TABLE SALA_MAYOR ADD CONSTRAINT ck_sala_mayor_asientos CHECK (num_sillas > 0);
ALTER TABLE SALA_ENSAYO ADD CONSTRAINT ck_sala_ensayo_capacidad CHECK (area_m2 > 0);

ALTER TABLE FUNCION ADD CONSTRAINT ck_funcion_obra CHECK (CHAR_LENGTH(TRIM(obra)) > 0);

ALTER TABLE ELENCO ADD COLUMN es_protagonista tinyint
  GENERATED ALWAYS AS (IF(rol = 'protagonista', 1, NULL)) VIRTUAL;
ALTER TABLE ELENCO ADD CONSTRAINT uq_elenco_protagonista UNIQUE (id_funcion, es_protagonista);

SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'teatro' AND CONSTRAINT_TYPE IN ('CHECK', 'UNIQUE')
ORDER BY TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME;
