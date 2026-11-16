-- Universidad - Bases de Datos 1
-- 01: creacion de la sede de datos y de las 9 tablas
SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS universidad
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE universidad;

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
  tipo_persona enum('profesor','estudiante','ambos') NOT NULL,
  registro varchar(10) DEFAULT NULL,
  anios_experiencia int DEFAULT NULL,
  codigo_sede char(3) DEFAULT NULL,
  correo varchar(80) DEFAULT NULL,
  creditos int DEFAULT NULL,
  PRIMARY KEY (documento),
  UNIQUE KEY uq_persona_registro (registro),
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

CREATE TABLE SALON (
  codigo_salon varchar(10) NOT NULL,
  bloque varchar(40) NOT NULL,
  piso varchar(40) NOT NULL,
  codigo_sede char(3) NOT NULL,
  PRIMARY KEY (codigo_salon),
  KEY fk_salon_sede (codigo_sede),
  CONSTRAINT fk_salon_sede FOREIGN KEY (codigo_sede) REFERENCES SEDE (codigo_sede)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE LABORATORIO (
  codigo_salon varchar(10) NOT NULL,
  num_equipos int NOT NULL,
  PRIMARY KEY (codigo_salon),
  CONSTRAINT fk_laboratorio_salon FOREIGN KEY (codigo_salon) REFERENCES SALON (codigo_salon)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE AUDITORIO (
  codigo_salon varchar(10) NOT NULL,
  area_m2 decimal(10,2) NOT NULL,
  PRIMARY KEY (codigo_salon),
  CONSTRAINT fk_auditorio_salon FOREIGN KEY (codigo_salon) REFERENCES SALON (codigo_salon)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE CURSO (
  id_curso bigint NOT NULL AUTO_INCREMENT,
  codigo varchar(8) NOT NULL,
  fecha date NOT NULL,
  hora_inicio time NOT NULL,
  asignatura varchar(50) NOT NULL,
  codigo_salon varchar(10) NOT NULL,
  sede_curso char(3) NOT NULL,
  PRIMARY KEY (id_curso),
  UNIQUE KEY uq_curso_codigo_fecha (codigo,fecha),
  KEY fk_curso_salon (codigo_salon),
  KEY fk_curso_sede (sede_curso),
  CONSTRAINT fk_curso_salon FOREIGN KEY (codigo_salon) REFERENCES SALON (codigo_salon),
  CONSTRAINT fk_curso_sede FOREIGN KEY (sede_curso) REFERENCES SEDE (codigo_sede)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE DOCENCIA (
  documento varchar(15) NOT NULL,
  id_curso bigint NOT NULL,
  rol enum('titular','auxiliar') NOT NULL,
  PRIMARY KEY (documento,id_curso),
  KEY fk_docencia_curso (id_curso),
  CONSTRAINT fk_docencia_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento),
  CONSTRAINT fk_docencia_curso FOREIGN KEY (id_curso) REFERENCES CURSO (id_curso)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE INSCRIPCION (
  documento varchar(15) NOT NULL,
  id_curso bigint NOT NULL,
  puesto varchar(4) NOT NULL,
  modalidad enum('presencial','virtual') NOT NULL,
  PRIMARY KEY (documento,id_curso),
  UNIQUE KEY uq_inscripcion_curso_puesto (id_curso,puesto),
  CONSTRAINT fk_inscripcion_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento),
  CONSTRAINT fk_inscripcion_curso FOREIGN KEY (id_curso) REFERENCES CURSO (id_curso)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
