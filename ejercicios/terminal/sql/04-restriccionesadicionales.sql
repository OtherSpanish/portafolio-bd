-- Terminal de transporte - Bases de Datos 1
-- 04: restricciones adicionales de los supuestos
USE terminal;

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_conductor CHECK (
  tipo_persona = 'viajero'
  OR (licencia IS NOT NULL AND horas_manejo IS NOT NULL AND codigo_terminal IS NOT NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_viajero CHECK (
  tipo_persona <> 'viajero'
  OR (licencia IS NULL AND horas_manejo IS NULL AND codigo_terminal IS NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_viajero CHECK (
  tipo_persona = 'conductor' OR (correo IS NOT NULL AND puntos IS NOT NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_conductor CHECK (
  tipo_persona <> 'conductor' OR (correo IS NULL AND puntos IS NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_horas CHECK (horas_manejo IS NULL OR horas_manejo >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_puntos CHECK (puntos IS NULL OR puntos >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_correo CHECK (correo IS NULL OR correo LIKE '%_@_%._%');

ALTER TABLE BUS_PASAJEROS ADD CONSTRAINT ck_bus_pasajeros_asientos CHECK (num_sillas > 0);
ALTER TABLE BUS_CARGA ADD CONSTRAINT ck_bus_carga_capacidad CHECK (capacidad_kg > 0);

ALTER TABLE VIAJE ADD CONSTRAINT ck_viaje_destino CHECK (CHAR_LENGTH(TRIM(destino)) > 0);

ALTER TABLE CONDUCCION ADD COLUMN es_principal tinyint
  GENERATED ALWAYS AS (IF(rol = 'principal', 1, NULL)) VIRTUAL;
ALTER TABLE CONDUCCION ADD CONSTRAINT uq_conduccion_principal UNIQUE (id_viaje, es_principal);

SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'terminal' AND CONSTRAINT_TYPE IN ('CHECK', 'UNIQUE')
ORDER BY TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME;
