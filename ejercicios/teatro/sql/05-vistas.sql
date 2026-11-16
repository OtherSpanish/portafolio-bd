-- Teatro - Bases de Datos 1
-- 05: vistas
USE teatro;

CREATE OR REPLACE VIEW v_persona_edad AS
SELECT p.documento, p.nombres, p.apellidos, p.tipo_persona, p.fecha_nacimiento,
       TIMESTAMPDIFF(YEAR, p.fecha_nacimiento, CURDATE()) AS edad
FROM PERSONA p;

CREATE OR REPLACE VIEW v_tipo_sala AS
SELECT a.codigo_sala, a.piso, a.nombre_sala, a.codigo_teatro,
       CASE
         WHEN c.codigo_sala IS NOT NULL THEN 'mayor'
         WHEN g.codigo_sala IS NOT NULL THEN 'ensayo'
         ELSE 'otro'
       END AS tipo,
       c.num_sillas, g.area_m2
FROM SALA a
LEFT JOIN SALA_MAYOR c ON c.codigo_sala = a.codigo_sala
LEFT JOIN SALA_ENSAYO g ON g.codigo_sala = a.codigo_sala;

CREATE OR REPLACE VIEW v_elenco_funcion AS
SELECT v.id_funcion, v.codigo, v.fecha, v.obra, t.rol,
       p.documento, p.nombres, p.apellidos
FROM ELENCO t
JOIN FUNCION v ON v.id_funcion = t.id_funcion
JOIN PERSONA p ON p.documento = t.documento;

CREATE OR REPLACE VIEW v_ocupacion_funcion AS
SELECT v.id_funcion, v.codigo, v.fecha, v.obra, c.num_sillas,
       COUNT(r.documento) AS ocupados,
       ROUND(100 * COUNT(r.documento) / c.num_sillas, 2) AS porcentaje
FROM FUNCION v
JOIN SALA_MAYOR c ON c.codigo_sala = v.codigo_sala
LEFT JOIN BOLETA r ON r.id_funcion = v.id_funcion
GROUP BY v.id_funcion, v.codigo, v.fecha, v.obra, c.num_sillas;

SELECT * FROM v_tipo_sala;
SELECT * FROM v_ocupacion_funcion ORDER BY id_funcion;
