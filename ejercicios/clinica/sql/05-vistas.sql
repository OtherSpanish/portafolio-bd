-- Clínica - Bases de Datos 1
-- 05: vistas
USE clinica;

CREATE OR REPLACE VIEW v_persona_edad AS
SELECT p.documento, p.nombres, p.apellidos, p.tipo_persona, p.fecha_nacimiento,
       TIMESTAMPDIFF(YEAR, p.fecha_nacimiento, CURDATE()) AS edad
FROM PERSONA p;

CREATE OR REPLACE VIEW v_tipo_consultorio AS
SELECT a.codigo_consultorio, a.piso, a.bloque, a.codigo_sede,
       CASE
         WHEN c.codigo_consultorio IS NOT NULL THEN 'observacion'
         WHEN g.codigo_consultorio IS NOT NULL THEN 'laboratorio'
         ELSE 'otro'
       END AS tipo,
       c.num_camillas, g.area_m2
FROM CONSULTORIO a
LEFT JOIN OBSERVACION c ON c.codigo_consultorio = a.codigo_consultorio
LEFT JOIN LABORATORIO g ON g.codigo_consultorio = a.codigo_consultorio;

CREATE OR REPLACE VIEW v_atencion_jornada AS
SELECT v.id_jornada, v.codigo, v.fecha, v.especialidad, t.rol,
       p.documento, p.nombres, p.apellidos
FROM ATENCION t
JOIN JORNADA v ON v.id_jornada = t.id_jornada
JOIN PERSONA p ON p.documento = t.documento;

CREATE OR REPLACE VIEW v_ocupacion_jornada AS
SELECT v.id_jornada, v.codigo, v.fecha, v.especialidad, c.num_camillas,
       COUNT(r.documento) AS ocupados,
       ROUND(100 * COUNT(r.documento) / c.num_camillas, 2) AS porcentaje
FROM JORNADA v
JOIN OBSERVACION c ON c.codigo_consultorio = v.codigo_consultorio
LEFT JOIN CITA r ON r.id_jornada = v.id_jornada
GROUP BY v.id_jornada, v.codigo, v.fecha, v.especialidad, c.num_camillas;

SELECT * FROM v_tipo_consultorio;
SELECT * FROM v_ocupacion_jornada ORDER BY id_jornada;
