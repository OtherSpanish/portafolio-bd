-- Terminal de transporte - Bases de Datos 1
-- 04: restricciones adicionales de los supuestos

USE terminal;

-- quien es conductor debe tener sus datos
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_conductor CHECK (
  tipo_persona IS NULL OR tipo_persona NOT IN ('conductor', 'ambos') OR (licencia IS NOT NULL AND categoria_licencia IS NOT NULL));

-- quien es viajero debe tener sus datos
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_viajero CHECK (
  tipo_persona IS NULL OR tipo_persona NOT IN ('viajero', 'ambos') OR (correo IS NOT NULL));

-- un conductor (o alguien que es ambos) debe tener empresa
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_empresa CHECK (
  tipo_persona = 'viajero' OR nit IS NOT NULL);

-- una ruta no sale y llega a la misma terminal
ALTER TABLE RUTA ADD CONSTRAINT ck_ruta_terminales CHECK (terminal_origen <> terminal_destino);

-- una silla no se vende dos veces para el mismo viaje
ALTER TABLE TIQUETE ADD CONSTRAINT uq_tiquete_silla UNIQUE (codigo_ruta, fecha_viaje, silla);

-- valores positivos
ALTER TABLE RUTA ADD CONSTRAINT ck_ruta_valor CHECK (valor > 0 AND duracion_min > 0);
