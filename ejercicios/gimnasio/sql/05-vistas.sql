-- Gimnasio - Bases de Datos 1
-- 05: vistas
USE gimnasio;

CREATE OR REPLACE VIEW v_persona_edad AS
SELECT p.documento, p.nombres, p.apellidos, p.tipo_persona, p.fecha_nacimiento,
       TIMESTAMPDIFF(YEAR, p.fecha_nacimiento, CURDATE()) AS edad
FROM PERSONA p;

CREATE OR REPLACE VIEW v_tipo_sala AS
SELECT a.codigo_sala, a.piso, a.ambiente, a.codigo_sede,
       CASE
         WHEN c.codigo_sala IS NOT NULL THEN 'cardio'
         WHEN g.codigo_sala IS NOT NULL THEN 'piscina'
         ELSE 'otro'
       END AS tipo,
       c.num_maquinas, g.volumen_m3
FROM SALA a
LEFT JOIN SALA_CARDIO c ON c.codigo_sala = a.codigo_sala
LEFT JOIN PISCINA g ON g.codigo_sala = a.codigo_sala;

CREATE OR REPLACE VIEW v_instruccion_clase AS
SELECT v.id_clase, v.codigo, v.fecha, v.actividad, t.rol,
       p.documento, p.nombres, p.apellidos
FROM INSTRUCCION t
JOIN CLASE v ON v.id_clase = t.id_clase
JOIN PERSONA p ON p.documento = t.documento;

CREATE OR REPLACE VIEW v_ocupacion_clase AS
SELECT v.id_clase, v.codigo, v.fecha, v.actividad, c.num_maquinas,
       COUNT(r.documento) AS ocupados,
       ROUND(100 * COUNT(r.documento) / c.num_maquinas, 2) AS porcentaje
FROM CLASE v
JOIN SALA_CARDIO c ON c.codigo_sala = v.codigo_sala
LEFT JOIN CUPO r ON r.id_clase = v.id_clase
GROUP BY v.id_clase, v.codigo, v.fecha, v.actividad, c.num_maquinas;

SELECT * FROM v_tipo_sala;
SELECT * FROM v_ocupacion_clase ORDER BY id_clase;
