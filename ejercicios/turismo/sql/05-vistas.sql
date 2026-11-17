-- Agencia de turismo - Bases de Datos 1
-- 05: vistas (consultas guardadas, no guardan datos)

USE turismo;

-- edad es derivado: no se guarda, se calcula
CREATE OR REPLACE VIEW v_turista_edad AS
SELECT x.documento, TIMESTAMPDIFF(YEAR, x.fecha_nacimiento, CURDATE()) AS edad
FROM TURISTA x;

-- a qué subtipo pertenece cada paquete
CREATE OR REPLACE VIEW v_tipo_paquete AS
SELECT x.codigo_paquete,
       CASE
         WHEN s0.codigo_paquete IS NOT NULL THEN 'nacional'
         WHEN s1.codigo_paquete IS NOT NULL THEN 'internacional'
         ELSE 'ninguno'
       END AS tipo
FROM PAQUETE x
LEFT JOIN NACIONAL s0 ON s0.codigo_paquete = x.codigo_paquete
LEFT JOIN INTERNACIONAL s1 ON s1.codigo_paquete = x.codigo_paquete;
