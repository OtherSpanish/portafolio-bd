-- Red de bibliotecas - Bases de Datos 1
-- 01: creacion de la base de datos y de las 10 tablas
-- Las tablas van en orden: primero las que no dependen de otras.

SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS biblioteca
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE biblioteca;

-- AUTOR
CREATE TABLE AUTOR (
  id_autor int NOT NULL,
  nombre varchar(80) NOT NULL,
  nacionalidad varchar(40) NOT NULL,
  PRIMARY KEY (id_autor)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- EDITORIAL
CREATE TABLE EDITORIAL (
  id_editorial int NOT NULL,
  nombre varchar(60) NOT NULL,
  pais varchar(40) NOT NULL,
  PRIMARY KEY (id_editorial),
  UNIQUE KEY uq_editorial_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- SEDE
CREATE TABLE SEDE (
  codigo_sede char(3) NOT NULL,
  nombre varchar(60) NOT NULL,
  localidad varchar(40) NOT NULL,
  PRIMARY KEY (codigo_sede)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- LECTOR
CREATE TABLE LECTOR (
  carne varchar(10) NOT NULL,
  nombres varchar(50) NOT NULL,
  apellidos varchar(50) NOT NULL,
  fecha_nacimiento date NOT NULL,
  correo varchar(80) DEFAULT NULL,
  tipo_lector enum('infantil','adulto') NOT NULL,
  acudiente varchar(80) DEFAULT NULL,
  ocupacion varchar(40) DEFAULT NULL,
  PRIMARY KEY (carne),
  UNIQUE KEY uq_lector_correo (correo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- BIBLIOTECARIO
CREATE TABLE BIBLIOTECARIO (
  id_bibliotecario varchar(15) NOT NULL,
  nombres varchar(50) NOT NULL,
  apellidos varchar(50) NOT NULL,
  turno enum('manana','tarde') NOT NULL,
  codigo_sede char(3) NOT NULL,
  PRIMARY KEY (id_bibliotecario),
  CONSTRAINT fk_bibliotecario_codigo_sede FOREIGN KEY (codigo_sede) REFERENCES SEDE (codigo_sede)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- LEC_TELEFONO
CREATE TABLE LEC_TELEFONO (
  carne varchar(10) NOT NULL,
  telefono varchar(15) NOT NULL,
  PRIMARY KEY (carne, telefono),
  CONSTRAINT fk_lec_telefono_carne FOREIGN KEY (carne) REFERENCES LECTOR (carne)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- LIBRO
CREATE TABLE LIBRO (
  isbn varchar(13) NOT NULL,
  titulo varchar(100) NOT NULL,
  anio int NOT NULL,
  id_editorial int NOT NULL,
  PRIMARY KEY (isbn),
  CONSTRAINT fk_libro_id_editorial FOREIGN KEY (id_editorial) REFERENCES EDITORIAL (id_editorial)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- EJEMPLAR
CREATE TABLE EJEMPLAR (
  codigo_barras varchar(10) NOT NULL,
  estado enum('bueno','regular','danado') NOT NULL,
  isbn varchar(13) NOT NULL,
  codigo_sede char(3) NOT NULL,
  PRIMARY KEY (codigo_barras),
  CONSTRAINT fk_ejemplar_isbn FOREIGN KEY (isbn) REFERENCES LIBRO (isbn),
  CONSTRAINT fk_ejemplar_codigo_sede FOREIGN KEY (codigo_sede) REFERENCES SEDE (codigo_sede)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- AUTORIA
CREATE TABLE AUTORIA (
  id_autor int NOT NULL,
  isbn varchar(13) NOT NULL,
  PRIMARY KEY (id_autor, isbn),
  CONSTRAINT fk_autoria_id_autor FOREIGN KEY (id_autor) REFERENCES AUTOR (id_autor),
  CONSTRAINT fk_autoria_isbn FOREIGN KEY (isbn) REFERENCES LIBRO (isbn)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- PRESTAMO
CREATE TABLE PRESTAMO (
  carne varchar(10) NOT NULL,
  codigo_barras varchar(10) NOT NULL,
  id_bibliotecario varchar(15) NOT NULL,
  fecha_prestamo date NOT NULL,
  fecha_devolucion date DEFAULT NULL,
  PRIMARY KEY (carne, codigo_barras, id_bibliotecario, fecha_prestamo),
  CONSTRAINT fk_prestamo_carne FOREIGN KEY (carne) REFERENCES LECTOR (carne),
  CONSTRAINT fk_prestamo_codigo_barras FOREIGN KEY (codigo_barras) REFERENCES EJEMPLAR (codigo_barras),
  CONSTRAINT fk_prestamo_id_bibliotecario FOREIGN KEY (id_bibliotecario) REFERENCES BIBLIOTECARIO (id_bibliotecario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
