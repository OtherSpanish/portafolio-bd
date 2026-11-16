-- Teatro - Bases de Datos 1
-- 01: creacion de la teatro de datos y de las 9 tablas
SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS teatro
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE teatro;

CREATE TABLE TEATRO (
  codigo_teatro char(3) NOT NULL,
  nombre varchar(80) NOT NULL,
  ciudad varchar(50) NOT NULL,
  pais varchar(50) NOT NULL,
  PRIMARY KEY (codigo_teatro)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE PERSONA (
  documento varchar(15) NOT NULL,
  nombres varchar(50) NOT NULL,
  apellidos varchar(50) NOT NULL,
  fecha_nacimiento date NOT NULL,
  tipo_persona enum('actor','espectador','ambos') NOT NULL,
  carnet varchar(10) DEFAULT NULL,
  anios_carrera int DEFAULT NULL,
  codigo_teatro char(3) DEFAULT NULL,
  correo varchar(80) DEFAULT NULL,
  puntos int DEFAULT NULL,
  PRIMARY KEY (documento),
  UNIQUE KEY uq_persona_carnet (carnet),
  UNIQUE KEY uq_persona_correo (correo),
  KEY fk_persona_teatro (codigo_teatro),
  CONSTRAINT fk_persona_teatro FOREIGN KEY (codigo_teatro) REFERENCES TEATRO (codigo_teatro)
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
  nombre_sala varchar(40) NOT NULL,
  piso varchar(40) NOT NULL,
  codigo_teatro char(3) NOT NULL,
  PRIMARY KEY (codigo_sala),
  KEY fk_sala_teatro (codigo_teatro),
  CONSTRAINT fk_sala_teatro FOREIGN KEY (codigo_teatro) REFERENCES TEATRO (codigo_teatro)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE SALA_MAYOR (
  codigo_sala varchar(10) NOT NULL,
  num_sillas int NOT NULL,
  PRIMARY KEY (codigo_sala),
  CONSTRAINT fk_sala_mayor_sala FOREIGN KEY (codigo_sala) REFERENCES SALA (codigo_sala)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE SALA_ENSAYO (
  codigo_sala varchar(10) NOT NULL,
  area_m2 decimal(10,2) NOT NULL,
  PRIMARY KEY (codigo_sala),
  CONSTRAINT fk_sala_ensayo_sala FOREIGN KEY (codigo_sala) REFERENCES SALA (codigo_sala)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE FUNCION (
  id_funcion bigint NOT NULL AUTO_INCREMENT,
  codigo varchar(8) NOT NULL,
  fecha date NOT NULL,
  hora_inicio time NOT NULL,
  obra varchar(50) NOT NULL,
  codigo_sala varchar(10) NOT NULL,
  teatro_funcion char(3) NOT NULL,
  PRIMARY KEY (id_funcion),
  UNIQUE KEY uq_funcion_codigo_fecha (codigo,fecha),
  KEY fk_funcion_sala (codigo_sala),
  KEY fk_funcion_teatro (teatro_funcion),
  CONSTRAINT fk_funcion_sala FOREIGN KEY (codigo_sala) REFERENCES SALA (codigo_sala),
  CONSTRAINT fk_funcion_teatro FOREIGN KEY (teatro_funcion) REFERENCES TEATRO (codigo_teatro)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE ELENCO (
  documento varchar(15) NOT NULL,
  id_funcion bigint NOT NULL,
  rol enum('protagonista','reparto') NOT NULL,
  PRIMARY KEY (documento,id_funcion),
  KEY fk_elenco_funcion (id_funcion),
  CONSTRAINT fk_elenco_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento),
  CONSTRAINT fk_elenco_funcion FOREIGN KEY (id_funcion) REFERENCES FUNCION (id_funcion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE BOLETA (
  documento varchar(15) NOT NULL,
  id_funcion bigint NOT NULL,
  silla varchar(4) NOT NULL,
  zona enum('general','palco') NOT NULL,
  PRIMARY KEY (documento,id_funcion),
  UNIQUE KEY uq_boleta_funcion_silla (id_funcion,silla),
  CONSTRAINT fk_boleta_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento),
  CONSTRAINT fk_boleta_funcion FOREIGN KEY (id_funcion) REFERENCES FUNCION (id_funcion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
