-- Red de bibliotecas - script completo (01 + 02 + 04 + 05). Probado en MySQL 8.0.

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

-- Red de bibliotecas - Bases de Datos 1
-- 02: registros de prueba, en una sola transaccion

USE biblioteca;

START TRANSACTION;

INSERT INTO AUTOR (id_autor, nombre, nacionalidad) VALUES
(1, 'Gabriel Garcia Marquez', 'colombiana'),
(2, 'Isabel Allende', 'chilena'),
(3, 'Julio Cortazar', 'argentina'),
(4, 'Rafael Pombo', 'colombiana'),
(5, 'Laura Restrepo', 'colombiana'),
(6, 'Pilar Quintana', 'colombiana');

INSERT INTO EDITORIAL (id_editorial, nombre, pais) VALUES
(1, 'Penguin Random House', 'Espana'),
(2, 'Planeta', 'Espana'),
(3, 'Panamericana', 'Colombia');

INSERT INTO SEDE (codigo_sede, nombre, localidad) VALUES
('VBA', 'Biblioteca Virgilio Barco', 'Teusaquillo'),
('TIN', 'Biblioteca El Tintal', 'Kennedy'),
('TUN', 'Biblioteca El Tunal', 'Tunjuelito');

INSERT INTO LECTOR (carne, nombres, apellidos, fecha_nacimiento, correo, tipo_lector, acudiente, ocupacion) VALUES
('L-1001', 'Valeria', 'Cruz Leon', '2014-03-02', NULL, 'infantil', 'Martha Leon', NULL),
('L-1002', 'Nicolas', 'Arias Cano', '1990-07-19', 'nicolas.arias@correo.co', 'adulto', NULL, 'contador'),
('L-1003', 'Emilio', 'Duarte Gil', '1958-11-04', 'emilio.duarte@correo.co', 'adulto', NULL, 'pensionado'),
('L-1004', 'Luciana', 'Romero Sol', '2016-09-27', NULL, 'infantil', 'Andres Romero', NULL),
('L-1005', 'Ignacio', 'Vargas Lima', '2001-01-15', 'ignacio.vargas@correo.co', 'adulto', NULL, 'estudiante'),
('L-1006', 'Sofia', 'Beltran Ruiz', '1985-05-08', 'sofia.beltran@correo.co', 'adulto', NULL, 'docente');

INSERT INTO BIBLIOTECARIO (id_bibliotecario, nombres, apellidos, turno, codigo_sede) VALUES
('B01', 'Hernando', 'Lozada Rey', 'manana', 'VBA'),
('B02', 'Patricia', 'Ospina Vela', 'tarde', 'VBA'),
('B03', 'German', 'Riascos Mesa', 'manana', 'TIN'),
('B04', 'Teresa', 'Galindo Paz', 'tarde', 'TUN');

INSERT INTO LEC_TELEFONO (carne, telefono) VALUES
('L-1001', '3201112233'),
('L-1002', '3002223344'),
('L-1002', '6013334455'),
('L-1003', '3104445566'),
('L-1004', '3115556677'),
('L-1005', '3126667788'),
('L-1005', '6017778899'),
('L-1006', '3138889900');

INSERT INTO LIBRO (isbn, titulo, anio, id_editorial) VALUES
('9789584279', 'Cien anos de soledad', 1967, 1),
('9789584280', 'Cronica de una muerte anunciada', 1981, 1),
('9789584281', 'La casa de los espiritus', 1982, 2),
('9789584282', 'Rayuela', 1963, 1),
('9789584283', 'Cuentos pintados', 1867, 3),
('9789584284', 'Delirio', 2004, 2),
('9789584285', 'Cuentos de America', 2010, 3);

INSERT INTO EJEMPLAR (codigo_barras, estado, isbn, codigo_sede) VALUES
('EJ-001', 'bueno', '9789584279', 'VBA'),
('EJ-002', 'regular', '9789584279', 'TIN'),
('EJ-003', 'bueno', '9789584280', 'VBA'),
('EJ-004', 'bueno', '9789584281', 'TUN'),
('EJ-005', 'danado', '9789584282', 'VBA'),
('EJ-006', 'bueno', '9789584283', 'TIN'),
('EJ-007', 'bueno', '9789584283', 'TUN'),
('EJ-008', 'regular', '9789584284', 'VBA'),
('EJ-009', 'bueno', '9789584285', 'TIN');

INSERT INTO AUTORIA (id_autor, isbn) VALUES
(1, '9789584279'),
(1, '9789584280'),
(2, '9789584281'),
(3, '9789584282'),
(4, '9789584283'),
(5, '9789584284'),
(3, '9789584285'),
(1, '9789584285');

INSERT INTO PRESTAMO (carne, codigo_barras, id_bibliotecario, fecha_prestamo, fecha_devolucion) VALUES
('L-1002', 'EJ-001', 'B01', '2026-10-01', '2026-10-15'),
('L-1002', 'EJ-003', 'B02', '2026-10-20', '2026-11-02'),
('L-1002', 'EJ-008', 'B01', '2026-11-05', NULL),
('L-1003', 'EJ-001', 'B02', '2026-10-18', '2026-10-30'),
('L-1001', 'EJ-006', 'B03', '2026-10-10', '2026-10-24'),
('L-1004', 'EJ-007', 'B04', '2026-11-03', NULL),
('L-1005', 'EJ-002', 'B03', '2026-11-01', '2026-11-12'),
('L-1006', 'EJ-005', 'B01', '2026-09-15', '2026-09-29'),
('L-1005', 'EJ-001', 'B01', '2026-11-10', NULL);

COMMIT;

-- Red de bibliotecas - Bases de Datos 1
-- 04: restricciones adicionales de los supuestos

USE biblioteca;

-- quien es infantil debe tener sus datos
ALTER TABLE LECTOR ADD CONSTRAINT ck_lector_infantil CHECK (
  tipo_lector IS NULL OR tipo_lector NOT IN ('infantil') OR (acudiente IS NOT NULL));

-- quien es adulto debe tener sus datos
ALTER TABLE LECTOR ADD CONSTRAINT ck_lector_adulto CHECK (
  tipo_lector IS NULL OR tipo_lector NOT IN ('adulto') OR (ocupacion IS NOT NULL));

-- la devolucion no puede ser antes del prestamo
ALTER TABLE PRESTAMO ADD CONSTRAINT ck_prestamo_fechas CHECK (fecha_devolucion IS NULL OR fecha_devolucion >= fecha_prestamo);

-- un adulto debe tener correo
ALTER TABLE LECTOR ADD CONSTRAINT ck_lector_correo CHECK (tipo_lector = 'infantil' OR correo IS NOT NULL);

-- Red de bibliotecas - Bases de Datos 1
-- 05: vistas (consultas guardadas, no guardan datos)

USE biblioteca;

-- edad es derivado: no se guarda, se calcula
CREATE OR REPLACE VIEW v_lector_edad AS
SELECT x.carne, TIMESTAMPDIFF(YEAR, x.fecha_nacimiento, CURDATE()) AS edad
FROM LECTOR x;
