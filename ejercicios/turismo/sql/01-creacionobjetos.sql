-- Agencia de turismo - Bases de Datos 1
-- 01: creacion de la base de datos y de las 13 tablas
-- Las tablas van en orden: primero las que no dependen de otras.

SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS turismo
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE turismo;

-- DESTINO
CREATE TABLE DESTINO (
  id_destino int NOT NULL,
  nombre varchar(60) NOT NULL,
  pais varchar(40) NOT NULL,
  clima varchar(20) NOT NULL,
  PRIMARY KEY (id_destino)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- TURISTA
CREATE TABLE TURISTA (
  documento varchar(15) NOT NULL,
  nombres varchar(50) NOT NULL,
  apellidos varchar(50) NOT NULL,
  fecha_nacimiento date NOT NULL,
  correo varchar(80) NOT NULL,
  PRIMARY KEY (documento),
  UNIQUE KEY uq_turista_correo (correo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- OFICINA
CREATE TABLE OFICINA (
  codigo_oficina char(3) NOT NULL,
  ciudad varchar(50) NOT NULL,
  direccion varchar(80) NOT NULL,
  PRIMARY KEY (codigo_oficina)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- TUR_TELEFONO
CREATE TABLE TUR_TELEFONO (
  documento varchar(15) NOT NULL,
  telefono varchar(15) NOT NULL,
  PRIMARY KEY (documento, telefono),
  CONSTRAINT fk_tur_telefono_documento FOREIGN KEY (documento) REFERENCES TURISTA (documento)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- HOTEL
CREATE TABLE HOTEL (
  id_hotel int NOT NULL,
  nombre varchar(60) NOT NULL,
  estrellas int NOT NULL,
  id_destino int NOT NULL,
  PRIMARY KEY (id_hotel),
  CONSTRAINT fk_hotel_id_destino FOREIGN KEY (id_destino) REFERENCES DESTINO (id_destino)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- GUIA
CREATE TABLE GUIA (
  id_guia varchar(15) NOT NULL,
  nombres varchar(50) NOT NULL,
  apellidos varchar(50) NOT NULL,
  registro_rnt varchar(12) NOT NULL,
  codigo_oficina char(3) NOT NULL,
  PRIMARY KEY (id_guia),
  UNIQUE KEY uq_guia_registro_rnt (registro_rnt),
  CONSTRAINT fk_guia_codigo_oficina FOREIGN KEY (codigo_oficina) REFERENCES OFICINA (codigo_oficina)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- PAQUETE
CREATE TABLE PAQUETE (
  codigo_paquete varchar(8) NOT NULL,
  nombre varchar(80) NOT NULL,
  dias int NOT NULL,
  precio decimal(12,2) NOT NULL,
  codigo_oficina char(3) NOT NULL,
  PRIMARY KEY (codigo_paquete),
  CONSTRAINT fk_paquete_codigo_oficina FOREIGN KEY (codigo_oficina) REFERENCES OFICINA (codigo_oficina)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- NACIONAL
CREATE TABLE NACIONAL (
  codigo_paquete varchar(8) NOT NULL,
  transporte enum('aereo','terrestre') NOT NULL,
  PRIMARY KEY (codigo_paquete),
  CONSTRAINT fk_nacional_codigo_paquete FOREIGN KEY (codigo_paquete) REFERENCES PAQUETE (codigo_paquete)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- INTERNACIONAL
CREATE TABLE INTERNACIONAL (
  codigo_paquete varchar(8) NOT NULL,
  pais varchar(40) NOT NULL,
  requiere_visa enum('si','no') NOT NULL,
  PRIMARY KEY (codigo_paquete),
  CONSTRAINT fk_internacional_codigo_paquete FOREIGN KEY (codigo_paquete) REFERENCES PAQUETE (codigo_paquete)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- GUI_IDIOMA
CREATE TABLE GUI_IDIOMA (
  id_guia varchar(15) NOT NULL,
  idioma varchar(20) NOT NULL,
  PRIMARY KEY (id_guia, idioma),
  CONSTRAINT fk_gui_idioma_id_guia FOREIGN KEY (id_guia) REFERENCES GUIA (id_guia)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- GUIA_DESTINO
CREATE TABLE GUIA_DESTINO (
  id_guia varchar(15) NOT NULL,
  id_destino int NOT NULL,
  PRIMARY KEY (id_guia, id_destino),
  CONSTRAINT fk_guia_destino_id_guia FOREIGN KEY (id_guia) REFERENCES GUIA (id_guia),
  CONSTRAINT fk_guia_destino_id_destino FOREIGN KEY (id_destino) REFERENCES DESTINO (id_destino)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ITINERARIO
CREATE TABLE ITINERARIO (
  codigo_paquete varchar(8) NOT NULL,
  id_destino int NOT NULL,
  noches int NOT NULL,
  PRIMARY KEY (codigo_paquete, id_destino),
  CONSTRAINT fk_itinerario_codigo_paquete FOREIGN KEY (codigo_paquete) REFERENCES PAQUETE (codigo_paquete),
  CONSTRAINT fk_itinerario_id_destino FOREIGN KEY (id_destino) REFERENCES DESTINO (id_destino)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- VENTA
CREATE TABLE VENTA (
  documento varchar(15) NOT NULL,
  codigo_paquete varchar(8) NOT NULL,
  fecha_salida date NOT NULL,
  valor_pagado decimal(12,2) NOT NULL,
  PRIMARY KEY (documento, codigo_paquete, fecha_salida),
  CONSTRAINT fk_venta_documento FOREIGN KEY (documento) REFERENCES TURISTA (documento),
  CONSTRAINT fk_venta_codigo_paquete FOREIGN KEY (codigo_paquete) REFERENCES PAQUETE (codigo_paquete)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
