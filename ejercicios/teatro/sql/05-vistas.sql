-- Teatro - Bases de Datos 1
-- 05: vistas (consultas guardadas, no guardan datos)

USE teatro;

-- edad es derivado: no se guarda, se calcula
CREATE OR REPLACE VIEW v_espectador_edad AS
SELECT x.documento, TIMESTAMPDIFF(YEAR, x.fecha_nacimiento, CURDATE()) AS edad
FROM ESPECTADOR x;
