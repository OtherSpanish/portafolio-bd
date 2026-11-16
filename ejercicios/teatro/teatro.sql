-- Teatro - script completo (01 + 02 + 04 + 05). Probado en MySQL 8.0.

-- Teatro - Bases de Datos 1
-- 01: creacion de la teatro de datos y de las 9 tablas
SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS teatro
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE teatro;

CREATE TABLE TEATRO (
  codigo_teatro char(3) NOT NULL,
  nombre varchar(80) NOT NULL,
  ciudad varchar(50) NOT NULL,
  pais varchar(50) NOT NULL,
  PRIMARY KEY (codigo_teatro)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE PERSONA (
  documento varchar(15) NOT NULL,
  nombres varchar(50) NOT NULL,
  apellidos varchar(50) NOT NULL,
  fecha_nacimiento date NOT NULL,
  tipo_persona enum('actor','espectador','ambos') NOT NULL,
  carnet varchar(10) DEFAULT NULL,
  anios_carrera int DEFAULT NULL,
  codigo_teatro char(3) DEFAULT NULL,
  correo varchar(80) DEFAULT NULL,
  puntos int DEFAULT NULL,
  PRIMARY KEY (documento),
  UNIQUE KEY uq_persona_carnet (carnet),
  UNIQUE KEY uq_persona_correo (correo),
  KEY fk_persona_teatro (codigo_teatro),
  CONSTRAINT fk_persona_teatro FOREIGN KEY (codigo_teatro) REFERENCES TEATRO (codigo_teatro)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE PER_TELEFONO (
  documento varchar(15) NOT NULL,
  telefono varchar(15) NOT NULL,
  PRIMARY KEY (documento,telefono),
  CONSTRAINT fk_per_telefono_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE SALA (
  codigo_sala varchar(10) NOT NULL,
  nombre_sala varchar(40) NOT NULL,
  piso varchar(40) NOT NULL,
  codigo_teatro char(3) NOT NULL,
  PRIMARY KEY (codigo_sala),
  KEY fk_sala_teatro (codigo_teatro),
  CONSTRAINT fk_sala_teatro FOREIGN KEY (codigo_teatro) REFERENCES TEATRO (codigo_teatro)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE SALA_MAYOR (
  codigo_sala varchar(10) NOT NULL,
  num_sillas int NOT NULL,
  PRIMARY KEY (codigo_sala),
  CONSTRAINT fk_sala_mayor_sala FOREIGN KEY (codigo_sala) REFERENCES SALA (codigo_sala)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE SALA_ENSAYO (
  codigo_sala varchar(10) NOT NULL,
  area_m2 decimal(10,2) NOT NULL,
  PRIMARY KEY (codigo_sala),
  CONSTRAINT fk_sala_ensayo_sala FOREIGN KEY (codigo_sala) REFERENCES SALA (codigo_sala)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE FUNCION (
  id_funcion bigint NOT NULL AUTO_INCREMENT,
  codigo varchar(8) NOT NULL,
  fecha date NOT NULL,
  hora_inicio time NOT NULL,
  obra varchar(50) NOT NULL,
  codigo_sala varchar(10) NOT NULL,
  teatro_funcion char(3) NOT NULL,
  PRIMARY KEY (id_funcion),
  UNIQUE KEY uq_funcion_codigo_fecha (codigo,fecha),
  KEY fk_funcion_sala (codigo_sala),
  KEY fk_funcion_teatro (teatro_funcion),
  CONSTRAINT fk_funcion_sala FOREIGN KEY (codigo_sala) REFERENCES SALA (codigo_sala),
  CONSTRAINT fk_funcion_teatro FOREIGN KEY (teatro_funcion) REFERENCES TEATRO (codigo_teatro)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE ELENCO (
  documento varchar(15) NOT NULL,
  id_funcion bigint NOT NULL,
  rol enum('protagonista','reparto') NOT NULL,
  PRIMARY KEY (documento,id_funcion),
  KEY fk_elenco_funcion (id_funcion),
  CONSTRAINT fk_elenco_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento),
  CONSTRAINT fk_elenco_funcion FOREIGN KEY (id_funcion) REFERENCES FUNCION (id_funcion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE BOLETA (
  documento varchar(15) NOT NULL,
  id_funcion bigint NOT NULL,
  silla varchar(4) NOT NULL,
  zona enum('general','palco') NOT NULL,
  PRIMARY KEY (documento,id_funcion),
  UNIQUE KEY uq_boleta_funcion_silla (id_funcion,silla),
  CONSTRAINT fk_boleta_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento),
  CONSTRAINT fk_boleta_funcion FOREIGN KEY (id_funcion) REFERENCES FUNCION (id_funcion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Teatro - Bases de Datos 1
-- 02: registros de prueba (64), en una sola transaccion

USE teatro;



START TRANSACTION;



INSERT INTO TEATRO (codigo_teatro, nombre, ciudad, pais) VALUES
('BOG', 'Teatro Colon', 'Bogota', 'Colombia'),
('MED', 'Teatro Pablo Tobon', 'Medellin', 'Colombia'),
('CAL', 'Teatro Municipal', 'Cali', 'Colombia');

INSERT INTO PERSONA (documento, nombres, apellidos, fecha_nacimiento, tipo_persona,
                     carnet, anios_carrera, codigo_teatro, correo, puntos) VALUES
('1010', 'Alejandro', 'Buitrago Diaz', '1980-03-12', 'actor', 'ACT-301', 22, 'BOG', NULL, NULL),
('1020', 'Carolina', 'Restrepo Gil', '1988-07-25', 'actor', 'ACT-455', 11, 'MED', NULL, NULL),
('1030', 'Gustavo', 'Arenas Polo', '1975-11-02', 'actor', 'ACT-118', 30, 'BOG', NULL, NULL),
('1040', 'Elena Maria', 'Montes Ruiz', '1992-01-18', 'ambos', 'ACT-602', 6, 'CAL', 'elena.montes@correo.co', 120),
('2010', 'Pablo', 'Sierra Cano', '2000-05-30', 'espectador', NULL, NULL, NULL, 'pablo.sierra@correo.co', 540),
('2020', 'Juliana', 'Velez Mora', '1997-09-14', 'espectador', NULL, NULL, NULL, 'juliana.velez@correo.co', 60),
('2030', 'Martin', 'Ochoa Prada', '1985-12-01', 'espectador', NULL, NULL, NULL, 'martin.ochoa@correo.co', 980),
('2040', 'Antonia', 'Rey Salas', '2003-04-22', 'espectador', NULL, NULL, NULL, 'antonia.rey@correo.co', 0),
('2050', 'Simon', 'Castano Leon', '1979-08-08', 'espectador', NULL, NULL, NULL, 'simon.castano@correo.co', 730);

INSERT INTO PER_TELEFONO (documento, telefono) VALUES
('1010', '3001112233'),
('1010', '6015550101'),
('1020', '3104445566'),
('1030', '3207778899'),
('1040', '3156667788'),
('1040', '3019990000'),
('2010', '3121234567'),
('2020', '3189876543'),
('2030', '3001239876'),
('2030', '6047771234'),
('2040', '3165554433'),
('2050', '3112223344');

INSERT INTO SALA (codigo_sala, nombre_sala, piso, codigo_teatro) VALUES
('SA-01', 'Sala Principal', 'Piso 1', 'BOG'),
('SA-02', 'Sala Estudio', 'Piso 2', 'MED'),
('SA-03', 'Sala Grande', 'Piso 1', 'CAL'),
('SA-04', 'Sala Estudio', 'Piso 3', 'BOG'),
('SA-05', 'Foyer', 'Piso 1', 'BOG');

INSERT INTO SALA_MAYOR (codigo_sala, num_sillas) VALUES
('SA-01', 750),
('SA-02', 420),
('SA-03', 600);

INSERT INTO SALA_ENSAYO (codigo_sala, area_m2) VALUES
('SA-04', 95.00);

INSERT INTO FUNCION (id_funcion, codigo, fecha, hora_inicio, obra, codigo_sala, teatro_funcion) VALUES
(1, 'HAM01', '2026-10-02', '19:00', 'Hamlet', 'SA-01', 'BOG'),
(2, 'BOD02', '2026-10-02', '20:00', 'Bodas de Sangre', 'SA-02', 'MED'),
(3, 'HAM03', '2026-10-03', '19:00', 'Hamlet', 'SA-03', 'CAL'),
(4, 'HAM01', '2026-10-04', '19:00', 'Hamlet', 'SA-01', 'BOG'),
(5, 'ENS05', '2026-10-04', '10:00', 'Ensayo General', 'SA-04', 'BOG'),
(6, 'MIS06', '2026-10-05', '17:00', 'La Miseria', 'SA-02', 'MED');

INSERT INTO ELENCO (documento, id_funcion, rol) VALUES
('1010', 1, 'protagonista'),
('1040', 1, 'reparto'),
('1020', 2, 'protagonista'),
('1030', 2, 'reparto'),
('1040', 3, 'protagonista'),
('1020', 3, 'reparto'),
('1030', 4, 'protagonista'),
('1010', 4, 'reparto'),
('1030', 5, 'protagonista'),
('1010', 5, 'reparto'),
('1020', 6, 'protagonista'),
('1040', 6, 'reparto');

INSERT INTO BOLETA (documento, id_funcion, silla, zona) VALUES
('2010', 1, 'F12', 'general'),
('2010', 3, 'A05', 'general'),
('2010', 4, 'C14', 'general'),
('2020', 1, 'P02', 'palco'),
('2020', 2, 'D08', 'general'),
('2030', 2, 'P01', 'palco'),
('2030', 6, 'P03', 'palco'),
('2040', 3, 'H20', 'general'),
('2040', 6, 'J22', 'general'),
('2050', 1, 'F15', 'general'),
('2050', 3, 'B09', 'general'),
('2050', 4, 'P04', 'palco'),
('1040', 2, 'E18', 'general');



COMMIT;

-- Teatro - Bases de Datos 1
-- 04: restricciones adicionales de los supuestos
USE teatro;

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_actor CHECK (
  tipo_persona = 'espectador'
  OR (carnet IS NOT NULL AND anios_carrera IS NOT NULL AND codigo_teatro IS NOT NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_espectador CHECK (
  tipo_persona <> 'espectador'
  OR (carnet IS NULL AND anios_carrera IS NULL AND codigo_teatro IS NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_espectador CHECK (
  tipo_persona = 'actor' OR (correo IS NOT NULL AND puntos IS NOT NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_actor CHECK (
  tipo_persona <> 'actor' OR (correo IS NULL AND puntos IS NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_horas CHECK (anios_carrera IS NULL OR anios_carrera >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_puntos CHECK (puntos IS NULL OR puntos >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_correo CHECK (correo IS NULL OR correo LIKE '%_@_%._%');

ALTER TABLE SALA_MAYOR ADD CONSTRAINT ck_sala_mayor_asientos CHECK (num_sillas > 0);
ALTER TABLE SALA_ENSAYO ADD CONSTRAINT ck_sala_ensayo_capacidad CHECK (area_m2 > 0);

ALTER TABLE FUNCION ADD CONSTRAINT ck_funcion_obra CHECK (CHAR_LENGTH(TRIM(obra)) > 0);

ALTER TABLE ELENCO ADD COLUMN es_protagonista tinyint
  GENERATED ALWAYS AS (IF(rol = 'protagonista', 1, NULL)) VIRTUAL;
ALTER TABLE ELENCO ADD CONSTRAINT uq_elenco_protagonista UNIQUE (id_funcion, es_protagonista);

SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'teatro' AND CONSTRAINT_TYPE IN ('CHECK', 'UNIQUE')
ORDER BY TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME;

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
