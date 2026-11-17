-- Escuela de conducción - Bases de Datos 1
-- 05: vistas (consultas guardadas, no guardan datos)

USE autoescuela;

-- edad es derivado: no se guarda, se calcula
CREATE OR REPLACE VIEW v_alumno_edad AS
SELECT x.documento, TIMESTAMPDIFF(YEAR, x.fecha_nacimiento, CURDATE()) AS edad
FROM ALUMNO x;

-- edad es derivado: no se guarda, se calcula
CREATE OR REPLACE VIEW v_instructor_edad AS
SELECT x.documento, TIMESTAMPDIFF(YEAR, x.fecha_nacimiento, CURDATE()) AS edad
FROM INSTRUCTOR x;

-- a qué subtipo pertenece cada vehiculo
CREATE OR REPLACE VIEW v_tipo_vehiculo AS
SELECT x.placa,
       CASE
         WHEN s0.placa IS NOT NULL THEN 'carro'
         WHEN s1.placa IS NOT NULL THEN 'moto'
         WHEN s2.placa IS NOT NULL THEN 'camion'
         ELSE 'ninguno'
       END AS tipo
FROM VEHICULO x
LEFT JOIN CARRO s0 ON s0.placa = x.placa
LEFT JOIN MOTO s1 ON s1.placa = x.placa
LEFT JOIN CAMION s2 ON s2.placa = x.placa;
