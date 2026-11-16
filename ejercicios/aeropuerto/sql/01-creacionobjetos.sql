-- Aeropuerto - Bases de Datos 1
-- 01: creacion de la base de datos y de las 9 tablas
-- Las tablas van en orden: primero las que no dependen de otras.
-- Ejecutar con un usuario administrador.

SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS aeropuerto
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE aeropuerto;

-- BASE: aeropuertos donde opera la aerolinea (codigo IATA)
CREATE TABLE BASE (
  codigo_base char(3) NOT NULL,
  nombre varchar(80) NOT NULL,
  ciudad varchar(50) NOT NULL,
  pais varchar(50) NOT NULL,
  PRIMARY KEY (codigo_base)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- PERSONA: pilotos y pasajeros en una sola tabla (la jerarquia es solapada)
CREATE TABLE PERSONA (
  documento varchar(15) NOT NULL,
  nombres varchar(50) NOT NULL,
  apellidos varchar(50) NOT NULL,
  fecha_nacimiento date NOT NULL,
  tipo_persona enum('piloto','pasajero','ambos') NOT NULL,
  licencia varchar(10) DEFAULT NULL,
  horas_vuelo int DEFAULT NULL,
  codigo_base char(3) DEFAULT NULL,
  correo varchar(80) DEFAULT NULL,
  millas int DEFAULT NULL,
  PRIMARY KEY (documento),
  UNIQUE KEY uq_persona_licencia (licencia),
  UNIQUE KEY uq_persona_correo (correo),
  KEY fk_persona_base (codigo_base),
  CONSTRAINT fk_persona_base FOREIGN KEY (codigo_base) REFERENCES BASE (codigo_base)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- PER_TELEFONO: telefonos de cada persona (atributo multivaluado)
CREATE TABLE PER_TELEFONO (
  documento varchar(15) NOT NULL,
  telefono varchar(15) NOT NULL,
  PRIMARY KEY (documento,telefono),
  CONSTRAINT fk_per_telefono_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- AVION: datos comunes del avion (supertipo)
CREATE TABLE AVION (
  matricula varchar(10) NOT NULL,
  modelo varchar(40) NOT NULL,
  fabricante varchar(40) NOT NULL,
  codigo_base char(3) NOT NULL,
  PRIMARY KEY (matricula),
  KEY fk_avion_base (codigo_base),
  CONSTRAINT fk_avion_base FOREIGN KEY (codigo_base) REFERENCES BASE (codigo_base)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- AVION_COMERCIAL: subtipo de pasajeros
CREATE TABLE AVION_COMERCIAL (
  matricula varchar(10) NOT NULL,
  num_asientos int NOT NULL,
  PRIMARY KEY (matricula),
  CONSTRAINT fk_avion_comercial_avion FOREIGN KEY (matricula) REFERENCES AVION (matricula)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- AVION_CARGA: subtipo de carga
CREATE TABLE AVION_CARGA (
  matricula varchar(10) NOT NULL,
  capacidad_kg decimal(10,2) NOT NULL,
  PRIMARY KEY (matricula),
  CONSTRAINT fk_avion_carga_avion FOREIGN KEY (matricula) REFERENCES AVION (matricula)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- VUELO: cada salida de un avion desde una base
CREATE TABLE VUELO (
  id_vuelo bigint NOT NULL AUTO_INCREMENT,
  codigo varchar(8) NOT NULL,
  fecha date NOT NULL,
  hora_salida time NOT NULL,
  destino varchar(50) NOT NULL,
  matricula varchar(10) NOT NULL,
  codigo_base_origen char(3) NOT NULL,
  PRIMARY KEY (id_vuelo),
  UNIQUE KEY uq_vuelo_codigo_fecha (codigo,fecha),
  KEY fk_vuelo_avion (matricula),
  KEY fk_vuelo_base (codigo_base_origen),
  CONSTRAINT fk_vuelo_avion FOREIGN KEY (matricula) REFERENCES AVION (matricula),
  CONSTRAINT fk_vuelo_base FOREIGN KEY (codigo_base_origen) REFERENCES BASE (codigo_base)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- TRIPULACION: relacion N:M piloto - vuelo, con el rol
CREATE TABLE TRIPULACION (
  documento varchar(15) NOT NULL,
  id_vuelo bigint NOT NULL,
  rol enum('capitan','copiloto') NOT NULL,
  PRIMARY KEY (documento,id_vuelo),
  KEY fk_tripulacion_vuelo (id_vuelo),
  CONSTRAINT fk_tripulacion_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento),
  CONSTRAINT fk_tripulacion_vuelo FOREIGN KEY (id_vuelo) REFERENCES VUELO (id_vuelo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- RESERVA: relacion N:M pasajero - vuelo, con asiento y clase
CREATE TABLE RESERVA (
  documento varchar(15) NOT NULL,
  id_vuelo bigint NOT NULL,
  asiento varchar(4) NOT NULL,
  clase enum('economica','ejecutiva') NOT NULL,
  PRIMARY KEY (documento,id_vuelo),
  UNIQUE KEY uq_reserva_vuelo_asiento (id_vuelo,asiento),
  CONSTRAINT fk_reserva_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento),
  CONSTRAINT fk_reserva_vuelo FOREIGN KEY (id_vuelo) REFERENCES VUELO (id_vuelo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
