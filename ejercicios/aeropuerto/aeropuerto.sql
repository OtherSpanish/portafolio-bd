-- Aeropuerto - script completo (01 + 02 + 04 + 05). Probado en MySQL 8.0.

-- Aeropuerto - Bases de Datos 1
-- 01: creacion de la base de datos y de las 9 tablas
-- Las tablas van en orden: primero las que no dependen de otras.
-- Ejecutar con un usuario administrador.

SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS aeropuerto
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE aeropuerto;

-- BASE: aeropuertos donde opera la aerolinea (codigo IATA)
CREATE TABLE BASE (
  codigo_base char(3) NOT NULL,
  nombre varchar(80) NOT NULL,
  ciudad varchar(50) NOT NULL,
  pais varchar(50) NOT NULL,
  PRIMARY KEY (codigo_base)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- PERSONA: pilotos y pasajeros en una sola tabla (la jerarquia es solapada)
CREATE TABLE PERSONA (
  documento varchar(15) NOT NULL,
  nombres varchar(50) NOT NULL,
  apellidos varchar(50) NOT NULL,
  fecha_nacimiento date NOT NULL,
  tipo_persona enum('piloto','pasajero','ambos') NOT NULL,
  licencia varchar(10) DEFAULT NULL,
  horas_vuelo int DEFAULT NULL,
  codigo_base char(3) DEFAULT NULL,
  correo varchar(80) DEFAULT NULL,
  millas int DEFAULT NULL,
  PRIMARY KEY (documento),
  UNIQUE KEY uq_persona_licencia (licencia),
  UNIQUE KEY uq_persona_correo (correo),
  KEY fk_persona_base (codigo_base),
  CONSTRAINT fk_persona_base FOREIGN KEY (codigo_base) REFERENCES BASE (codigo_base)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- PER_TELEFONO: telefonos de cada persona (atributo multivaluado)
CREATE TABLE PER_TELEFONO (
  documento varchar(15) NOT NULL,
  telefono varchar(15) NOT NULL,
  PRIMARY KEY (documento,telefono),
  CONSTRAINT fk_per_telefono_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- AVION: datos comunes del avion (supertipo)
CREATE TABLE AVION (
  matricula varchar(10) NOT NULL,
  modelo varchar(40) NOT NULL,
  fabricante varchar(40) NOT NULL,
  codigo_base char(3) NOT NULL,
  PRIMARY KEY (matricula),
  KEY fk_avion_base (codigo_base),
  CONSTRAINT fk_avion_base FOREIGN KEY (codigo_base) REFERENCES BASE (codigo_base)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- AVION_COMERCIAL: subtipo de pasajeros
CREATE TABLE AVION_COMERCIAL (
  matricula varchar(10) NOT NULL,
  num_asientos int NOT NULL,
  PRIMARY KEY (matricula),
  CONSTRAINT fk_avion_comercial_avion FOREIGN KEY (matricula) REFERENCES AVION (matricula)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- AVION_CARGA: subtipo de carga
CREATE TABLE AVION_CARGA (
  matricula varchar(10) NOT NULL,
  capacidad_kg decimal(10,2) NOT NULL,
  PRIMARY KEY (matricula),
  CONSTRAINT fk_avion_carga_avion FOREIGN KEY (matricula) REFERENCES AVION (matricula)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- VUELO: cada salida de un avion desde una base
CREATE TABLE VUELO (
  id_vuelo bigint NOT NULL AUTO_INCREMENT,
  codigo varchar(8) NOT NULL,
  fecha date NOT NULL,
  hora_salida time NOT NULL,
  destino varchar(50) NOT NULL,
  matricula varchar(10) NOT NULL,
  codigo_base_origen char(3) NOT NULL,
  PRIMARY KEY (id_vuelo),
  UNIQUE KEY uq_vuelo_codigo_fecha (codigo,fecha),
  KEY fk_vuelo_avion (matricula),
  KEY fk_vuelo_base (codigo_base_origen),
  CONSTRAINT fk_vuelo_avion FOREIGN KEY (matricula) REFERENCES AVION (matricula),
  CONSTRAINT fk_vuelo_base FOREIGN KEY (codigo_base_origen) REFERENCES BASE (codigo_base)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- TRIPULACION: relacion N:M piloto - vuelo, con el rol
CREATE TABLE TRIPULACION (
  documento varchar(15) NOT NULL,
  id_vuelo bigint NOT NULL,
  rol enum('capitan','copiloto') NOT NULL,
  PRIMARY KEY (documento,id_vuelo),
  KEY fk_tripulacion_vuelo (id_vuelo),
  CONSTRAINT fk_tripulacion_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento),
  CONSTRAINT fk_tripulacion_vuelo FOREIGN KEY (id_vuelo) REFERENCES VUELO (id_vuelo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- RESERVA: relacion N:M pasajero - vuelo, con asiento y clase
CREATE TABLE RESERVA (
  documento varchar(15) NOT NULL,
  id_vuelo bigint NOT NULL,
  asiento varchar(4) NOT NULL,
  clase enum('economica','ejecutiva') NOT NULL,
  PRIMARY KEY (documento,id_vuelo),
  UNIQUE KEY uq_reserva_vuelo_asiento (id_vuelo,asiento),
  CONSTRAINT fk_reserva_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento),
  CONSTRAINT fk_reserva_vuelo FOREIGN KEY (id_vuelo) REFERENCES VUELO (id_vuelo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
-- Aeropuerto - Bases de Datos 1
-- 02: insercion de los registros de prueba (64 registros)
-- Todo va en una sola transaccion: si algo falla no queda nada a medias.
-- Ejecutar con un usuario administrador, despues de 01.

USE aeropuerto;

START TRANSACTION;

INSERT INTO BASE (codigo_base, nombre, ciudad, pais) VALUES
('BOG', 'Aeropuerto El Dorado', 'Bogota', 'Colombia'),
('MDE', 'Aeropuerto Jose Maria Cordova', 'Rionegro', 'Colombia'),
('CLO', 'Aeropuerto Alfonso Bonilla Aragon', 'Palmira', 'Colombia');

-- 1040 es piloto y tambien pasajera (tipo 'ambos')
INSERT INTO PERSONA (documento, nombres, apellidos, fecha_nacimiento, tipo_persona,
                     licencia, horas_vuelo, codigo_base, correo, millas) VALUES
('1010', 'Carlos Andres', 'Rojas Perez', '1980-03-12', 'piloto', 'LIC-0451', 12500, 'BOG', NULL, NULL),
('1020', 'Laura Marcela', 'Gomez Ruiz', '1988-07-25', 'piloto', 'LIC-0782', 6800, 'MDE', NULL, NULL),
('1030', 'Andres Felipe', 'Torres Diaz', '1975-11-02', 'piloto', 'LIC-0219', 15200, 'BOG', NULL, NULL),
('1040', 'Sofia Valentina', 'Herrera Mora', '1992-01-18', 'ambos', 'LIC-1033', 2900, 'CLO', 'sofia.herrera@correo.co', 1200),
('2010', 'Mateo', 'Sanchez Castro', '2000-05-30', 'pasajero', NULL, NULL, NULL, 'mateo.sanchez@correo.co', 5400),
('2020', 'Valeria', 'Ramirez Leon', '1997-09-14', 'pasajero', NULL, NULL, NULL, 'valeria.ramirez@correo.co', 800),
('2030', 'Santiago', 'Lopez Vargas', '1985-12-01', 'pasajero', NULL, NULL, NULL, 'santiago.lopez@correo.co', 15300),
('2040', 'Isabella', 'Martinez Gil', '2003-04-22', 'pasajero', NULL, NULL, NULL, 'isabella.martinez@correo.co', 0),
('2050', 'Daniel', 'Ortiz Navarro', '1979-08-08', 'pasajero', NULL, NULL, NULL, 'daniel.ortiz@correo.co', 9100);

INSERT INTO PER_TELEFONO (documento, telefono) VALUES
('1010', '3001112233'), ('1010', '6015550101'),
('1020', '3104445566'),
('1030', '3207778899'),
('1040', '3156667788'), ('1040', '3019990000'),
('2010', '3121234567'),
('2020', '3189876543'),
('2030', '3001239876'), ('2030', '6047771234'),
('2040', '3165554433'),
('2050', '3112223344');

INSERT INTO AVION (matricula, modelo, fabricante, codigo_base) VALUES
('HK-5001', 'A320', 'Airbus', 'BOG'),
('HK-5002', '737-800', 'Boeing', 'MDE'),
('HK-5003', 'ATR 72', 'ATR', 'CLO'),
('HK-6001', '767-300F', 'Boeing', 'BOG'),
('HK-7001', '172', 'Cessna', 'BOG');   -- avion de entrenamiento: no es comercial ni de carga

INSERT INTO AVION_COMERCIAL (matricula, num_asientos) VALUES
('HK-5001', 180), ('HK-5002', 160), ('HK-5003', 70);

INSERT INTO AVION_CARGA (matricula, capacidad_kg) VALUES
('HK-6001', 52000.00);

INSERT INTO VUELO (id_vuelo, codigo, fecha, hora_salida, destino, matricula, codigo_base_origen) VALUES
(1, 'AV101', '2026-11-20', '06:30', 'Cartagena', 'HK-5001', 'BOG'),
(2, 'AV205', '2026-11-20', '09:15', 'Bogota', 'HK-5002', 'MDE'),
(3, 'AV310', '2026-11-21', '14:00', 'Cartagena', 'HK-5003', 'CLO'),
(4, 'AV101', '2026-11-22', '06:30', 'Cartagena', 'HK-5001', 'BOG'),
(5, 'CG900', '2026-11-22', '22:00', 'Miami', 'HK-6001', 'BOG'),
(6, 'AV420', '2026-11-23', '11:45', 'San Andres', 'HK-5002', 'MDE');

INSERT INTO TRIPULACION (documento, id_vuelo, rol) VALUES
('1010', 1, 'capitan'), ('1040', 1, 'copiloto'),
('1020', 2, 'capitan'), ('1030', 2, 'copiloto'),
('1040', 3, 'capitan'), ('1020', 3, 'copiloto'),
('1030', 4, 'capitan'), ('1010', 4, 'copiloto'),
('1030', 5, 'capitan'), ('1010', 5, 'copiloto'),
('1020', 6, 'capitan'), ('1040', 6, 'copiloto');

INSERT INTO RESERVA (documento, id_vuelo, asiento, clase) VALUES
('2010', 1, '12A', 'economica'),
('2010', 3, '5C', 'economica'),
('2010', 4, '14B', 'economica'),
('2020', 1, '2A', 'ejecutiva'),
('2020', 2, '8D', 'economica'),
('2030', 2, '1A', 'ejecutiva'),
('2030', 6, '3B', 'ejecutiva'),
('2040', 3, '20F', 'economica'),
('2040', 6, '22A', 'economica'),
('2050', 1, '15C', 'economica'),
('2050', 3, '9A', 'economica'),
('2050', 4, '2C', 'ejecutiva'),
('1040', 2, '18C', 'economica');

COMMIT;
-- Aeropuerto - Bases de Datos 1
-- 04: restricciones adicionales que salen de los supuestos del enunciado
-- Ejecutar con un usuario administrador, despues de 02.

USE aeropuerto;

-- un piloto (o alguien que es ambos) debe tener licencia, horas y base
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_piloto CHECK (
  tipo_persona = 'pasajero'
  OR (licencia IS NOT NULL AND horas_vuelo IS NOT NULL AND codigo_base IS NOT NULL));

-- quien solo es pasajero no lleva datos de piloto
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_pasajero CHECK (
  tipo_persona <> 'pasajero'
  OR (licencia IS NULL AND horas_vuelo IS NULL AND codigo_base IS NULL));

-- un pasajero (o alguien que es ambos) debe tener correo y millas
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_pasajero CHECK (
  tipo_persona = 'piloto' OR (correo IS NOT NULL AND millas IS NOT NULL));

-- quien solo es piloto no lleva datos de pasajero
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_piloto CHECK (
  tipo_persona <> 'piloto' OR (correo IS NULL AND millas IS NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_horas CHECK (horas_vuelo IS NULL OR horas_vuelo >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_millas CHECK (millas IS NULL OR millas >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_correo CHECK (correo IS NULL OR correo LIKE '%_@_%._%');

ALTER TABLE AVION_COMERCIAL ADD CONSTRAINT ck_avion_comercial_asientos CHECK (num_asientos > 0);
ALTER TABLE AVION_CARGA ADD CONSTRAINT ck_avion_carga_capacidad CHECK (capacidad_kg > 0);

-- el destino no puede quedar vacio
ALTER TABLE VUELO ADD CONSTRAINT ck_vuelo_destino CHECK (CHAR_LENGTH(TRIM(destino)) > 0);

-- un vuelo tiene un solo capitan
ALTER TABLE TRIPULACION ADD COLUMN es_capitan tinyint
  GENERATED ALWAYS AS (IF(rol = 'capitan', 1, NULL)) VIRTUAL;
ALTER TABLE TRIPULACION ADD CONSTRAINT uq_tripulacion_capitan UNIQUE (id_vuelo, es_capitan);

-- resumen de lo que quedo
SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'aeropuerto' AND CONSTRAINT_TYPE IN ('CHECK', 'UNIQUE')
ORDER BY TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME;
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
