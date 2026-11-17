-- Red de bibliotecas - Bases de Datos 1
-- 05: vistas
USE biblioteca;

CREATE OR REPLACE VIEW v_persona_edad AS
SELECT p.documento, p.nombres, p.apellidos, p.tipo_persona, p.fecha_nacimiento,
       TIMESTAMPDIFF(YEAR, p.fecha_nacimiento, CURDATE()) AS edad
FROM PERSONA p;

CREATE OR REPLACE VIEW v_tipo_sala AS
SELECT a.codigo_sala, a.piso, a.nombre_sala, a.codigo_sede,
       CASE
         WHEN c.codigo_sala IS NOT NULL THEN 'computo'
         WHEN g.codigo_sala IS NOT NULL THEN 'infantil'
         ELSE 'otro'
       END AS tipo,
       c.num_equipos, g.area_m2
FROM SALA a
LEFT JOIN SALA_COMPUTO c ON c.codigo_sala = a.codigo_sala
LEFT JOIN SALA_INFANTIL g ON g.codigo_sala = a.codigo_sala;

CREATE OR REPLACE VIEW v_orientacion_taller AS
SELECT v.id_taller, v.codigo, v.fecha, v.tema, t.rol,
       p.documento, p.nombres, p.apellidos
FROM ORIENTACION t
JOIN TALLER v ON v.id_taller = t.id_taller
JOIN PERSONA p ON p.documento = t.documento;

CREATE OR REPLACE VIEW v_ocupacion_taller AS
SELECT v.id_taller, v.codigo, v.fecha, v.tema, c.num_equipos,
       COUNT(r.documento) AS ocupados,
       ROUND(100 * COUNT(r.documento) / c.num_equipos, 2) AS porcentaje
FROM TALLER v
JOIN SALA_COMPUTO c ON c.codigo_sala = v.codigo_sala
LEFT JOIN INSCRIPCION r ON r.id_taller = v.id_taller
GROUP BY v.id_taller, v.codigo, v.fecha, v.tema, c.num_equipos;

SELECT * FROM v_tipo_sala;
SELECT * FROM v_ocupacion_taller ORDER BY id_taller;
