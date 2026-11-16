-- Universidad - Bases de Datos 1
-- 05: vistas
USE universidad;

CREATE OR REPLACE VIEW v_persona_edad AS
SELECT p.documento, p.nombres, p.apellidos, p.tipo_persona, p.fecha_nacimiento,
       TIMESTAMPDIFF(YEAR, p.fecha_nacimiento, CURDATE()) AS edad
FROM PERSONA p;

CREATE OR REPLACE VIEW v_tipo_salon AS
SELECT a.codigo_salon, a.piso, a.bloque, a.codigo_sede,
       CASE
         WHEN c.codigo_salon IS NOT NULL THEN 'laboratorio'
         WHEN g.codigo_salon IS NOT NULL THEN 'auditorio'
         ELSE 'otro'
       END AS tipo,
       c.num_equipos, g.area_m2
FROM SALON a
LEFT JOIN LABORATORIO c ON c.codigo_salon = a.codigo_salon
LEFT JOIN AUDITORIO g ON g.codigo_salon = a.codigo_salon;

CREATE OR REPLACE VIEW v_docencia_curso AS
SELECT v.id_curso, v.codigo, v.fecha, v.asignatura, t.rol,
       p.documento, p.nombres, p.apellidos
FROM DOCENCIA t
JOIN CURSO v ON v.id_curso = t.id_curso
JOIN PERSONA p ON p.documento = t.documento;

CREATE OR REPLACE VIEW v_ocupacion_curso AS
SELECT v.id_curso, v.codigo, v.fecha, v.asignatura, c.num_equipos,
       COUNT(r.documento) AS ocupados,
       ROUND(100 * COUNT(r.documento) / c.num_equipos, 2) AS porcentaje
FROM CURSO v
JOIN LABORATORIO c ON c.codigo_salon = v.codigo_salon
LEFT JOIN INSCRIPCION r ON r.id_curso = v.id_curso
GROUP BY v.id_curso, v.codigo, v.fecha, v.asignatura, c.num_equipos;

SELECT * FROM v_tipo_salon;
SELECT * FROM v_ocupacion_curso ORDER BY id_curso;
