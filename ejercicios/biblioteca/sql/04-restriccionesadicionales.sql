-- Red de bibliotecas - Bases de Datos 1
-- 04: restricciones adicionales de los supuestos

USE biblioteca;

-- quien es infantil debe tener sus datos
ALTER TABLE LECTOR ADD CONSTRAINT ck_lector_infantil CHECK (
  tipo_lector IS NULL OR tipo_lector NOT IN ('infantil') OR (acudiente IS NOT NULL));

-- quien es adulto debe tener sus datos
ALTER TABLE LECTOR ADD CONSTRAINT ck_lector_adulto CHECK (
  tipo_lector IS NULL OR tipo_lector NOT IN ('adulto') OR (ocupacion IS NOT NULL));

-- la devolucion no puede ser antes del prestamo
ALTER TABLE PRESTAMO ADD CONSTRAINT ck_prestamo_fechas CHECK (fecha_devolucion IS NULL OR fecha_devolucion >= fecha_prestamo);

-- un adulto debe tener correo
ALTER TABLE LECTOR ADD CONSTRAINT ck_lector_correo CHECK (tipo_lector = 'infantil' OR correo IS NOT NULL);
