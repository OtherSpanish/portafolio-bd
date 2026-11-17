-- Agencia de turismo - Bases de Datos 1
-- 01: creacion de la oficina de datos y de las 9 tablas
SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS turismo
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE turismo;

CREATE TABLE OFICINA (
  codigo_oficina char(3) NOT NULL,
  nombre varchar(80) NOT NULL,
  ciudad varchar(50) NOT NULL,
  pais varchar(50) NOT NULL,
  PRIMARY KEY (codigo_oficina)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE PERSONA (
  documento varchar(15) NOT NULL,
  nombres varchar(50) NOT NULL,
  apellidos varchar(50) NOT NULL,
  fecha_nacimiento date NOT NULL,
  tipo_persona enum('guia','turista','ambos') NOT NULL,
  registro_rnt varchar(10) DEFAULT NULL,
  anios_experiencia int DEFAULT NULL,
  codigo_oficina char(3) DEFAULT NULL,
  correo varchar(80) DEFAULT NULL,
  puntos int DEFAULT NULL,
  PRIMARY KEY (documento),
  UNIQUE KEY uq_persona_registro_rnt (registro_rnt),
  UNIQUE KEY uq_persona_correo (correo),
  KEY fk_persona_oficina (codigo_oficina),
  CONSTRAINT fk_persona_oficina FOREIGN KEY (codigo_oficina) REFERENCES OFICINA (codigo_oficina)
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
  codigo_oficina char(3) NOT NULL,
  PRIMARY KEY (placa),
  KEY fk_vehiculo_oficina (codigo_oficina),
  CONSTRAINT fk_vehiculo_oficina FOREIGN KEY (codigo_oficina) REFERENCES OFICINA (codigo_oficina)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE BUSETA (
  placa varchar(10) NOT NULL,
  num_sillas int NOT NULL,
  PRIMARY KEY (placa),
  CONSTRAINT fk_buseta_vehiculo FOREIGN KEY (placa) REFERENCES VEHICULO (placa)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE LANCHA (
  placa varchar(10) NOT NULL,
  eslora_m decimal(10,2) NOT NULL,
  PRIMARY KEY (placa),
  CONSTRAINT fk_lancha_vehiculo FOREIGN KEY (placa) REFERENCES VEHICULO (placa)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE TOUR (
  id_tour bigint NOT NULL AUTO_INCREMENT,
  codigo varchar(8) NOT NULL,
  fecha date NOT NULL,
  hora_salida time NOT NULL,
  destino varchar(50) NOT NULL,
  placa varchar(10) NOT NULL,
  oficina_tour char(3) NOT NULL,
  PRIMARY KEY (id_tour),
  UNIQUE KEY uq_tour_codigo_fecha (codigo,fecha),
  KEY fk_tour_vehiculo (placa),
  KEY fk_tour_oficina (oficina_tour),
  CONSTRAINT fk_tour_vehiculo FOREIGN KEY (placa) REFERENCES VEHICULO (placa),
  CONSTRAINT fk_tour_oficina FOREIGN KEY (oficina_tour) REFERENCES OFICINA (codigo_oficina)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE GUIANZA (
  documento varchar(15) NOT NULL,
  id_tour bigint NOT NULL,
  rol enum('principal','apoyo') NOT NULL,
  PRIMARY KEY (documento,id_tour),
  KEY fk_guianza_tour (id_tour),
  CONSTRAINT fk_guianza_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento),
  CONSTRAINT fk_guianza_tour FOREIGN KEY (id_tour) REFERENCES TOUR (id_tour)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE RESERVA (
  documento varchar(15) NOT NULL,
  id_tour bigint NOT NULL,
  silla varchar(4) NOT NULL,
  plan enum('basico','premium') NOT NULL,
  PRIMARY KEY (documento,id_tour),
  UNIQUE KEY uq_reserva_tour_silla (id_tour,silla),
  CONSTRAINT fk_reserva_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento),
  CONSTRAINT fk_reserva_tour FOREIGN KEY (id_tour) REFERENCES TOUR (id_tour)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
