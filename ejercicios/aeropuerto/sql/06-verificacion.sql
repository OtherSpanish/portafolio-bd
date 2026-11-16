-- Aeropuerto - Bases de Datos 1
-- 06: verificacion de solo lectura (no cambia nada)
-- Las secciones 3 a 7 NO deben devolver filas.

USE aeropuerto;

-- 1. tablas y motor
SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'aeropuerto' AND TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

-- 2. registros por tabla
SELECT 'BASE' AS tabla, COUNT(*) AS registros FROM BASE
UNION ALL SELECT 'PERSONA', COUNT(*) FROM PERSONA
UNION ALL SELECT 'PER_TELEFONO', COUNT(*) FROM PER_TELEFONO
UNION ALL SELECT 'AVION', COUNT(*) FROM AVION
UNION ALL SELECT 'AVION_COMERCIAL', COUNT(*) FROM AVION_COMERCIAL
UNION ALL SELECT 'AVION_CARGA', COUNT(*) FROM AVION_CARGA
UNION ALL SELECT 'VUELO', COUNT(*) FROM VUELO
UNION ALL SELECT 'TRIPULACION', COUNT(*) FROM TRIPULACION
UNION ALL SELECT 'RESERVA', COUNT(*) FROM RESERVA;

-- 3. solo los pilotos pueden tripular (el CHECK no puede mirar otra tabla)
SELECT t.documento, t.id_vuelo FROM TRIPULACION t
JOIN PERSONA p ON p.documento = t.documento
WHERE p.tipo_persona = 'pasajero';

-- 4. solo los pasajeros pueden reservar
SELECT r.documento, r.id_vuelo FROM RESERVA r
JOIN PERSONA p ON p.documento = r.documento
WHERE p.tipo_persona = 'piloto';

-- 5. un avion no puede ser comercial y de carga a la vez (jerarquia disjunta)
SELECT c.matricula FROM AVION_COMERCIAL c
JOIN AVION_CARGA g ON g.matricula = c.matricula;

-- 6. todo vuelo tiene al menos un piloto (participacion total)
SELECT v.id_vuelo, v.codigo FROM VUELO v
WHERE NOT EXISTS (SELECT 1 FROM TRIPULACION t WHERE t.id_vuelo = v.id_vuelo);

-- 7. no se reserva en un vuelo de carga ni se pasa de los asientos del avion
SELECT v.id_vuelo, v.codigo FROM VUELO v
JOIN RESERVA r ON r.id_vuelo = v.id_vuelo
LEFT JOIN AVION_COMERCIAL c ON c.matricula = v.matricula
GROUP BY v.id_vuelo, v.codigo, c.num_asientos
HAVING c.num_asientos IS NULL OR COUNT(*) > c.num_asientos;
