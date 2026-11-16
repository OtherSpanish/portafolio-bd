-- Gimnasio - Bases de Datos 1
-- 01: creacion de la sede de datos y de las 9 tablas
SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS gimnasio
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE gimnasio;

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
  tipo_persona enum('entrenador','socio','ambos') NOT NULL,
  certificacion varchar(10) DEFAULT NULL,
  anios_experiencia int DEFAULT NULL,
  codigo_sede char(3) DEFAULT NULL,
  correo varchar(80) DEFAULT NULL,
  puntos int DEFAULT NULL,
  PRIMARY KEY (documento),
  UNIQUE KEY uq_persona_certificacion (certificacion),
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

CREATE TABLE SALA (
  codigo_sala varchar(10) NOT NULL,
  ambiente varchar(40) NOT NULL,
  piso varchar(40) NOT NULL,
  codigo_sede char(3) NOT NULL,
  PRIMARY KEY (codigo_sala),
  KEY fk_sala_sede (codigo_sede),
  CONSTRAINT fk_sala_sede FOREIGN KEY (codigo_sede) REFERENCES SEDE (codigo_sede)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE SALA_CARDIO (
  codigo_sala varchar(10) NOT NULL,
  num_maquinas int NOT NULL,
  PRIMARY KEY (codigo_sala),
  CONSTRAINT fk_sala_cardio_sala FOREIGN KEY (codigo_sala) REFERENCES SALA (codigo_sala)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE PISCINA (
  codigo_sala varchar(10) NOT NULL,
  volumen_m3 decimal(10,2) NOT NULL,
  PRIMARY KEY (codigo_sala),
  CONSTRAINT fk_piscina_sala FOREIGN KEY (codigo_sala) REFERENCES SALA (codigo_sala)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE CLASE (
  id_clase bigint NOT NULL AUTO_INCREMENT,
  codigo varchar(8) NOT NULL,
  fecha date NOT NULL,
  hora_inicio time NOT NULL,
  actividad varchar(50) NOT NULL,
  codigo_sala varchar(10) NOT NULL,
  sede_clase char(3) NOT NULL,
  PRIMARY KEY (id_clase),
  UNIQUE KEY uq_clase_codigo_fecha (codigo,fecha),
  KEY fk_clase_sala (codigo_sala),
  KEY fk_clase_sede (sede_clase),
  CONSTRAINT fk_clase_sala FOREIGN KEY (codigo_sala) REFERENCES SALA (codigo_sala),
  CONSTRAINT fk_clase_sede FOREIGN KEY (sede_clase) REFERENCES SEDE (codigo_sede)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE INSTRUCCION (
  documento varchar(15) NOT NULL,
  id_clase bigint NOT NULL,
  rol enum('principal','apoyo') NOT NULL,
  PRIMARY KEY (documento,id_clase),
  KEY fk_instruccion_clase (id_clase),
  CONSTRAINT fk_instruccion_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento),
  CONSTRAINT fk_instruccion_clase FOREIGN KEY (id_clase) REFERENCES CLASE (id_clase)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE CUPO (
  documento varchar(15) NOT NULL,
  id_clase bigint NOT NULL,
  puesto varchar(4) NOT NULL,
  plan enum('basico','premium') NOT NULL,
  PRIMARY KEY (documento,id_clase),
  UNIQUE KEY uq_cupo_clase_puesto (id_clase,puesto),
  CONSTRAINT fk_cupo_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento),
  CONSTRAINT fk_cupo_clase FOREIGN KEY (id_clase) REFERENCES CLASE (id_clase)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
