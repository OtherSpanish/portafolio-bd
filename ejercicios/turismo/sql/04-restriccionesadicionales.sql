-- Agencia de turismo - Bases de Datos 1
-- 04: restricciones adicionales de los supuestos
USE turismo;

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_guia CHECK (
  tipo_persona = 'turista'
  OR (registro_rnt IS NOT NULL AND anios_experiencia IS NOT NULL AND codigo_oficina IS NOT NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_turista CHECK (
  tipo_persona <> 'turista'
  OR (registro_rnt IS NULL AND anios_experiencia IS NULL AND codigo_oficina IS NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_turista CHECK (
  tipo_persona = 'guia' OR (correo IS NOT NULL AND puntos IS NOT NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_guia CHECK (
  tipo_persona <> 'guia' OR (correo IS NULL AND puntos IS NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_horas CHECK (anios_experiencia IS NULL OR anios_experiencia >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_puntos CHECK (puntos IS NULL OR puntos >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_correo CHECK (correo IS NULL OR correo LIKE '%_@_%._%');

ALTER TABLE BUSETA ADD CONSTRAINT ck_buseta_asientos CHECK (num_sillas > 0);
ALTER TABLE LANCHA ADD CONSTRAINT ck_lancha_capacidad CHECK (eslora_m > 0);

ALTER TABLE TOUR ADD CONSTRAINT ck_tour_destino CHECK (CHAR_LENGTH(TRIM(destino)) > 0);

ALTER TABLE GUIANZA ADD COLUMN es_principal tinyint
  GENERATED ALWAYS AS (IF(rol = 'principal', 1, NULL)) VIRTUAL;
ALTER TABLE GUIANZA ADD CONSTRAINT uq_guianza_principal UNIQUE (id_tour, es_principal);

SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'turismo' AND CONSTRAINT_TYPE IN ('CHECK', 'UNIQUE')
ORDER BY TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME;
