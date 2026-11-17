-- Clínica - Bases de Datos 1
-- 05: vistas (consultas guardadas, no guardan datos)

USE clinica;

-- edad es derivado: no se guarda, se calcula
CREATE OR REPLACE VIEW v_paciente_edad AS
SELECT x.documento, TIMESTAMPDIFF(YEAR, x.fecha_nacimiento, CURDATE()) AS edad
FROM PACIENTE x;

-- a qué subtipo pertenece cada cita
CREATE OR REPLACE VIEW v_tipo_cita AS
SELECT x.id_cita,
       CASE
         WHEN s0.id_cita IS NOT NULL THEN 'presencial'
         WHEN s1.id_cita IS NOT NULL THEN 'teleconsulta'
         ELSE 'ninguno'
       END AS tipo
FROM CITA x
LEFT JOIN PRESENCIAL s0 ON s0.id_cita = x.id_cita
LEFT JOIN TELECONSULTA s1 ON s1.id_cita = x.id_cita;
