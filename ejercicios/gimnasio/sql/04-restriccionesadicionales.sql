-- Gimnasio - Bases de Datos 1
-- 04: restricciones adicionales de los supuestos
USE gimnasio;

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_entrenador CHECK (
  tipo_persona = 'socio'
  OR (certificacion IS NOT NULL AND anios_experiencia IS NOT NULL AND codigo_sede IS NOT NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_socio CHECK (
  tipo_persona <> 'socio'
  OR (certificacion IS NULL AND anios_experiencia IS NULL AND codigo_sede IS NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_socio CHECK (
  tipo_persona = 'entrenador' OR (correo IS NOT NULL AND puntos IS NOT NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_entrenador CHECK (
  tipo_persona <> 'entrenador' OR (correo IS NULL AND puntos IS NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_horas CHECK (anios_experiencia IS NULL OR anios_experiencia >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_puntos CHECK (puntos IS NULL OR puntos >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_correo CHECK (correo IS NULL OR correo LIKE '%_@_%._%');

ALTER TABLE SALA_CARDIO ADD CONSTRAINT ck_sala_cardio_asientos CHECK (num_maquinas > 0);
ALTER TABLE PISCINA ADD CONSTRAINT ck_piscina_capacidad CHECK (volumen_m3 > 0);

ALTER TABLE CLASE ADD CONSTRAINT ck_clase_actividad CHECK (CHAR_LENGTH(TRIM(actividad)) > 0);

ALTER TABLE INSTRUCCION ADD COLUMN es_principal tinyint
  GENERATED ALWAYS AS (IF(rol = 'principal', 1, NULL)) VIRTUAL;
ALTER TABLE INSTRUCCION ADD CONSTRAINT uq_instruccion_principal UNIQUE (id_clase, es_principal);

SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'gimnasio' AND CONSTRAINT_TYPE IN ('CHECK', 'UNIQUE')
ORDER BY TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME;
