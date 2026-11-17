-- Terminal de transporte - Bases de Datos 1
-- 05: vistas (consultas guardadas, no guardan datos)

USE terminal;

-- edad es derivado: no se guarda, se calcula
CREATE OR REPLACE VIEW v_persona_edad AS
SELECT x.documento, TIMESTAMPDIFF(YEAR, x.fecha_nacimiento, CURDATE()) AS edad
FROM PERSONA x;
