-- Clínica - Bases de Datos 1
-- 01: creacion de la sede de datos y de las 9 tablas
SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS clinica
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE clinica;

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
  tipo_persona enum('medico','paciente','ambos') NOT NULL,
  registro_medico varchar(10) DEFAULT NULL,
  anios_experiencia int DEFAULT NULL,
  codigo_sede char(3) DEFAULT NULL,
  correo varchar(80) DEFAULT NULL,
  visitas int DEFAULT NULL,
  PRIMARY KEY (documento),
  UNIQUE KEY uq_persona_registro_medico (registro_medico),
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

CREATE TABLE CONSULTORIO (
  codigo_consultorio varchar(10) NOT NULL,
  bloque varchar(40) NOT NULL,
  piso varchar(40) NOT NULL,
  codigo_sede char(3) NOT NULL,
  PRIMARY KEY (codigo_consultorio),
  KEY fk_consultorio_sede (codigo_sede),
  CONSTRAINT fk_consultorio_sede FOREIGN KEY (codigo_sede) REFERENCES SEDE (codigo_sede)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE OBSERVACION (
  codigo_consultorio varchar(10) NOT NULL,
  num_camillas int NOT NULL,
  PRIMARY KEY (codigo_consultorio),
  CONSTRAINT fk_observacion_consultorio FOREIGN KEY (codigo_consultorio) REFERENCES CONSULTORIO (codigo_consultorio)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE LABORATORIO (
  codigo_consultorio varchar(10) NOT NULL,
  area_m2 decimal(10,2) NOT NULL,
  PRIMARY KEY (codigo_consultorio),
  CONSTRAINT fk_laboratorio_consultorio FOREIGN KEY (codigo_consultorio) REFERENCES CONSULTORIO (codigo_consultorio)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE JORNADA (
  id_jornada bigint NOT NULL AUTO_INCREMENT,
  codigo varchar(8) NOT NULL,
  fecha date NOT NULL,
  hora_inicio time NOT NULL,
  especialidad varchar(50) NOT NULL,
  codigo_consultorio varchar(10) NOT NULL,
  sede_jornada char(3) NOT NULL,
  PRIMARY KEY (id_jornada),
  UNIQUE KEY uq_jornada_codigo_fecha (codigo,fecha),
  KEY fk_jornada_consultorio (codigo_consultorio),
  KEY fk_jornada_sede (sede_jornada),
  CONSTRAINT fk_jornada_consultorio FOREIGN KEY (codigo_consultorio) REFERENCES CONSULTORIO (codigo_consultorio),
  CONSTRAINT fk_jornada_sede FOREIGN KEY (sede_jornada) REFERENCES SEDE (codigo_sede)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE ATENCION (
  documento varchar(15) NOT NULL,
  id_jornada bigint NOT NULL,
  rol enum('principal','apoyo') NOT NULL,
  PRIMARY KEY (documento,id_jornada),
  KEY fk_atencion_jornada (id_jornada),
  CONSTRAINT fk_atencion_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento),
  CONSTRAINT fk_atencion_jornada FOREIGN KEY (id_jornada) REFERENCES JORNADA (id_jornada)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE CITA (
  documento varchar(15) NOT NULL,
  id_jornada bigint NOT NULL,
  turno varchar(4) NOT NULL,
  regimen enum('contributivo','subsidiado') NOT NULL,
  PRIMARY KEY (documento,id_jornada),
  UNIQUE KEY uq_cita_jornada_turno (id_jornada,turno),
  CONSTRAINT fk_cita_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento),
  CONSTRAINT fk_cita_jornada FOREIGN KEY (id_jornada) REFERENCES JORNADA (id_jornada)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
