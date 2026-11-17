-- Agencia de turismo - Bases de Datos 1
-- 04: restricciones adicionales de los supuestos

USE turismo;

-- estrellas de 1 a 5
ALTER TABLE HOTEL ADD CONSTRAINT ck_hotel_estrellas CHECK (estrellas BETWEEN 1 AND 5);

-- dias, noches y valores positivos
ALTER TABLE PAQUETE ADD CONSTRAINT ck_paquete_valores CHECK (dias > 0 AND precio > 0);
ALTER TABLE ITINERARIO ADD CONSTRAINT ck_itinerario_noches CHECK (noches > 0);
ALTER TABLE VENTA ADD CONSTRAINT ck_venta_valor CHECK (valor_pagado > 0);
