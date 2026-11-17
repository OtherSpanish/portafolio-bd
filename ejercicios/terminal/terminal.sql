-- Terminal de transporte - script completo (01 + 02 + 04 + 05). Probado en MySQL 8.0.

-- Terminal de transporte - Bases de Datos 1
-- 01: creacion de la base de datos y de las 8 tablas
-- Las tablas van en orden: primero las que no dependen de otras.

SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS terminal
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE terminal;

-- EMPRESA
CREATE TABLE EMPRESA (
  nit varchar(12) NOT NULL,
  razon_social varchar(80) NOT NULL,
  ciudad_sede varchar(50) NOT NULL,
  PRIMARY KEY (nit),
  UNIQUE KEY uq_empresa_razon_social (razon_social)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- BUS
CREATE TABLE BUS (
  placa char(6) NOT NULL,
  marca varchar(30) NOT NULL,
  capacidad int NOT NULL,
  nit varchar(12) NOT NULL,
  PRIMARY KEY (placa),
  CONSTRAINT fk_bus_nit FOREIGN KEY (nit) REFERENCES EMPRESA (nit)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- TERMINAL
CREATE TABLE TERMINAL (
  codigo_terminal char(3) NOT NULL,
  nombre varchar(60) NOT NULL,
  ciudad varchar(50) NOT NULL,
  PRIMARY KEY (codigo_terminal)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- TAQUILLA
CREATE TABLE TAQUILLA (
  nit varchar(12) NOT NULL,
  codigo_terminal char(3) NOT NULL,
  numero_taquilla varchar(6) NOT NULL,
  PRIMARY KEY (nit, codigo_terminal),
  CONSTRAINT fk_taquilla_nit FOREIGN KEY (nit) REFERENCES EMPRESA (nit),
  CONSTRAINT fk_taquilla_codigo_terminal FOREIGN KEY (codigo_terminal) REFERENCES TERMINAL (codigo_terminal)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- PERSONA
CREATE TABLE PERSONA (
  documento varchar(15) NOT NULL,
  nombres varchar(50) NOT NULL,
  apellidos varchar(50) NOT NULL,
  fecha_nacimiento date NOT NULL,
  tipo_persona enum('conductor','viajero','ambos') NOT NULL,
  licencia varchar(12) DEFAULT NULL,
  categoria_licencia char(2) DEFAULT NULL,
  correo varchar(80) DEFAULT NULL,
  nit varchar(12) DEFAULT NULL,
  PRIMARY KEY (documento),
  UNIQUE KEY uq_persona_licencia (licencia),
  UNIQUE KEY uq_persona_correo (correo),
  CONSTRAINT fk_persona_nit FOREIGN KEY (nit) REFERENCES EMPRESA (nit)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- RUTA
CREATE TABLE RUTA (
  codigo_ruta varchar(8) NOT NULL,
  duracion_min int NOT NULL,
  valor decimal(10,2) NOT NULL,
  terminal_origen char(3) NOT NULL,
  terminal_destino char(3) NOT NULL,
  nit varchar(12) NOT NULL,
  PRIMARY KEY (codigo_ruta),
  CONSTRAINT fk_ruta_terminal_origen FOREIGN KEY (terminal_origen) REFERENCES TERMINAL (codigo_terminal),
  CONSTRAINT fk_ruta_terminal_destino FOREIGN KEY (terminal_destino) REFERENCES TERMINAL (codigo_terminal),
  CONSTRAINT fk_ruta_nit FOREIGN KEY (nit) REFERENCES EMPRESA (nit)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- PER_TELEFONO
CREATE TABLE PER_TELEFONO (
  documento varchar(15) NOT NULL,
  telefono varchar(15) NOT NULL,
  PRIMARY KEY (documento, telefono),
  CONSTRAINT fk_per_telefono_documento FOREIGN KEY (documento) REFERENCES PERSONA (documento)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- TIQUETE
CREATE TABLE TIQUETE (
  documento varchar(15) NOT NULL,
  codigo_ruta varchar(8) NOT NULL,
  fecha_viaje date NOT NULL,
  silla int NOT NULL,
  PRIMARY KEY (documento, codigo_ruta, fecha_viaje),
  CONSTRAINT fk_tiquete_documento FOREIGN KEY (documento) REFERENCES PERSONA (documento),
  CONSTRAINT fk_tiquete_codigo_ruta FOREIGN KEY (codigo_ruta) REFERENCES RUTA (codigo_ruta)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Terminal de transporte - Bases de Datos 1
-- 02: registros de prueba, en una sola transaccion

USE terminal;

START TRANSACTION;

INSERT INTO EMPRESA (nit, razon_social, ciudad_sede) VALUES
('860001234', 'Expreso Bolivariano', 'Bogota'),
('890905678', 'Rapido Ochoa', 'Medellin'),
('800204321', 'Coomotor', 'Neiva');

INSERT INTO BUS (placa, marca, capacidad, nit) VALUES
('TSX123', 'Mercedes Benz', 40, '860001234'),
('WMR456', 'Volvo', 42, '890905678'),
('UFT789', 'Chevrolet', 30, '800204321'),
('TSX321', 'Mercedes Benz', 40, '860001234'),
('KLM654', 'Scania', 44, '890905678');

INSERT INTO TERMINAL (codigo_terminal, nombre, ciudad) VALUES
('BOG', 'Terminal Salitre', 'Bogota'),
('MED', 'Terminal del Norte', 'Medellin'),
('TUN', 'Terminal de Tunja', 'Tunja'),
('CAL', 'Terminal de Cali', 'Cali');

INSERT INTO TAQUILLA (nit, codigo_terminal, numero_taquilla) VALUES
('860001234', 'BOG', 'T-12'),
('860001234', 'TUN', 'T-03'),
('860001234', 'CAL', 'T-07'),
('890905678', 'BOG', 'T-20'),
('890905678', 'MED', 'T-01'),
('800204321', 'BOG', 'T-31'),
('800204321', 'CAL', 'T-15');

INSERT INTO PERSONA (documento, nombres, apellidos, fecha_nacimiento, tipo_persona, licencia, categoria_licencia, correo, nit) VALUES
('1010', 'Luis Alberto', 'Gomez Pardo', '1978-02-14', 'conductor', 'LC-55120', 'C2', NULL, '860001234'),
('1020', 'Ramiro', 'Castano Ruiz', '1982-06-30', 'conductor', 'LC-60311', 'C3', NULL, '890905678'),
('1030', 'Wilson', 'Pena Mora', '1975-10-09', 'conductor', 'LC-48877', 'C2', NULL, '800204321'),
('1040', 'Gloria Ines', 'Ramirez Toro', '1986-03-22', 'ambos', 'LC-71002', 'C2', 'gloria.ramirez@correo.co', '860001234'),
('2010', 'Andrea', 'Lozano Diaz', '1999-08-15', 'viajero', NULL, NULL, 'andrea.lozano@correo.co', NULL),
('2020', 'Cristian', 'Mendoza Vela', '1994-01-27', 'viajero', NULL, NULL, 'cristian.mendoza@correo.co', NULL),
('2030', 'Paula', 'Rincon Gil', '2002-05-03', 'viajero', NULL, NULL, 'paula.rincon@correo.co', NULL),
('2040', 'Jaime', 'Ortiz Luna', '1968-11-19', 'viajero', NULL, NULL, 'jaime.ortiz@correo.co', NULL),
('2050', 'Lucia', 'Fajardo Rey', '1990-07-07', 'viajero', NULL, NULL, 'lucia.fajardo@correo.co', NULL);

INSERT INTO RUTA (codigo_ruta, duracion_min, valor, terminal_origen, terminal_destino, nit) VALUES
('BT-01', 180, 38000, 'BOG', 'TUN', '860001234'),
('BM-01', 540, 95000, 'BOG', 'MED', '890905678'),
('BC-01', 600, 110000, 'BOG', 'CAL', '800204321'),
('MB-01', 540, 95000, 'MED', 'BOG', '890905678'),
('TB-01', 180, 38000, 'TUN', 'BOG', '860001234'),
('CB-01', 600, 105000, 'CAL', 'BOG', '860001234');

INSERT INTO PER_TELEFONO (documento, telefono) VALUES
('1010', '3001112222'),
('1010', '6013334444'),
('1020', '3105556666'),
('1030', '3117778888'),
('1040', '3129990000'),
('1040', '6012223333'),
('2010', '3134445555'),
('2010', '6016667777'),
('2020', '3148889999'),
('2030', '3150001111'),
('2040', '3162223333'),
('2050', '3174445555');

INSERT INTO TIQUETE (documento, codigo_ruta, fecha_viaje, silla) VALUES
('2010', 'BT-01', '2026-12-18', 12),
('2010', 'TB-01', '2026-12-22', 5),
('2010', 'BM-01', '2027-01-03', 20),
('2020', 'BT-01', '2026-12-18', 13),
('2030', 'BM-01', '2026-12-19', 7),
('2030', 'MB-01', '2027-01-02', 8),
('2040', 'BC-01', '2026-12-20', 1),
('1040', 'BT-01', '2026-12-18', 30),
('2050', 'BM-01', '2026-12-19', 8),
('2020', 'TB-01', '2026-12-22', 6);

COMMIT;

-- Terminal de transporte - Bases de Datos 1
-- 04: restricciones adicionales de los supuestos

USE terminal;

-- quien es conductor debe tener sus datos
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_conductor CHECK (
  tipo_persona IS NULL OR tipo_persona NOT IN ('conductor', 'ambos') OR (licencia IS NOT NULL AND categoria_licencia IS NOT NULL));

-- quien es viajero debe tener sus datos
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_viajero CHECK (
  tipo_persona IS NULL OR tipo_persona NOT IN ('viajero', 'ambos') OR (correo IS NOT NULL));

-- un conductor (o alguien que es ambos) debe tener empresa
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_empresa CHECK (
  tipo_persona = 'viajero' OR nit IS NOT NULL);

-- una ruta no sale y llega a la misma terminal
ALTER TABLE RUTA ADD CONSTRAINT ck_ruta_terminales CHECK (terminal_origen <> terminal_destino);

-- una silla no se vende dos veces para el mismo viaje
ALTER TABLE TIQUETE ADD CONSTRAINT uq_tiquete_silla UNIQUE (codigo_ruta, fecha_viaje, silla);

-- valores positivos
ALTER TABLE RUTA ADD CONSTRAINT ck_ruta_valor CHECK (valor > 0 AND duracion_min > 0);

-- Terminal de transporte - Bases de Datos 1
-- 05: vistas (consultas guardadas, no guardan datos)

USE terminal;

-- edad es derivado: no se guarda, se calcula
CREATE OR REPLACE VIEW v_persona_edad AS
SELECT x.documento, TIMESTAMPDIFF(YEAR, x.fecha_nacimiento, CURDATE()) AS edad
FROM PERSONA x;
