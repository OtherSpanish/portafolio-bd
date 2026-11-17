-- Agencia de turismo - Bases de Datos 1
-- 05: vistas
USE turismo;

CREATE OR REPLACE VIEW v_persona_edad AS
SELECT p.documento, p.nombres, p.apellidos, p.tipo_persona, p.fecha_nacimiento,
       TIMESTAMPDIFF(YEAR, p.fecha_nacimiento, CURDATE()) AS edad
FROM PERSONA p;

CREATE OR REPLACE VIEW v_tipo_vehiculo AS
SELECT a.placa, a.marca, a.modelo, a.codigo_oficina,
       CASE
         WHEN c.placa IS NOT NULL THEN 'buseta'
         WHEN g.placa IS NOT NULL THEN 'lancha'
         ELSE 'otro'
       END AS tipo,
       c.num_sillas, g.eslora_m
FROM VEHICULO a
LEFT JOIN BUSETA c ON c.placa = a.placa
LEFT JOIN LANCHA g ON g.placa = a.placa;

CREATE OR REPLACE VIEW v_guianza_tour AS
SELECT v.id_tour, v.codigo, v.fecha, v.destino, t.rol,
       p.documento, p.nombres, p.apellidos
FROM GUIANZA t
JOIN TOUR v ON v.id_tour = t.id_tour
JOIN PERSONA p ON p.documento = t.documento;

CREATE OR REPLACE VIEW v_ocupacion_tour AS
SELECT v.id_tour, v.codigo, v.fecha, v.destino, c.num_sillas,
       COUNT(r.documento) AS ocupados,
       ROUND(100 * COUNT(r.documento) / c.num_sillas, 2) AS porcentaje
FROM TOUR v
JOIN BUSETA c ON c.placa = v.placa
LEFT JOIN RESERVA r ON r.id_tour = v.id_tour
GROUP BY v.id_tour, v.codigo, v.fecha, v.destino, c.num_sillas;

SELECT * FROM v_tipo_vehiculo;
SELECT * FROM v_ocupacion_tour ORDER BY id_tour;
