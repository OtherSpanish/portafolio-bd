-- Terminal de transporte - Bases de Datos 1
-- 05: vistas
USE terminal;

CREATE OR REPLACE VIEW v_persona_edad AS
SELECT p.documento, p.nombres, p.apellidos, p.tipo_persona, p.fecha_nacimiento,
       TIMESTAMPDIFF(YEAR, p.fecha_nacimiento, CURDATE()) AS edad
FROM PERSONA p;

CREATE OR REPLACE VIEW v_tipo_bus AS
SELECT a.placa, a.marca, a.modelo, a.codigo_terminal,
       CASE
         WHEN c.placa IS NOT NULL THEN 'pasajeros'
         WHEN g.placa IS NOT NULL THEN 'carga'
         ELSE 'otro'
       END AS tipo,
       c.num_sillas, g.capacidad_kg
FROM BUS a
LEFT JOIN BUS_PASAJEROS c ON c.placa = a.placa
LEFT JOIN BUS_CARGA g ON g.placa = a.placa;

CREATE OR REPLACE VIEW v_conduccion_viaje AS
SELECT v.id_viaje, v.codigo, v.fecha, v.destino, t.rol,
       p.documento, p.nombres, p.apellidos
FROM CONDUCCION t
JOIN VIAJE v ON v.id_viaje = t.id_viaje
JOIN PERSONA p ON p.documento = t.documento;

CREATE OR REPLACE VIEW v_ocupacion_viaje AS
SELECT v.id_viaje, v.codigo, v.fecha, v.destino, c.num_sillas,
       COUNT(r.documento) AS ocupados,
       ROUND(100 * COUNT(r.documento) / c.num_sillas, 2) AS porcentaje
FROM VIAJE v
JOIN BUS_PASAJEROS c ON c.placa = v.placa
LEFT JOIN TIQUETE r ON r.id_viaje = v.id_viaje
GROUP BY v.id_viaje, v.codigo, v.fecha, v.destino, c.num_sillas;

SELECT * FROM v_tipo_bus;
SELECT * FROM v_ocupacion_viaje ORDER BY id_viaje;
