-- Aeropuerto - Bases de Datos 1
-- 04: restricciones adicionales que salen de los supuestos del enunciado
-- Ejecutar con un usuario administrador, despues de 02.

USE aeropuerto;

-- un piloto (o alguien que es ambos) debe tener licencia, horas y base
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_piloto CHECK (
  tipo_persona = 'pasajero'
  OR (licencia IS NOT NULL AND horas_vuelo IS NOT NULL AND codigo_base IS NOT NULL));

-- quien solo es pasajero no lleva datos de piloto
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_pasajero CHECK (
  tipo_persona <> 'pasajero'
  OR (licencia IS NULL AND horas_vuelo IS NULL AND codigo_base IS NULL));

-- un pasajero (o alguien que es ambos) debe tener correo y millas
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_pasajero CHECK (
  tipo_persona = 'piloto' OR (correo IS NOT NULL AND millas IS NOT NULL));

-- quien solo es piloto no lleva datos de pasajero
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_piloto CHECK (
  tipo_persona <> 'piloto' OR (correo IS NULL AND millas IS NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_horas CHECK (horas_vuelo IS NULL OR horas_vuelo >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_millas CHECK (millas IS NULL OR millas >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_correo CHECK (correo IS NULL OR correo LIKE '%_@_%._%');

ALTER TABLE AVION_COMERCIAL ADD CONSTRAINT ck_avion_comercial_asientos CHECK (num_asientos > 0);
ALTER TABLE AVION_CARGA ADD CONSTRAINT ck_avion_carga_capacidad CHECK (capacidad_kg > 0);

-- el destino no puede quedar vacio
ALTER TABLE VUELO ADD CONSTRAINT ck_vuelo_destino CHECK (CHAR_LENGTH(TRIM(destino)) > 0);

-- un vuelo tiene un solo capitan
ALTER TABLE TRIPULACION ADD COLUMN es_capitan tinyint
  GENERATED ALWAYS AS (IF(rol = 'capitan', 1, NULL)) VIRTUAL;
ALTER TABLE TRIPULACION ADD CONSTRAINT uq_tripulacion_capitan UNIQUE (id_vuelo, es_capitan);

-- resumen de lo que quedo
SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'aeropuerto' AND CONSTRAINT_TYPE IN ('CHECK', 'UNIQUE')
ORDER BY TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME;
