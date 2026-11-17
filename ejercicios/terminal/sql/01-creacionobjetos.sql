-- Terminal de transporte - Bases de Datos 1
-- 01: creacion de la base de datos y de las 8 tablas
-- Las tablas van en orden: primero las que no dependen de otras.

SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS terminal
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE terminal;

-- EMPRESA
CREATE TABLE EMPRESA (
  nit varchar(12) NOT NULL,
  razon_social varchar(80) NOT NULL,
  ciudad_sede varchar(50) NOT NULL,
  PRIMARY KEY (nit),
  UNIQUE KEY uq_empresa_razon_social (razon_social)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- BUS
CREATE TABLE BUS (
  placa char(6) NOT NULL,
  marca varchar(30) NOT NULL,
  capacidad int NOT NULL,
  nit varchar(12) NOT NULL,
  PRIMARY KEY (placa),
  CONSTRAINT fk_bus_nit FOREIGN KEY (nit) REFERENCES EMPRESA (nit)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- TERMINAL
CREATE TABLE TERMINAL (
  codigo_terminal char(3) NOT NULL,
  nombre varchar(60) NOT NULL,
  ciudad varchar(50) NOT NULL,
  PRIMARY KEY (codigo_terminal)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- TAQUILLA
CREATE TABLE TAQUILLA (
  nit varchar(12) NOT NULL,
  codigo_terminal char(3) NOT NULL,
  numero_taquilla varchar(6) NOT NULL,
  PRIMARY KEY (nit, codigo_terminal),
  CONSTRAINT fk_taquilla_nit FOREIGN KEY (nit) REFERENCES EMPRESA (nit),
  CONSTRAINT fk_taquilla_codigo_terminal FOREIGN KEY (codigo_terminal) REFERENCES TERMINAL (codigo_terminal)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- PERSONA
CREATE TABLE PERSONA (
  documento varchar(15) NOT NULL,
  nombres varchar(50) NOT NULL,
  apellidos varchar(50) NOT NULL,
  fecha_nacimiento date NOT NULL,
  tipo_persona enum('conductor','viajero','ambos') NOT NULL,
  licencia varchar(12) DEFAULT NULL,
  categoria_licencia char(2) DEFAULT NULL,
  correo varchar(80) DEFAULT NULL,
  nit varchar(12) DEFAULT NULL,
  PRIMARY KEY (documento),
  UNIQUE KEY uq_persona_licencia (licencia),
  UNIQUE KEY uq_persona_correo (correo),
  CONSTRAINT fk_persona_nit FOREIGN KEY (nit) REFERENCES EMPRESA (nit)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- RUTA
CREATE TABLE RUTA (
  codigo_ruta varchar(8) NOT NULL,
  duracion_min int NOT NULL,
  valor decimal(10,2) NOT NULL,
  terminal_origen char(3) NOT NULL,
  terminal_destino char(3) NOT NULL,
  nit varchar(12) NOT NULL,
  PRIMARY KEY (codigo_ruta),
  CONSTRAINT fk_ruta_terminal_origen FOREIGN KEY (terminal_origen) REFERENCES TERMINAL (codigo_terminal),
  CONSTRAINT fk_ruta_terminal_destino FOREIGN KEY (terminal_destino) REFERENCES TERMINAL (codigo_terminal),
  CONSTRAINT fk_ruta_nit FOREIGN KEY (nit) REFERENCES EMPRESA (nit)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- PER_TELEFONO
CREATE TABLE PER_TELEFONO (
  documento varchar(15) NOT NULL,
  telefono varchar(15) NOT NULL,
  PRIMARY KEY (documento, telefono),
  CONSTRAINT fk_per_telefono_documento FOREIGN KEY (documento) REFERENCES PERSONA (documento)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- TIQUETE
CREATE TABLE TIQUETE (
  documento varchar(15) NOT NULL,
  codigo_ruta varchar(8) NOT NULL,
  fecha_viaje date NOT NULL,
  silla int NOT NULL,
  PRIMARY KEY (documento, codigo_ruta, fecha_viaje),
  CONSTRAINT fk_tiquete_documento FOREIGN KEY (documento) REFERENCES PERSONA (documento),
  CONSTRAINT fk_tiquete_codigo_ruta FOREIGN KEY (codigo_ruta) REFERENCES RUTA (codigo_ruta)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
