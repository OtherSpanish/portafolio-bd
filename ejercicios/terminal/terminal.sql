-- Terminal de transporte - script completo (01 + 02 + 04 + 05). Probado en MySQL 8.0.

-- Terminal de transporte - Bases de Datos 1
-- 01: creacion de la terminal de datos y de las 9 tablas
SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS terminal
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE terminal;

CREATE TABLE TERMINAL (
  codigo_terminal char(3) NOT NULL,
  nombre varchar(80) NOT NULL,
  ciudad varchar(50) NOT NULL,
  pais varchar(50) NOT NULL,
  PRIMARY KEY (codigo_terminal)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE PERSONA (
  documento varchar(15) NOT NULL,
  nombres varchar(50) NOT NULL,
  apellidos varchar(50) NOT NULL,
  fecha_nacimiento date NOT NULL,
  tipo_persona enum('conductor','viajero','ambos') NOT NULL,
  licencia varchar(10) DEFAULT NULL,
  horas_manejo int DEFAULT NULL,
  codigo_terminal char(3) DEFAULT NULL,
  correo varchar(80) DEFAULT NULL,
  puntos int DEFAULT NULL,
  PRIMARY KEY (documento),
  UNIQUE KEY uq_persona_licencia (licencia),
  UNIQUE KEY uq_persona_correo (correo),
  KEY fk_persona_terminal (codigo_terminal),
  CONSTRAINT fk_persona_terminal FOREIGN KEY (codigo_terminal) REFERENCES TERMINAL (codigo_terminal)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE PER_TELEFONO (
  documento varchar(15) NOT NULL,
  telefono varchar(15) NOT NULL,
  PRIMARY KEY (documento,telefono),
  CONSTRAINT fk_per_telefono_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE BUS (
  placa varchar(10) NOT NULL,
  modelo varchar(40) NOT NULL,
  marca varchar(40) NOT NULL,
  codigo_terminal char(3) NOT NULL,
  PRIMARY KEY (placa),
  KEY fk_bus_terminal (codigo_terminal),
  CONSTRAINT fk_bus_terminal FOREIGN KEY (codigo_terminal) REFERENCES TERMINAL (codigo_terminal)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE BUS_PASAJEROS (
  placa varchar(10) NOT NULL,
  num_sillas int NOT NULL,
  PRIMARY KEY (placa),
  CONSTRAINT fk_bus_pasajeros_bus FOREIGN KEY (placa) REFERENCES BUS (placa)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE BUS_CARGA (
  placa varchar(10) NOT NULL,
  capacidad_kg decimal(10,2) NOT NULL,
  PRIMARY KEY (placa),
  CONSTRAINT fk_bus_carga_bus FOREIGN KEY (placa) REFERENCES BUS (placa)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE VIAJE (
  id_viaje bigint NOT NULL AUTO_INCREMENT,
  codigo varchar(8) NOT NULL,
  fecha date NOT NULL,
  hora_salida time NOT NULL,
  destino varchar(50) NOT NULL,
  placa varchar(10) NOT NULL,
  terminal_origen char(3) NOT NULL,
  PRIMARY KEY (id_viaje),
  UNIQUE KEY uq_viaje_codigo_fecha (codigo,fecha),
  KEY fk_viaje_bus (placa),
  KEY fk_viaje_terminal (terminal_origen),
  CONSTRAINT fk_viaje_bus FOREIGN KEY (placa) REFERENCES BUS (placa),
  CONSTRAINT fk_viaje_terminal FOREIGN KEY (terminal_origen) REFERENCES TERMINAL (codigo_terminal)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE CONDUCCION (
  documento varchar(15) NOT NULL,
  id_viaje bigint NOT NULL,
  rol enum('principal','relevo') NOT NULL,
  PRIMARY KEY (documento,id_viaje),
  KEY fk_conduccion_viaje (id_viaje),
  CONSTRAINT fk_conduccion_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento),
  CONSTRAINT fk_conduccion_viaje FOREIGN KEY (id_viaje) REFERENCES VIAJE (id_viaje)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE TIQUETE (
  documento varchar(15) NOT NULL,
  id_viaje bigint NOT NULL,
  silla varchar(4) NOT NULL,
  servicio enum('basico','preferencial') NOT NULL,
  PRIMARY KEY (documento,id_viaje),
  UNIQUE KEY uq_tiquete_viaje_silla (id_viaje,silla),
  CONSTRAINT fk_tiquete_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento),
  CONSTRAINT fk_tiquete_viaje FOREIGN KEY (id_viaje) REFERENCES VIAJE (id_viaje)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Terminal de transporte - Bases de Datos 1
-- 02: registros de prueba (64), en una sola transaccion

USE terminal;



START TRANSACTION;



INSERT INTO TERMINAL (codigo_terminal, nombre, ciudad, pais) VALUES
('BOG', 'Terminal Salitre', 'Bogota', 'Colombia'),
('MED', 'Terminal del Norte', 'Medellin', 'Colombia'),
('BUC', 'Terminal Bucaramanga', 'Bucaramanga', 'Colombia');

INSERT INTO PERSONA (documento, nombres, apellidos, fecha_nacimiento, tipo_persona,
                     licencia, horas_manejo, codigo_terminal, correo, puntos) VALUES
('1010', 'Hector Fabio', 'Rincon Leal', '1980-03-12', 'conductor', 'C2-4410', 21000, 'BOG', NULL, NULL),
('1020', 'Martha Lucia', 'Acosta Vera', '1988-07-25', 'conductor', 'C2-7821', 8400, 'MED', NULL, NULL),
('1030', 'Oscar', 'Guzman Rey', '1975-11-02', 'conductor', 'C3-2190', 30500, 'BOG', NULL, NULL),
('1040', 'Gloria Ines', 'Becerra Sol', '1992-01-18', 'ambos', 'C2-9033', 3900, 'BUC', 'gloria.becerra@correo.co', 200),
('2010', 'Nicolas', 'Pena Franco', '2000-05-30', 'viajero', NULL, NULL, NULL, 'nicolas.pena@correo.co', 640),
('2020', 'Daniela', 'Rivas Ochoa', '1997-09-14', 'viajero', NULL, NULL, NULL, 'daniela.rivas@correo.co', 80),
('2030', 'Julian', 'Montoya Ariza', '1985-12-01', 'viajero', NULL, NULL, NULL, 'julian.montoya@correo.co', 1530),
('2040', 'Sofia', 'Lozano Vega', '2003-04-22', 'viajero', NULL, NULL, NULL, 'sofia.lozano@correo.co', 0),
('2050', 'Camilo', 'Cifuentes Mar', '1979-08-08', 'viajero', NULL, NULL, NULL, 'camilo.cifuentes@correo.co', 910);

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

INSERT INTO BUS (placa, modelo, marca, codigo_terminal) VALUES
('TSX-101', 'Paradiso 1800', 'Marcopolo', 'BOG'),
('WPK-205', 'Volvo B450', 'Volvo', 'MED'),
('ESR-310', 'Andare', 'Busscar', 'BUC'),
('WPK-601', 'FH 540', 'Volvo', 'BOG'),
('TSX-701', 'Sprinter', 'Mercedes', 'BOG');

INSERT INTO BUS_PASAJEROS (placa, num_sillas) VALUES
('TSX-101', 42),
('WPK-205', 46),
('ESR-310', 40);

INSERT INTO BUS_CARGA (placa, capacidad_kg) VALUES
('WPK-601', 18000.00);

INSERT INTO VIAJE (id_viaje, codigo, fecha, hora_salida, destino, placa, terminal_origen) VALUES
(1, 'RT101', '2026-12-20', '06:30', 'Tunja', 'TSX-101', 'BOG'),
(2, 'RT205', '2026-12-20', '09:15', 'Bogota', 'WPK-205', 'MED'),
(3, 'RT310', '2026-12-21', '14:00', 'Tunja', 'ESR-310', 'BUC'),
(4, 'RT101', '2026-12-22', '06:30', 'Tunja', 'TSX-101', 'BOG'),
(5, 'CG900', '2026-12-22', '22:00', 'Cartagena', 'WPK-601', 'BOG'),
(6, 'RT420', '2026-12-23', '11:45', 'Manizales', 'WPK-205', 'MED');

INSERT INTO CONDUCCION (documento, id_viaje, rol) VALUES
('1010', 1, 'principal'),
('1040', 1, 'relevo'),
('1020', 2, 'principal'),
('1030', 2, 'relevo'),
('1040', 3, 'principal'),
('1020', 3, 'relevo'),
('1030', 4, 'principal'),
('1010', 4, 'relevo'),
('1030', 5, 'principal'),
('1010', 5, 'relevo'),
('1020', 6, 'principal'),
('1040', 6, 'relevo');

INSERT INTO TIQUETE (documento, id_viaje, silla, servicio) VALUES
('2010', 1, '12', 'basico'),
('2010', 3, '5', 'basico'),
('2010', 4, '14', 'basico'),
('2020', 1, '2', 'preferencial'),
('2020', 2, '8', 'basico'),
('2030', 2, '1', 'preferencial'),
('2030', 6, '3', 'preferencial'),
('2040', 3, '20', 'basico'),
('2040', 6, '22', 'basico'),
('2050', 1, '15', 'basico'),
('2050', 3, '9', 'basico'),
('2050', 4, '4', 'preferencial'),
('1040', 2, '18', 'basico');



COMMIT;

-- Terminal de transporte - Bases de Datos 1
-- 04: restricciones adicionales de los supuestos
USE terminal;

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_conductor CHECK (
  tipo_persona = 'viajero'
  OR (licencia IS NOT NULL AND horas_manejo IS NOT NULL AND codigo_terminal IS NOT NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_viajero CHECK (
  tipo_persona <> 'viajero'
  OR (licencia IS NULL AND horas_manejo IS NULL AND codigo_terminal IS NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_viajero CHECK (
  tipo_persona = 'conductor' OR (correo IS NOT NULL AND puntos IS NOT NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_conductor CHECK (
  tipo_persona <> 'conductor' OR (correo IS NULL AND puntos IS NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_horas CHECK (horas_manejo IS NULL OR horas_manejo >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_puntos CHECK (puntos IS NULL OR puntos >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_correo CHECK (correo IS NULL OR correo LIKE '%_@_%._%');

ALTER TABLE BUS_PASAJEROS ADD CONSTRAINT ck_bus_pasajeros_asientos CHECK (num_sillas > 0);
ALTER TABLE BUS_CARGA ADD CONSTRAINT ck_bus_carga_capacidad CHECK (capacidad_kg > 0);

ALTER TABLE VIAJE ADD CONSTRAINT ck_viaje_destino CHECK (CHAR_LENGTH(TRIM(destino)) > 0);

ALTER TABLE CONDUCCION ADD COLUMN es_principal tinyint
  GENERATED ALWAYS AS (IF(rol = 'principal', 1, NULL)) VIRTUAL;
ALTER TABLE CONDUCCION ADD CONSTRAINT uq_conduccion_principal UNIQUE (id_viaje, es_principal);

SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'terminal' AND CONSTRAINT_TYPE IN ('CHECK', 'UNIQUE')
ORDER BY TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME;

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
