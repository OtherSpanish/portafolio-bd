-- Agencia de turismo - script completo (01 + 02 + 04 + 05). Probado en MySQL 8.0.

-- Agencia de turismo - Bases de Datos 1
-- 01: creacion de la oficina de datos y de las 9 tablas
SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS turismo
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE turismo;

CREATE TABLE OFICINA (
  codigo_oficina char(3) NOT NULL,
  nombre varchar(80) NOT NULL,
  ciudad varchar(50) NOT NULL,
  pais varchar(50) NOT NULL,
  PRIMARY KEY (codigo_oficina)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE PERSONA (
  documento varchar(15) NOT NULL,
  nombres varchar(50) NOT NULL,
  apellidos varchar(50) NOT NULL,
  fecha_nacimiento date NOT NULL,
  tipo_persona enum('guia','turista','ambos') NOT NULL,
  registro_rnt varchar(10) DEFAULT NULL,
  anios_experiencia int DEFAULT NULL,
  codigo_oficina char(3) DEFAULT NULL,
  correo varchar(80) DEFAULT NULL,
  puntos int DEFAULT NULL,
  PRIMARY KEY (documento),
  UNIQUE KEY uq_persona_registro_rnt (registro_rnt),
  UNIQUE KEY uq_persona_correo (correo),
  KEY fk_persona_oficina (codigo_oficina),
  CONSTRAINT fk_persona_oficina FOREIGN KEY (codigo_oficina) REFERENCES OFICINA (codigo_oficina)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE PER_TELEFONO (
  documento varchar(15) NOT NULL,
  telefono varchar(15) NOT NULL,
  PRIMARY KEY (documento,telefono),
  CONSTRAINT fk_per_telefono_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE VEHICULO (
  placa varchar(10) NOT NULL,
  modelo varchar(40) NOT NULL,
  marca varchar(40) NOT NULL,
  codigo_oficina char(3) NOT NULL,
  PRIMARY KEY (placa),
  KEY fk_vehiculo_oficina (codigo_oficina),
  CONSTRAINT fk_vehiculo_oficina FOREIGN KEY (codigo_oficina) REFERENCES OFICINA (codigo_oficina)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE BUSETA (
  placa varchar(10) NOT NULL,
  num_sillas int NOT NULL,
  PRIMARY KEY (placa),
  CONSTRAINT fk_buseta_vehiculo FOREIGN KEY (placa) REFERENCES VEHICULO (placa)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE LANCHA (
  placa varchar(10) NOT NULL,
  eslora_m decimal(10,2) NOT NULL,
  PRIMARY KEY (placa),
  CONSTRAINT fk_lancha_vehiculo FOREIGN KEY (placa) REFERENCES VEHICULO (placa)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE TOUR (
  id_tour bigint NOT NULL AUTO_INCREMENT,
  codigo varchar(8) NOT NULL,
  fecha date NOT NULL,
  hora_salida time NOT NULL,
  destino varchar(50) NOT NULL,
  placa varchar(10) NOT NULL,
  oficina_tour char(3) NOT NULL,
  PRIMARY KEY (id_tour),
  UNIQUE KEY uq_tour_codigo_fecha (codigo,fecha),
  KEY fk_tour_vehiculo (placa),
  KEY fk_tour_oficina (oficina_tour),
  CONSTRAINT fk_tour_vehiculo FOREIGN KEY (placa) REFERENCES VEHICULO (placa),
  CONSTRAINT fk_tour_oficina FOREIGN KEY (oficina_tour) REFERENCES OFICINA (codigo_oficina)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE GUIANZA (
  documento varchar(15) NOT NULL,
  id_tour bigint NOT NULL,
  rol enum('principal','apoyo') NOT NULL,
  PRIMARY KEY (documento,id_tour),
  KEY fk_guianza_tour (id_tour),
  CONSTRAINT fk_guianza_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento),
  CONSTRAINT fk_guianza_tour FOREIGN KEY (id_tour) REFERENCES TOUR (id_tour)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE RESERVA (
  documento varchar(15) NOT NULL,
  id_tour bigint NOT NULL,
  silla varchar(4) NOT NULL,
  plan enum('basico','premium') NOT NULL,
  PRIMARY KEY (documento,id_tour),
  UNIQUE KEY uq_reserva_tour_silla (id_tour,silla),
  CONSTRAINT fk_reserva_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento),
  CONSTRAINT fk_reserva_tour FOREIGN KEY (id_tour) REFERENCES TOUR (id_tour)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Agencia de turismo - Bases de Datos 1
-- 02: registros de prueba (64), en una sola transaccion

USE turismo;



START TRANSACTION;



INSERT INTO OFICINA (codigo_oficina, nombre, ciudad, pais) VALUES
('SMR', 'Oficina Rodadero', 'Santa Marta', 'Colombia'),
('BOG', 'Oficina Centro', 'Bogota', 'Colombia'),
('CTG', 'Oficina Bocagrande', 'Cartagena', 'Colombia');

INSERT INTO PERSONA (documento, nombres, apellidos, fecha_nacimiento, tipo_persona,
                     registro_rnt, anios_experiencia, codigo_oficina, correo, puntos) VALUES
('1010', 'Mauricio', 'Aguilar Pena', '1980-03-12', 'guia', 'RNT-1201', 12, 'SMR', NULL, NULL),
('1020', 'Viviana', 'Castro Lugo', '1988-07-25', 'guia', 'RNT-1388', 7, 'BOG', NULL, NULL),
('1030', 'Fernando', 'Ibarra Nieto', '1975-11-02', 'guia', 'RNT-0975', 20, 'SMR', NULL, NULL),
('1040', 'Lina Marcela', 'Barrera Soto', '1992-01-18', 'ambos', 'RNT-1590', 3, 'CTG', 'lina.barrera@correo.co', 300),
('2010', 'Kevin', 'Moreno Toro', '2000-05-30', 'turista', NULL, NULL, NULL, 'kevin.moreno@correo.co', 900),
('2020', 'Adriana', 'Leal Ortiz', '1997-09-14', 'turista', NULL, NULL, NULL, 'adriana.leal@correo.co', 150),
('2030', 'Samuel', 'Velasquez Rey', '1985-12-01', 'turista', NULL, NULL, NULL, 'samuel.velasquez@correo.co', 2100),
('2040', 'Paula', 'Jimenez Cruz', '2003-04-22', 'turista', NULL, NULL, NULL, 'paula.jimenez@correo.co', 0),
('2050', 'Hernan', 'Quiroga Paz', '1979-08-08', 'turista', NULL, NULL, NULL, 'hernan.quiroga@correo.co', 1250);

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

INSERT INTO VEHICULO (placa, modelo, marca, codigo_oficina) VALUES
('TUR-101', 'Sprinter', 'Mercedes', 'SMR'),
('TUR-205', 'H350', 'Hyundai', 'BOG'),
('TUR-310', 'Urvan', 'Nissan', 'CTG'),
('LAN-601', 'Bravo 34', 'Yamaha', 'SMR'),
('TUR-701', 'Vito', 'Mercedes', 'SMR');

INSERT INTO BUSETA (placa, num_sillas) VALUES
('TUR-101', 19),
('TUR-205', 16),
('TUR-310', 15);

INSERT INTO LANCHA (placa, eslora_m) VALUES
('LAN-601', 10.40);

INSERT INTO TOUR (id_tour, codigo, fecha, hora_salida, destino, placa, oficina_tour) VALUES
(1, 'TAY01', '2026-12-10', '06:00', 'Tayrona', 'TUR-101', 'SMR'),
(2, 'ZIP02', '2026-12-10', '07:00', 'Zipaquira', 'TUR-205', 'BOG'),
(3, 'TAY03', '2026-12-11', '05:00', 'Tayrona', 'TUR-310', 'CTG'),
(4, 'TAY01', '2026-12-12', '06:00', 'Tayrona', 'TUR-101', 'SMR'),
(5, 'BAH05', '2026-12-12', '09:00', 'Bahia Concha', 'LAN-601', 'SMR'),
(6, 'GUA06', '2026-12-13', '08:00', 'Guatavita', 'TUR-205', 'BOG');

INSERT INTO GUIANZA (documento, id_tour, rol) VALUES
('1010', 1, 'principal'),
('1040', 1, 'apoyo'),
('1020', 2, 'principal'),
('1030', 2, 'apoyo'),
('1040', 3, 'principal'),
('1020', 3, 'apoyo'),
('1030', 4, 'principal'),
('1010', 4, 'apoyo'),
('1030', 5, 'principal'),
('1010', 5, 'apoyo'),
('1020', 6, 'principal'),
('1040', 6, 'apoyo');

INSERT INTO RESERVA (documento, id_tour, silla, plan) VALUES
('2010', 1, '12', 'basico'),
('2010', 3, '5', 'basico'),
('2010', 4, '14', 'basico'),
('2020', 1, '2', 'premium'),
('2020', 2, '8', 'basico'),
('2030', 2, '1', 'premium'),
('2030', 6, '3', 'premium'),
('2040', 3, '20', 'basico'),
('2040', 6, '22', 'basico'),
('2050', 1, '15', 'basico'),
('2050', 3, '9', 'basico'),
('2050', 4, '4', 'premium'),
('1040', 2, '18', 'basico');



COMMIT;

-- Agencia de turismo - Bases de Datos 1
-- 04: restricciones adicionales de los supuestos
USE turismo;

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_guia CHECK (
  tipo_persona = 'turista'
  OR (registro_rnt IS NOT NULL AND anios_experiencia IS NOT NULL AND codigo_oficina IS NOT NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_turista CHECK (
  tipo_persona <> 'turista'
  OR (registro_rnt IS NULL AND anios_experiencia IS NULL AND codigo_oficina IS NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_turista CHECK (
  tipo_persona = 'guia' OR (correo IS NOT NULL AND puntos IS NOT NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_guia CHECK (
  tipo_persona <> 'guia' OR (correo IS NULL AND puntos IS NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_horas CHECK (anios_experiencia IS NULL OR anios_experiencia >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_puntos CHECK (puntos IS NULL OR puntos >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_correo CHECK (correo IS NULL OR correo LIKE '%_@_%._%');

ALTER TABLE BUSETA ADD CONSTRAINT ck_buseta_asientos CHECK (num_sillas > 0);
ALTER TABLE LANCHA ADD CONSTRAINT ck_lancha_capacidad CHECK (eslora_m > 0);

ALTER TABLE TOUR ADD CONSTRAINT ck_tour_destino CHECK (CHAR_LENGTH(TRIM(destino)) > 0);

ALTER TABLE GUIANZA ADD COLUMN es_principal tinyint
  GENERATED ALWAYS AS (IF(rol = 'principal', 1, NULL)) VIRTUAL;
ALTER TABLE GUIANZA ADD CONSTRAINT uq_guianza_principal UNIQUE (id_tour, es_principal);

SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'turismo' AND CONSTRAINT_TYPE IN ('CHECK', 'UNIQUE')
ORDER BY TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME;

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
