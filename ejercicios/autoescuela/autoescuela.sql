-- Escuela de conducción - script completo (01 + 02 + 04 + 05). Probado en MySQL 8.0.

-- Escuela de conducción - Bases de Datos 1
-- 01: creacion de la sede de datos y de las 9 tablas
SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS autoescuela
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE autoescuela;

CREATE TABLE SEDE (
  codigo_sede char(3) NOT NULL,
  nombre varchar(80) NOT NULL,
  ciudad varchar(50) NOT NULL,
  pais varchar(50) NOT NULL,
  PRIMARY KEY (codigo_sede)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE PERSONA (
  documento varchar(15) NOT NULL,
  nombres varchar(50) NOT NULL,
  apellidos varchar(50) NOT NULL,
  fecha_nacimiento date NOT NULL,
  tipo_persona enum('instructor','alumno','ambos') NOT NULL,
  licencia varchar(10) DEFAULT NULL,
  horas_instruccion int DEFAULT NULL,
  codigo_sede char(3) DEFAULT NULL,
  correo varchar(80) DEFAULT NULL,
  horas_practica int DEFAULT NULL,
  PRIMARY KEY (documento),
  UNIQUE KEY uq_persona_licencia (licencia),
  UNIQUE KEY uq_persona_correo (correo),
  KEY fk_persona_sede (codigo_sede),
  CONSTRAINT fk_persona_sede FOREIGN KEY (codigo_sede) REFERENCES SEDE (codigo_sede)
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
  codigo_sede char(3) NOT NULL,
  PRIMARY KEY (placa),
  KEY fk_vehiculo_sede (codigo_sede),
  CONSTRAINT fk_vehiculo_sede FOREIGN KEY (codigo_sede) REFERENCES SEDE (codigo_sede)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE CARRO (
  placa varchar(10) NOT NULL,
  num_puertas int NOT NULL,
  PRIMARY KEY (placa),
  CONSTRAINT fk_carro_vehiculo FOREIGN KEY (placa) REFERENCES VEHICULO (placa)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE MOTO (
  placa varchar(10) NOT NULL,
  cilindraje_cc decimal(10,2) NOT NULL,
  PRIMARY KEY (placa),
  CONSTRAINT fk_moto_vehiculo FOREIGN KEY (placa) REFERENCES VEHICULO (placa)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE PRACTICA (
  id_practica bigint NOT NULL AUTO_INCREMENT,
  codigo varchar(8) NOT NULL,
  fecha date NOT NULL,
  hora_inicio time NOT NULL,
  recorrido varchar(50) NOT NULL,
  placa varchar(10) NOT NULL,
  sede_practica char(3) NOT NULL,
  PRIMARY KEY (id_practica),
  UNIQUE KEY uq_practica_codigo_fecha (codigo,fecha),
  KEY fk_practica_vehiculo (placa),
  KEY fk_practica_sede (sede_practica),
  CONSTRAINT fk_practica_vehiculo FOREIGN KEY (placa) REFERENCES VEHICULO (placa),
  CONSTRAINT fk_practica_sede FOREIGN KEY (sede_practica) REFERENCES SEDE (codigo_sede)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE INSTRUCCION (
  documento varchar(15) NOT NULL,
  id_practica bigint NOT NULL,
  rol enum('principal','apoyo') NOT NULL,
  PRIMARY KEY (documento,id_practica),
  KEY fk_instruccion_practica (id_practica),
  CONSTRAINT fk_instruccion_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento),
  CONSTRAINT fk_instruccion_practica FOREIGN KEY (id_practica) REFERENCES PRACTICA (id_practica)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE INSCRIPCION (
  documento varchar(15) NOT NULL,
  id_practica bigint NOT NULL,
  turno varchar(4) NOT NULL,
  nivel enum('basico','avanzado') NOT NULL,
  PRIMARY KEY (documento,id_practica),
  UNIQUE KEY uq_inscripcion_practica_turno (id_practica,turno),
  CONSTRAINT fk_inscripcion_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento),
  CONSTRAINT fk_inscripcion_practica FOREIGN KEY (id_practica) REFERENCES PRACTICA (id_practica)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Escuela de conducción - Bases de Datos 1
-- 02: registros de prueba (64), en una sola transaccion

USE autoescuela;



START TRANSACTION;



INSERT INTO SEDE (codigo_sede, nombre, ciudad, pais) VALUES
('BOG', 'Sede Suba', 'Bogota', 'Colombia'),
('MED', 'Sede Belen', 'Medellin', 'Colombia'),
('BUC', 'Sede Cabecera', 'Bucaramanga', 'Colombia');

INSERT INTO PERSONA (documento, nombres, apellidos, fecha_nacimiento, tipo_persona,
                     licencia, horas_instruccion, codigo_sede, correo, horas_practica) VALUES
('1010', 'Wilson', 'Ardila Mora', '1980-03-12', 'instructor', 'INS-3301', 8400, 'BOG', NULL, NULL),
('1020', 'Claudia', 'Benavides Paz', '1988-07-25', 'instructor', 'INS-4472', 3100, 'MED', NULL, NULL),
('1030', 'Rafael', 'Contreras Gil', '1975-11-02', 'instructor', 'INS-2208', 12000, 'BOG', NULL, NULL),
('1040', 'Angela Maria', 'Rendon Cruz', '1992-01-18', 'ambos', 'INS-5019', 1500, 'BUC', 'angela.rendon@correo.co', 12),
('2010', 'Santiago', 'Uribe Lara', '2000-05-30', 'alumno', NULL, NULL, NULL, 'santiago.uribe@correo.co', 20),
('2020', 'Melissa', 'Torres Rey', '1997-09-14', 'alumno', NULL, NULL, NULL, 'melissa.torres@correo.co', 6),
('2030', 'Cristian', 'Galvis Soto', '1985-12-01', 'alumno', NULL, NULL, NULL, 'cristian.galvis@correo.co', 18),
('2040', 'Juliana', 'Pineda Mejia', '2003-04-22', 'alumno', NULL, NULL, NULL, 'juliana.pineda@correo.co', 2),
('2050', 'Orlando', 'Bernal Rojas', '1979-08-08', 'alumno', NULL, NULL, NULL, 'orlando.bernal@correo.co', 25);

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

INSERT INTO VEHICULO (placa, modelo, marca, codigo_sede) VALUES
('ABC-101', 'Spark', 'Chevrolet', 'BOG'),
('XYZ-205', 'Logan', 'Renault', 'MED'),
('DEF-310', 'Picanto', 'Kia', 'BUC'),
('MTO-11F', 'NKD 125', 'AKT', 'BOG'),
('TRK-701', 'NHR', 'Chevrolet', 'BOG');

INSERT INTO CARRO (placa, num_puertas) VALUES
('ABC-101', 5),
('XYZ-205', 4),
('DEF-310', 5);

INSERT INTO MOTO (placa, cilindraje_cc) VALUES
('MTO-11F', 125.00);

INSERT INTO PRACTICA (id_practica, codigo, fecha, hora_inicio, recorrido, placa, sede_practica) VALUES
(1, 'URB01', '2026-12-01', '07:00', 'Ruta urbana', 'ABC-101', 'BOG'),
(2, 'PAR02', '2026-12-01', '08:00', 'Parqueo', 'XYZ-205', 'MED'),
(3, 'URB03', '2026-12-02', '07:00', 'Ruta urbana', 'DEF-310', 'BUC'),
(4, 'URB01', '2026-12-03', '07:00', 'Ruta urbana', 'ABC-101', 'BOG'),
(5, 'MOT05', '2026-12-03', '15:00', 'Circuito motos', 'MTO-11F', 'BOG'),
(6, 'CAR06', '2026-12-04', '06:00', 'Carretera', 'XYZ-205', 'MED');

INSERT INTO INSTRUCCION (documento, id_practica, rol) VALUES
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

INSERT INTO INSCRIPCION (documento, id_practica, turno, nivel) VALUES
('2010', 1, '12', 'basico'),
('2010', 3, '5', 'basico'),
('2010', 4, '14', 'basico'),
('2020', 1, '2', 'avanzado'),
('2020', 2, '8', 'basico'),
('2030', 2, '1', 'avanzado'),
('2030', 6, '3', 'avanzado'),
('2040', 3, '20', 'basico'),
('2040', 6, '22', 'basico'),
('2050', 1, '15', 'basico'),
('2050', 3, '9', 'basico'),
('2050', 4, '4', 'avanzado'),
('1040', 2, '18', 'basico');



COMMIT;

-- Escuela de conducción - Bases de Datos 1
-- 04: restricciones adicionales de los supuestos
USE autoescuela;

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_instructor CHECK (
  tipo_persona = 'alumno'
  OR (licencia IS NOT NULL AND horas_instruccion IS NOT NULL AND codigo_sede IS NOT NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_alumno CHECK (
  tipo_persona <> 'alumno'
  OR (licencia IS NULL AND horas_instruccion IS NULL AND codigo_sede IS NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_alumno CHECK (
  tipo_persona = 'instructor' OR (correo IS NOT NULL AND horas_practica IS NOT NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_instructor CHECK (
  tipo_persona <> 'instructor' OR (correo IS NULL AND horas_practica IS NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_horas CHECK (horas_instruccion IS NULL OR horas_instruccion >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_horas_practica CHECK (horas_practica IS NULL OR horas_practica >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_correo CHECK (correo IS NULL OR correo LIKE '%_@_%._%');

ALTER TABLE CARRO ADD CONSTRAINT ck_carro_asientos CHECK (num_puertas > 0);
ALTER TABLE MOTO ADD CONSTRAINT ck_moto_capacidad CHECK (cilindraje_cc > 0);

ALTER TABLE PRACTICA ADD CONSTRAINT ck_practica_recorrido CHECK (CHAR_LENGTH(TRIM(recorrido)) > 0);

ALTER TABLE INSTRUCCION ADD COLUMN es_principal tinyint
  GENERATED ALWAYS AS (IF(rol = 'principal', 1, NULL)) VIRTUAL;
ALTER TABLE INSTRUCCION ADD CONSTRAINT uq_instruccion_principal UNIQUE (id_practica, es_principal);

SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'autoescuela' AND CONSTRAINT_TYPE IN ('CHECK', 'UNIQUE')
ORDER BY TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME;

-- Escuela de conducción - Bases de Datos 1
-- 05: vistas
USE autoescuela;

CREATE OR REPLACE VIEW v_persona_edad AS
SELECT p.documento, p.nombres, p.apellidos, p.tipo_persona, p.fecha_nacimiento,
       TIMESTAMPDIFF(YEAR, p.fecha_nacimiento, CURDATE()) AS edad
FROM PERSONA p;

CREATE OR REPLACE VIEW v_tipo_vehiculo AS
SELECT a.placa, a.marca, a.modelo, a.codigo_sede,
       CASE
         WHEN c.placa IS NOT NULL THEN 'carro'
         WHEN g.placa IS NOT NULL THEN 'moto'
         ELSE 'otro'
       END AS tipo,
       c.num_puertas, g.cilindraje_cc
FROM VEHICULO a
LEFT JOIN CARRO c ON c.placa = a.placa
LEFT JOIN MOTO g ON g.placa = a.placa;

CREATE OR REPLACE VIEW v_instruccion_practica AS
SELECT v.id_practica, v.codigo, v.fecha, v.recorrido, t.rol,
       p.documento, p.nombres, p.apellidos
FROM INSTRUCCION t
JOIN PRACTICA v ON v.id_practica = t.id_practica
JOIN PERSONA p ON p.documento = t.documento;

CREATE OR REPLACE VIEW v_ocupacion_practica AS
SELECT v.id_practica, v.codigo, v.fecha, v.recorrido, c.num_puertas,
       COUNT(r.documento) AS ocupados,
       ROUND(100 * COUNT(r.documento) / c.num_puertas, 2) AS porcentaje
FROM PRACTICA v
JOIN CARRO c ON c.placa = v.placa
LEFT JOIN INSCRIPCION r ON r.id_practica = v.id_practica
GROUP BY v.id_practica, v.codigo, v.fecha, v.recorrido, c.num_puertas;

SELECT * FROM v_tipo_vehiculo;
SELECT * FROM v_ocupacion_practica ORDER BY id_practica;
