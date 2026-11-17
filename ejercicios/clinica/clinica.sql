-- Clínica - script completo (01 + 02 + 04 + 05). Probado en MySQL 8.0.

-- Clínica - Bases de Datos 1
-- 01: creacion de la base de datos y de las 12 tablas
-- Las tablas van en orden: primero las que no dependen de otras.

SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS clinica
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE clinica;

-- EPS
CREATE TABLE EPS (
  nit_eps varchar(12) NOT NULL,
  nombre varchar(60) NOT NULL,
  PRIMARY KEY (nit_eps),
  UNIQUE KEY uq_eps_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- PACIENTE
CREATE TABLE PACIENTE (
  documento varchar(15) NOT NULL,
  nombres varchar(50) NOT NULL,
  apellidos varchar(50) NOT NULL,
  fecha_nacimiento date NOT NULL,
  tipo_sangre varchar(3) NOT NULL,
  nit_eps varchar(12) NOT NULL,
  PRIMARY KEY (documento),
  CONSTRAINT fk_paciente_nit_eps FOREIGN KEY (nit_eps) REFERENCES EPS (nit_eps)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ESPECIALIDAD
CREATE TABLE ESPECIALIDAD (
  id_especialidad int NOT NULL,
  nombre varchar(50) NOT NULL,
  PRIMARY KEY (id_especialidad),
  UNIQUE KEY uq_especialidad_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- MEDICAMENTO
CREATE TABLE MEDICAMENTO (
  codigo_medicamento varchar(10) NOT NULL,
  nombre varchar(60) NOT NULL,
  presentacion varchar(40) NOT NULL,
  PRIMARY KEY (codigo_medicamento)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- MEDICO
CREATE TABLE MEDICO (
  id_medico varchar(15) NOT NULL,
  nombres varchar(50) NOT NULL,
  apellidos varchar(50) NOT NULL,
  registro_medico varchar(12) NOT NULL,
  id_especialidad int NOT NULL,
  PRIMARY KEY (id_medico),
  UNIQUE KEY uq_medico_registro_medico (registro_medico),
  CONSTRAINT fk_medico_id_especialidad FOREIGN KEY (id_especialidad) REFERENCES ESPECIALIDAD (id_especialidad)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- SEDE
CREATE TABLE SEDE (
  codigo_sede char(3) NOT NULL,
  nombre varchar(60) NOT NULL,
  direccion varchar(80) NOT NULL,
  PRIMARY KEY (codigo_sede)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- PAC_TELEFONO
CREATE TABLE PAC_TELEFONO (
  documento varchar(15) NOT NULL,
  telefono varchar(15) NOT NULL,
  PRIMARY KEY (documento, telefono),
  CONSTRAINT fk_pac_telefono_documento FOREIGN KEY (documento) REFERENCES PACIENTE (documento)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- TURNO
CREATE TABLE TURNO (
  id_medico varchar(15) NOT NULL,
  codigo_sede char(3) NOT NULL,
  dia varchar(10) NOT NULL,
  PRIMARY KEY (id_medico, codigo_sede, dia),
  CONSTRAINT fk_turno_id_medico FOREIGN KEY (id_medico) REFERENCES MEDICO (id_medico),
  CONSTRAINT fk_turno_codigo_sede FOREIGN KEY (codigo_sede) REFERENCES SEDE (codigo_sede)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- CITA
CREATE TABLE CITA (
  id_cita int NOT NULL,
  fecha date NOT NULL,
  hora time NOT NULL,
  motivo varchar(80) NOT NULL,
  documento varchar(15) NOT NULL,
  id_medico varchar(15) NOT NULL,
  PRIMARY KEY (id_cita),
  CONSTRAINT fk_cita_documento FOREIGN KEY (documento) REFERENCES PACIENTE (documento),
  CONSTRAINT fk_cita_id_medico FOREIGN KEY (id_medico) REFERENCES MEDICO (id_medico)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- PRESENCIAL
CREATE TABLE PRESENCIAL (
  id_cita int NOT NULL,
  consultorio varchar(10) NOT NULL,
  codigo_sede char(3) NOT NULL,
  PRIMARY KEY (id_cita),
  CONSTRAINT fk_presencial_id_cita FOREIGN KEY (id_cita) REFERENCES CITA (id_cita)
    ON DELETE CASCADE,
  CONSTRAINT fk_presencial_codigo_sede FOREIGN KEY (codigo_sede) REFERENCES SEDE (codigo_sede)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- TELECONSULTA
CREATE TABLE TELECONSULTA (
  id_cita int NOT NULL,
  enlace varchar(120) NOT NULL,
  plataforma varchar(20) NOT NULL,
  PRIMARY KEY (id_cita),
  CONSTRAINT fk_teleconsulta_id_cita FOREIGN KEY (id_cita) REFERENCES CITA (id_cita)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- FORMULA
CREATE TABLE FORMULA (
  id_cita int NOT NULL,
  codigo_medicamento varchar(10) NOT NULL,
  dosis varchar(60) NOT NULL,
  PRIMARY KEY (id_cita, codigo_medicamento),
  CONSTRAINT fk_formula_id_cita FOREIGN KEY (id_cita) REFERENCES CITA (id_cita),
  CONSTRAINT fk_formula_codigo_medicamento FOREIGN KEY (codigo_medicamento) REFERENCES MEDICAMENTO (codigo_medicamento)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Clínica - Bases de Datos 1
-- 02: registros de prueba, en una sola transaccion

USE clinica;

START TRANSACTION;

INSERT INTO EPS (nit_eps, nombre) VALUES
('900156264', 'Nueva EPS'),
('800251440', 'Sanitas'),
('830003564', 'Famisanar');

INSERT INTO PACIENTE (documento, nombres, apellidos, fecha_nacimiento, tipo_sangre, nit_eps) VALUES
('7010', 'Rosa Elena', 'Patino Gil', '1958-05-12', 'O+', '900156264'),
('7020', 'Kevin', 'Zapata Ruiz', '1999-09-30', 'A+', '800251440'),
('7030', 'Gladys', 'Cifuentes Mora', '1971-01-21', 'B-', '830003564'),
('7040', 'Mateo', 'Quintana Lara', '1988-11-05', 'O-', '900156264'),
('7050', 'Liliana', 'Bohorquez Paz', '1993-04-17', 'AB+', '800251440'),
('7060', 'Arturo', 'Velandia Rey', '1949-08-08', 'O+', '830003564');

INSERT INTO ESPECIALIDAD (id_especialidad, nombre) VALUES
(1, 'Medicina general'),
(2, 'Pediatria'),
(3, 'Cardiologia'),
(4, 'Dermatologia');

INSERT INTO MEDICAMENTO (codigo_medicamento, nombre, presentacion) VALUES
('MED-001', 'Acetaminofen', 'tabletas 500 mg'),
('MED-002', 'Losartan', 'tabletas 50 mg'),
('MED-003', 'Amoxicilina', 'capsulas 500 mg'),
('MED-004', 'Hidrocortisona', 'crema 1%'),
('MED-005', 'Loratadina', 'tabletas 10 mg'),
('MED-006', 'Ibuprofeno', 'tabletas 400 mg');

INSERT INTO MEDICO (id_medico, nombres, apellidos, registro_medico, id_especialidad) VALUES
('M01', 'Adriana', 'Lopez Mejia', 'RM-24051', 1),
('M02', 'Fabio', 'Sandoval Ortiz', 'RM-31882', 3),
('M03', 'Claudia', 'Rivas Toro', 'RM-18190', 1),
('M04', 'Esteban', 'Mora Quintero', 'RM-40233', 4);

INSERT INTO SEDE (codigo_sede, nombre, direccion) VALUES
('NOR', 'Sede Norte', 'Cll 134 # 7-83'),
('CEN', 'Sede Centro', 'Cra 7 # 22-15'),
('SUR', 'Sede Sur', 'Av 1 de Mayo # 52-20');

INSERT INTO PAC_TELEFONO (documento, telefono) VALUES
('7010', '3101234567'),
('7010', '6012345601'),
('7020', '3112345678'),
('7030', '3123456789'),
('7030', '6013456702'),
('7040', '3134567890'),
('7050', '3145678901'),
('7060', '3156789012');

INSERT INTO TURNO (id_medico, codigo_sede, dia) VALUES
('M01', 'NOR', 'lunes'),
('M01', 'NOR', 'miercoles'),
('M01', 'CEN', 'viernes'),
('M02', 'NOR', 'martes'),
('M02', 'SUR', 'jueves'),
('M03', 'CEN', 'lunes'),
('M03', 'SUR', 'martes'),
('M04', 'CEN', 'miercoles');

INSERT INTO CITA (id_cita, fecha, hora, motivo, documento, id_medico) VALUES
(1, '2026-11-20', '08:00', 'control de presion', '7010', 'M02'),
(2, '2026-11-20', '09:00', 'dolor de garganta', '7020', 'M01'),
(3, '2026-11-21', '10:30', 'revision de lunar', '7030', 'M04'),
(4, '2026-11-23', '07:30', 'control general', '7010', 'M01'),
(5, '2026-11-23', '11:00', 'dolor en el pecho', '7060', 'M02'),
(6, '2026-11-24', '15:00', 'alergia', '7050', 'M03'),
(7, '2026-11-25', '09:30', 'control de presion', '7010', 'M02'),
(8, '2026-11-25', '16:00', 'fiebre', '7040', 'M03');

INSERT INTO PRESENCIAL (id_cita, consultorio, codigo_sede) VALUES
(1, 'C-201', 'NOR'),
(3, 'C-105', 'CEN'),
(4, 'C-110', 'NOR'),
(5, 'C-201', 'NOR'),
(7, 'C-202', 'SUR');

INSERT INTO TELECONSULTA (id_cita, enlace, plataforma) VALUES
(2, 'https://meet.clinica.co/a12', 'Meet'),
(6, 'https://teams.clinica.co/b34', 'Teams'),
(8, 'https://meet.clinica.co/c56', 'Meet');

INSERT INTO FORMULA (id_cita, codigo_medicamento, dosis) VALUES
(1, 'MED-002', '1 tableta cada 12 horas'),
(2, 'MED-003', '1 capsula cada 8 horas por 7 dias'),
(2, 'MED-001', '1 tableta cada 6 horas si hay fiebre'),
(3, 'MED-004', 'aplicar 2 veces al dia'),
(5, 'MED-002', '1 tableta cada 12 horas'),
(5, 'MED-001', '1 tableta cada 8 horas'),
(6, 'MED-005', '1 tableta diaria'),
(8, 'MED-001', '1 tableta cada 6 horas');

COMMIT;

-- Clínica - Bases de Datos 1
-- 04: restricciones adicionales de los supuestos

USE clinica;

-- tipo de sangre valido
ALTER TABLE PACIENTE ADD CONSTRAINT ck_paciente_sangre CHECK (tipo_sangre IN ('O+','O-','A+','A-','B+','B-','AB+','AB-'));

-- un medico no tiene dos citas a la misma hora
ALTER TABLE CITA ADD CONSTRAINT uq_cita_medico_hora UNIQUE (id_medico, fecha, hora);

-- dias validos del turno
ALTER TABLE TURNO ADD CONSTRAINT ck_turno_dia CHECK (dia IN ('lunes','martes','miercoles','jueves','viernes','sabado'));

-- Clínica - Bases de Datos 1
-- 05: vistas (consultas guardadas, no guardan datos)

USE clinica;

-- edad es derivado: no se guarda, se calcula
CREATE OR REPLACE VIEW v_paciente_edad AS
SELECT x.documento, TIMESTAMPDIFF(YEAR, x.fecha_nacimiento, CURDATE()) AS edad
FROM PACIENTE x;

-- a qué subtipo pertenece cada cita
CREATE OR REPLACE VIEW v_tipo_cita AS
SELECT x.id_cita,
       CASE
         WHEN s0.id_cita IS NOT NULL THEN 'presencial'
         WHEN s1.id_cita IS NOT NULL THEN 'teleconsulta'
         ELSE 'ninguno'
       END AS tipo
FROM CITA x
LEFT JOIN PRESENCIAL s0 ON s0.id_cita = x.id_cita
LEFT JOIN TELECONSULTA s1 ON s1.id_cita = x.id_cita;
