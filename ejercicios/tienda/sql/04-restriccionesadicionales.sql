-- Tienda en línea - Bases de Datos 1
-- 04: restricciones adicionales de los supuestos

USE tienda;

-- cantidades, precios y stock positivos
ALTER TABLE DETALLE ADD CONSTRAINT ck_detalle_valores CHECK (cantidad > 0 AND precio_unitario > 0);
ALTER TABLE INVENTARIO ADD CONSTRAINT ck_inventario_stock CHECK (stock >= 0);
ALTER TABLE PAGO ADD CONSTRAINT ck_pago_valor CHECK (valor > 0);

-- el descuento va de 1 a 50 por ciento
ALTER TABLE CUPON ADD CONSTRAINT ck_cupon_pct CHECK (descuento_pct BETWEEN 1 AND 50);

-- una categoria no puede estar dentro de si misma
ALTER TABLE SUBCATEGORIA ADD CONSTRAINT ck_subcategoria_distinta CHECK (id_subcategoria <> id_padre);

-- la entrega no puede ser antes del envio
ALTER TABLE ENVIO ADD CONSTRAINT ck_envio_fechas CHECK (fecha_entrega IS NULL OR fecha_entrega >= fecha_envio);
