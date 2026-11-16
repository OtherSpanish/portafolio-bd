-- Aeropuerto - Bases de Datos 1
-- 05: vistas (opcional)
-- Una vista es una consulta guardada; no guarda datos ni cambia tablas.
-- Se usan como tabla: SELECT * FROM nombre_vista;
-- Ejecutar con un usuario administrador.

USE aeropuerto;

-- edad de cada persona (dato derivado: no se guarda, se calcula)
CREATE OR REPLACE VIEW v_persona_edad AS
SELECT p.documento, p.nombres, p.apellidos, p.tipo_persona, p.fecha_nacimiento,
       TIMESTAMPDIFF(YEAR, p.fecha_nacimiento, CURDATE()) AS edad
FROM PERSONA p;

-- tipo de cada avion segun la especializacion (comercial, carga u otro)
CREATE OR REPLACE VIEW v_tipo_avion AS
SELECT a.matricula, a.fabricante, a.modelo, a.codigo_base,
       CASE
         WHEN c.matricula IS NOT NULL THEN 'comercial'
         WHEN g.matricula IS NOT NULL THEN 'carga'
         ELSE 'otro'
       END AS tipo,
       c.num_asientos, g.capacidad_kg
FROM AVION a
LEFT JOIN AVION_COMERCIAL c ON c.matricula = a.matricula
LEFT JOIN AVION_CARGA g ON g.matricula = a.matricula;

-- quien tripula cada vuelo
CREATE OR REPLACE VIEW v_tripulacion_vuelo AS
SELECT v.id_vuelo, v.codigo, v.fecha, v.destino, t.rol,
       p.documento, p.nombres, p.apellidos
FROM TRIPULACION t
JOIN VUELO v ON v.id_vuelo = t.id_vuelo
JOIN PERSONA p ON p.documento = t.documento;

-- cuantos puestos se ocupan en cada vuelo comercial
CREATE OR REPLACE VIEW v_ocupacion_vuelo AS
SELECT v.id_vuelo, v.codigo, v.fecha, v.destino, c.num_asientos,
       COUNT(r.documento) AS ocupados,
       ROUND(100 * COUNT(r.documento) / c.num_asientos, 2) AS porcentaje
FROM VUELO v
JOIN AVION_COMERCIAL c ON c.matricula = v.matricula
LEFT JOIN RESERVA r ON r.id_vuelo = v.id_vuelo
GROUP BY v.id_vuelo, v.codigo, v.fecha, v.destino, c.num_asientos;

SELECT * FROM v_tipo_avion;
SELECT * FROM v_ocupacion_vuelo ORDER BY id_vuelo;
