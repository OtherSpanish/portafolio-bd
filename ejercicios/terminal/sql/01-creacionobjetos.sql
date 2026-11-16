-- Terminal de transporte - Bases de Datos 1
-- 01: creacion de la terminal de datos y de las 9 tablas
SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS terminal
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE terminal;

CREATE TABLE TERMINAL (
  codigo_terminal char(3) NOT NULL,
  nombre varchar(80) NOT NULL,
  ciudad varchar(50) NOT NULL,
  pais varchar(50) NOT NULL,
  PRIMARY KEY (codigo_terminal)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE PERSONA (
  documento varchar(15) NOT NULL,
  nombres varchar(50) NOT NULL,
  apellidos varchar(50) NOT NULL,
  fecha_nacimiento date NOT NULL,
  tipo_persona enum('conductor','viajero','ambos') NOT NULL,
  licencia varchar(10) DEFAULT NULL,
  horas_manejo int DEFAULT NULL,
  codigo_terminal char(3) DEFAULT NULL,
  correo varchar(80) DEFAULT NULL,
  puntos int DEFAULT NULL,
  PRIMARY KEY (documento),
  UNIQUE KEY uq_persona_licencia (licencia),
  UNIQUE KEY uq_persona_correo (correo),
  KEY fk_persona_terminal (codigo_terminal),
  CONSTRAINT fk_persona_terminal FOREIGN KEY (codigo_terminal) REFERENCES TERMINAL (codigo_terminal)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE PER_TELEFONO (
  documento varchar(15) NOT NULL,
  telefono varchar(15) NOT NULL,
  PRIMARY KEY (documento,telefono),
  CONSTRAINT fk_per_telefono_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE BUS (
  placa varchar(10) NOT NULL,
  modelo varchar(40) NOT NULL,
  marca varchar(40) NOT NULL,
  codigo_terminal char(3) NOT NULL,
  PRIMARY KEY (placa),
  KEY fk_bus_terminal (codigo_terminal),
  CONSTRAINT fk_bus_terminal FOREIGN KEY (codigo_terminal) REFERENCES TERMINAL (codigo_terminal)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE BUS_PASAJEROS (
  placa varchar(10) NOT NULL,
  num_sillas int NOT NULL,
  PRIMARY KEY (placa),
  CONSTRAINT fk_bus_pasajeros_bus FOREIGN KEY (placa) REFERENCES BUS (placa)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE BUS_CARGA (
  placa varchar(10) NOT NULL,
  capacidad_kg decimal(10,2) NOT NULL,
  PRIMARY KEY (placa),
  CONSTRAINT fk_bus_carga_bus FOREIGN KEY (placa) REFERENCES BUS (placa)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE VIAJE (
  id_viaje bigint NOT NULL AUTO_INCREMENT,
  codigo varchar(8) NOT NULL,
  fecha date NOT NULL,
  hora_salida time NOT NULL,
  destino varchar(50) NOT NULL,
  placa varchar(10) NOT NULL,
  terminal_origen char(3) NOT NULL,
  PRIMARY KEY (id_viaje),
  UNIQUE KEY uq_viaje_codigo_fecha (codigo,fecha),
  KEY fk_viaje_bus (placa),
  KEY fk_viaje_terminal (terminal_origen),
  CONSTRAINT fk_viaje_bus FOREIGN KEY (placa) REFERENCES BUS (placa),
  CONSTRAINT fk_viaje_terminal FOREIGN KEY (terminal_origen) REFERENCES TERMINAL (codigo_terminal)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE CONDUCCION (
  documento varchar(15) NOT NULL,
  id_viaje bigint NOT NULL,
  rol enum('principal','relevo') NOT NULL,
  PRIMARY KEY (documento,id_viaje),
  KEY fk_conduccion_viaje (id_viaje),
  CONSTRAINT fk_conduccion_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento),
  CONSTRAINT fk_conduccion_viaje FOREIGN KEY (id_viaje) REFERENCES VIAJE (id_viaje)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE TIQUETE (
  documento varchar(15) NOT NULL,
  id_viaje bigint NOT NULL,
  silla varchar(4) NOT NULL,
  servicio enum('basico','preferencial') NOT NULL,
  PRIMARY KEY (documento,id_viaje),
  UNIQUE KEY uq_tiquete_viaje_silla (id_viaje,silla),
  CONSTRAINT fk_tiquete_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento),
  CONSTRAINT fk_tiquete_viaje FOREIGN KEY (id_viaje) REFERENCES VIAJE (id_viaje)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
