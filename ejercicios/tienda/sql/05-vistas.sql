-- Tienda en línea - Bases de Datos 1
-- 05: vistas (consultas guardadas, no guardan datos)

USE tienda;

-- edad es derivado: no se guarda, se calcula
CREATE OR REPLACE VIEW v_cliente_edad AS
SELECT x.documento, TIMESTAMPDIFF(YEAR, x.fecha_nacimiento, CURDATE()) AS edad
FROM CLIENTE x;

-- a qué subtipo pertenece cada pago
CREATE OR REPLACE VIEW v_tipo_pago AS
SELECT x.id_pago,
       CASE
         WHEN s0.id_pago IS NOT NULL THEN 'tarjeta'
         WHEN s1.id_pago IS NOT NULL THEN 'pse'
         ELSE 'ninguno'
       END AS tipo
FROM PAGO x
LEFT JOIN TARJETA s0 ON s0.id_pago = x.id_pago
LEFT JOIN PSE s1 ON s1.id_pago = x.id_pago;
