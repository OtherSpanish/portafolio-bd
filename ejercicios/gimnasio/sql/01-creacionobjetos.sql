-- Gimnasio - Bases de Datos 1
-- 01: creacion de la base de datos y de las 9 tablas
-- Las tablas van en orden: primero las que no dependen de otras.

SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS gimnasio
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE gimnasio;

-- PLAN
CREATE TABLE PLAN (
  id_plan int NOT NULL,
  nombre varchar(40) NOT NULL,
  precio_mes decimal(10,2) NOT NULL,
  meses int NOT NULL,
  PRIMARY KEY (id_plan),
  UNIQUE KEY uq_plan_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- SOCIO
CREATE TABLE SOCIO (
  id_socio varchar(15) NOT NULL,
  nombres varchar(50) NOT NULL,
  apellidos varchar(50) NOT NULL,
  fecha_nacimiento date NOT NULL,
  correo varchar(80) NOT NULL,
  id_plan int NOT NULL,
  PRIMARY KEY (id_socio),
  UNIQUE KEY uq_socio_correo (correo),
  CONSTRAINT fk_socio_id_plan FOREIGN KEY (id_plan) REFERENCES PLAN (id_plan)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- SEDE
CREATE TABLE SEDE (
  codigo_sede char(3) NOT NULL,
  nombre varchar(60) NOT NULL,
  direccion varchar(80) NOT NULL,
  horario varchar(40) NOT NULL,
  PRIMARY KEY (codigo_sede)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- CARDIO
CREATE TABLE CARDIO (
  serial varchar(12) NOT NULL,
  marca varchar(30) NOT NULL,
  anio int NOT NULL,
  velocidad_max decimal(4,1) NOT NULL,
  codigo_sede char(3) NOT NULL,
  PRIMARY KEY (serial),
  CONSTRAINT fk_cardio_codigo_sede FOREIGN KEY (codigo_sede) REFERENCES SEDE (codigo_sede)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- FUERZA
CREATE TABLE FUERZA (
  serial varchar(12) NOT NULL,
  marca varchar(30) NOT NULL,
  anio int NOT NULL,
  peso_max_kg int NOT NULL,
  codigo_sede char(3) NOT NULL,
  PRIMARY KEY (serial),
  CONSTRAINT fk_fuerza_codigo_sede FOREIGN KEY (codigo_sede) REFERENCES SEDE (codigo_sede)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- SOC_TELEFONO
CREATE TABLE SOC_TELEFONO (
  id_socio varchar(15) NOT NULL,
  telefono varchar(15) NOT NULL,
  PRIMARY KEY (id_socio, telefono),
  CONSTRAINT fk_soc_telefono_id_socio FOREIGN KEY (id_socio) REFERENCES SOCIO (id_socio)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ASISTENCIA
CREATE TABLE ASISTENCIA (
  id_socio varchar(15) NOT NULL,
  codigo_sede char(3) NOT NULL,
  fecha date NOT NULL,
  hora_entrada time NOT NULL,
  PRIMARY KEY (id_socio, codigo_sede, fecha),
  CONSTRAINT fk_asistencia_id_socio FOREIGN KEY (id_socio) REFERENCES SOCIO (id_socio),
  CONSTRAINT fk_asistencia_codigo_sede FOREIGN KEY (codigo_sede) REFERENCES SEDE (codigo_sede)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ENTRENADOR
CREATE TABLE ENTRENADOR (
  id_entrenador varchar(15) NOT NULL,
  nombres varchar(50) NOT NULL,
  apellidos varchar(50) NOT NULL,
  especialidad varchar(40) NOT NULL,
  certificacion varchar(40) NOT NULL,
  codigo_sede char(3) NOT NULL,
  PRIMARY KEY (id_entrenador),
  CONSTRAINT fk_entrenador_codigo_sede FOREIGN KEY (codigo_sede) REFERENCES SEDE (codigo_sede)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ASESORIA
CREATE TABLE ASESORIA (
  id_socio varchar(15) NOT NULL,
  id_entrenador varchar(15) NOT NULL,
  desde date NOT NULL,
  PRIMARY KEY (id_socio),
  CONSTRAINT fk_asesoria_id_socio FOREIGN KEY (id_socio) REFERENCES SOCIO (id_socio),
  CONSTRAINT fk_asesoria_id_entrenador FOREIGN KEY (id_entrenador) REFERENCES ENTRENADOR (id_entrenador)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
