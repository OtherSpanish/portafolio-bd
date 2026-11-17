-- Escuela de conducción - Bases de Datos 1
-- 05: vistas
USE autoescuela;

CREATE OR REPLACE VIEW v_persona_edad AS
SELECT p.documento, p.nombres, p.apellidos, p.tipo_persona, p.fecha_nacimiento,
       TIMESTAMPDIFF(YEAR, p.fecha_nacimiento, CURDATE()) AS edad
FROM PERSONA p;

CREATE OR REPLACE VIEW v_tipo_vehiculo AS
SELECT a.placa, a.marca, a.modelo, a.codigo_sede,
       CASE
         WHEN c.placa IS NOT NULL THEN 'carro'
         WHEN g.placa IS NOT NULL THEN 'moto'
         ELSE 'otro'
       END AS tipo,
       c.num_puertas, g.cilindraje_cc
FROM VEHICULO a
LEFT JOIN CARRO c ON c.placa = a.placa
LEFT JOIN MOTO g ON g.placa = a.placa;

CREATE OR REPLACE VIEW v_instruccion_practica AS
SELECT v.id_practica, v.codigo, v.fecha, v.recorrido, t.rol,
       p.documento, p.nombres, p.apellidos
FROM INSTRUCCION t
JOIN PRACTICA v ON v.id_practica = t.id_practica
JOIN PERSONA p ON p.documento = t.documento;

CREATE OR REPLACE VIEW v_ocupacion_practica AS
SELECT v.id_practica, v.codigo, v.fecha, v.recorrido, c.num_puertas,
       COUNT(r.documento) AS ocupados,
       ROUND(100 * COUNT(r.documento) / c.num_puertas, 2) AS porcentaje
FROM PRACTICA v
JOIN CARRO c ON c.placa = v.placa
LEFT JOIN INSCRIPCION r ON r.id_practica = v.id_practica
GROUP BY v.id_practica, v.codigo, v.fecha, v.recorrido, c.num_puertas;

SELECT * FROM v_tipo_vehiculo;
SELECT * FROM v_ocupacion_practica ORDER BY id_practica;
