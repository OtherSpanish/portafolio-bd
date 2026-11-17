-- Escuela de conducción - Bases de Datos 1
-- 04: restricciones adicionales de los supuestos

USE autoescuela;

-- valores positivos
ALTER TABLE OFERTA ADD CONSTRAINT ck_oferta_precio CHECK (precio > 0);
ALTER TABLE PRACTICA ADD CONSTRAINT ck_practica_km CHECK (kilometros > 0);

-- un instructor no puede dar dos practicas a la misma hora
ALTER TABLE PRACTICA ADD CONSTRAINT uq_practica_instructor UNIQUE (doc_instructor, fecha, hora);
