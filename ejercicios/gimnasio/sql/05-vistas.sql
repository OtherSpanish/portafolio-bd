-- Gimnasio - Bases de Datos 1
-- 05: vistas (consultas guardadas, no guardan datos)

USE gimnasio;

-- edad es derivado: no se guarda, se calcula
CREATE OR REPLACE VIEW v_socio_edad AS
SELECT x.id_socio, TIMESTAMPDIFF(YEAR, x.fecha_nacimiento, CURDATE()) AS edad
FROM SOCIO x;

-- anios_uso es derivado: no se guarda, se calcula
CREATE OR REPLACE VIEW v_cardio_anios_uso AS
SELECT x.serial, YEAR(CURDATE()) - x.anio AS anios_uso
FROM CARDIO x;

-- anios_uso es derivado: no se guarda, se calcula
CREATE OR REPLACE VIEW v_fuerza_anios_uso AS
SELECT x.serial, YEAR(CURDATE()) - x.anio AS anios_uso
FROM FUERZA x;

-- todas las maquinas juntas, sin importar su tipo
CREATE OR REPLACE VIEW v_maquina AS
SELECT serial, marca, anio, codigo_sede, 'cardio' AS tipo FROM CARDIO
UNION ALL
SELECT serial, marca, anio, codigo_sede, 'fuerza' FROM FUERZA;
