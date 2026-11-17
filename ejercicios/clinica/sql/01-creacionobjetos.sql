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
