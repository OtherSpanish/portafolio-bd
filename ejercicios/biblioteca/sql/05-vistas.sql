-- Red de bibliotecas - Bases de Datos 1
-- 05: vistas (consultas guardadas, no guardan datos)

USE biblioteca;

-- edad es derivado: no se guarda, se calcula
CREATE OR REPLACE VIEW v_lector_edad AS
SELECT x.carne, TIMESTAMPDIFF(YEAR, x.fecha_nacimiento, CURDATE()) AS edad
FROM LECTOR x;
