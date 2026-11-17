-- Universidad - Bases de Datos 1
-- 05: vistas (consultas guardadas, no guardan datos)

USE universidad;

-- edad es derivado: no se guarda, se calcula
CREATE OR REPLACE VIEW v_estudiante_edad AS
SELECT x.id_estudiante, TIMESTAMPDIFF(YEAR, x.fecha_nacimiento, CURDATE()) AS edad
FROM ESTUDIANTE x;

-- a qué subtipo pertenece cada profesor
CREATE OR REPLACE VIEW v_tipo_profesor AS
SELECT x.id_profesor,
       CASE
         WHEN s0.id_profesor IS NOT NULL THEN 'planta'
         WHEN s1.id_profesor IS NOT NULL THEN 'catedra'
         ELSE 'ninguno'
       END AS tipo
FROM PROFESOR x
LEFT JOIN PLANTA s0 ON s0.id_profesor = x.id_profesor
LEFT JOIN CATEDRA s1 ON s1.id_profesor = x.id_profesor;
