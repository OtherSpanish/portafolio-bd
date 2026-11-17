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
