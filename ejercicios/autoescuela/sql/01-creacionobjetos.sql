-- Escuela de conducción - Bases de Datos 1
-- 01: creacion de la base de datos y de las 11 tablas
-- Las tablas van en orden: primero las que no dependen de otras.

SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS autoescuela
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE autoescuela;

-- SEDE
CREATE TABLE SEDE (
  codigo_sede char(3) NOT NULL,
  nombre varchar(60) NOT NULL,
  direccion varchar(80) NOT NULL,
  PRIMARY KEY (codigo_sede)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- CURSO
CREATE TABLE CURSO (
  codigo_curso char(2) NOT NULL,
  nombre varchar(60) NOT NULL,
  horas_teoria int NOT NULL,
  horas_practica int NOT NULL,
  PRIMARY KEY (codigo_curso)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ALUMNO
CREATE TABLE ALUMNO (
  documento varchar(15) NOT NULL,
  nombres varchar(50) NOT NULL,
  apellidos varchar(50) NOT NULL,
  fecha_nacimiento date NOT NULL,
  correo varchar(80) NOT NULL,
  codigo_curso char(2) NOT NULL,
  PRIMARY KEY (documento),
  UNIQUE KEY uq_alumno_correo (correo),
  CONSTRAINT fk_alumno_codigo_curso FOREIGN KEY (codigo_curso) REFERENCES CURSO (codigo_curso)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- INSTRUCTOR
CREATE TABLE INSTRUCTOR (
  documento varchar(15) NOT NULL,
  nombres varchar(50) NOT NULL,
  apellidos varchar(50) NOT NULL,
  fecha_nacimiento date NOT NULL,
  licencia_instructor varchar(12) NOT NULL,
  codigo_sede char(3) NOT NULL,
  PRIMARY KEY (documento),
  UNIQUE KEY uq_instructor_licencia_instructor (licencia_instructor),
  CONSTRAINT fk_instructor_codigo_sede FOREIGN KEY (codigo_sede) REFERENCES SEDE (codigo_sede)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ALU_TELEFONO
CREATE TABLE ALU_TELEFONO (
  documento varchar(15) NOT NULL,
  telefono varchar(15) NOT NULL,
  PRIMARY KEY (documento, telefono),
  CONSTRAINT fk_alu_telefono_documento FOREIGN KEY (documento) REFERENCES ALUMNO (documento)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- OFERTA
CREATE TABLE OFERTA (
  codigo_sede char(3) NOT NULL,
  codigo_curso char(2) NOT NULL,
  precio decimal(10,2) NOT NULL,
  PRIMARY KEY (codigo_sede, codigo_curso),
  CONSTRAINT fk_oferta_codigo_sede FOREIGN KEY (codigo_sede) REFERENCES SEDE (codigo_sede),
  CONSTRAINT fk_oferta_codigo_curso FOREIGN KEY (codigo_curso) REFERENCES CURSO (codigo_curso)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- VEHICULO
CREATE TABLE VEHICULO (
  placa char(6) NOT NULL,
  marca varchar(30) NOT NULL,
  anio int NOT NULL,
  doc_responsable varchar(15) NOT NULL,
  PRIMARY KEY (placa),
  UNIQUE KEY uq_vehiculo_doc_responsable (doc_responsable),
  CONSTRAINT fk_vehiculo_doc_responsable FOREIGN KEY (doc_responsable) REFERENCES INSTRUCTOR (documento)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- CARRO
CREATE TABLE CARRO (
  placa char(6) NOT NULL,
  num_puertas int NOT NULL,
  PRIMARY KEY (placa),
  CONSTRAINT fk_carro_placa FOREIGN KEY (placa) REFERENCES VEHICULO (placa)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- MOTO
CREATE TABLE MOTO (
  placa char(6) NOT NULL,
  cilindraje_cc int NOT NULL,
  PRIMARY KEY (placa),
  CONSTRAINT fk_moto_placa FOREIGN KEY (placa) REFERENCES VEHICULO (placa)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- CAMION
CREATE TABLE CAMION (
  placa char(6) NOT NULL,
  capacidad_ton decimal(4,1) NOT NULL,
  PRIMARY KEY (placa),
  CONSTRAINT fk_camion_placa FOREIGN KEY (placa) REFERENCES VEHICULO (placa)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- PRACTICA
CREATE TABLE PRACTICA (
  doc_alumno varchar(15) NOT NULL,
  doc_instructor varchar(15) NOT NULL,
  placa char(6) NOT NULL,
  fecha date NOT NULL,
  hora time NOT NULL,
  kilometros int NOT NULL,
  PRIMARY KEY (doc_alumno, doc_instructor, placa, fecha),
  CONSTRAINT fk_practica_doc_alumno FOREIGN KEY (doc_alumno) REFERENCES ALUMNO (documento),
  CONSTRAINT fk_practica_doc_instructor FOREIGN KEY (doc_instructor) REFERENCES INSTRUCTOR (documento),
  CONSTRAINT fk_practica_placa FOREIGN KEY (placa) REFERENCES VEHICULO (placa)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
