-- Agencia de turismo - script completo (01 + 02 + 04 + 05). Probado en MySQL 8.0.

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

-- Agencia de turismo - Bases de Datos 1
-- 02: registros de prueba, en una sola transaccion

USE turismo;

START TRANSACTION;

INSERT INTO DESTINO (id_destino, nombre, pais, clima) VALUES
(1, 'Cartagena', 'Colombia', 'calido'),
(2, 'Eje Cafetero', 'Colombia', 'templado'),
(3, 'San Andres', 'Colombia', 'calido'),
(4, 'Cusco', 'Peru', 'frio'),
(5, 'Cancun', 'Mexico', 'calido'),
(6, 'Leticia', 'Colombia', 'humedo');

INSERT INTO TURISTA (documento, nombres, apellidos, fecha_nacimiento, correo) VALUES
('5010', 'Alejandra', 'Bermudez Cano', '1989-04-14', 'alejandra.bermudez@correo.co'),
('5020', 'Ricardo', 'Salgado Ruiz', '1975-08-02', 'ricardo.salgado@correo.co'),
('5030', 'Daniela', 'Uribe Mora', '1996-12-09', 'daniela.uribe@correo.co'),
('5040', 'Fernando', 'Lara Gil', '1982-03-27', 'fernando.lara@correo.co'),
('5050', 'Carolina', 'Mesa Pinto', '2001-06-16', 'carolina.mesa@correo.co'),
('5060', 'Gabriel', 'Nunez Paz', '1993-10-05', 'gabriel.nunez@correo.co');

INSERT INTO OFICINA (codigo_oficina, ciudad, direccion) VALUES
('BOG', 'Bogota', 'Cll 93 # 13-24'),
('MDE', 'Medellin', 'Cra 43A # 1-50'),
('CTG', 'Cartagena', 'Av San Martin # 8-30');

INSERT INTO TUR_TELEFONO (documento, telefono) VALUES
('5010', '3001234500'),
('5010', '6013456700'),
('5020', '3112345600'),
('5030', '3123456700'),
('5030', '6015678900'),
('5040', '3134567800'),
('5050', '3145678900'),
('5060', '3156789000');

INSERT INTO HOTEL (id_hotel, nombre, estrellas, id_destino) VALUES
(1, 'Hotel Caribe', 5, 1),
(2, 'Hacienda Venecia', 4, 2),
(3, 'Decameron Aquarium', 4, 3),
(4, 'Casa Andina', 3, 4),
(5, 'Grand Oasis', 5, 5),
(6, 'Hotel Charleston', 5, 1),
(7, 'Waira Selva', 3, 6);

INSERT INTO GUIA (id_guia, nombres, apellidos, registro_rnt, codigo_oficina) VALUES
('G01', 'Camilo', 'Reyes Pena', 'RNT-10234', 'BOG'),
('G02', 'Mariana', 'Ochoa Vela', 'RNT-11876', 'MDE'),
('G03', 'Jhon', 'Palacios Mena', 'RNT-09981', 'CTG'),
('G04', 'Luisa', 'Quiroga Rey', 'RNT-12450', 'BOG');

INSERT INTO PAQUETE (codigo_paquete, nombre, dias, precio, codigo_oficina) VALUES
('CAR-01', 'Cartagena Colonial', 4, 1850000, 'CTG'),
('EJE-02', 'Ruta del Cafe', 5, 1600000, 'MDE'),
('SAI-03', 'San Andres Todo Incluido', 5, 2900000, 'BOG'),
('CUS-04', 'Cusco y Machu Picchu', 7, 5400000, 'BOG'),
('CAN-05', 'Cancun Caribe', 6, 6200000, 'MDE'),
('AMA-06', 'Amazonas Selva', 4, 2300000, 'BOG');

INSERT INTO NACIONAL (codigo_paquete, transporte) VALUES
('CAR-01', 'aereo'),
('EJE-02', 'terrestre'),
('SAI-03', 'aereo'),
('AMA-06', 'aereo');

INSERT INTO INTERNACIONAL (codigo_paquete, pais, requiere_visa) VALUES
('CUS-04', 'Peru', 'no'),
('CAN-05', 'Mexico', 'no');

INSERT INTO GUI_IDIOMA (id_guia, idioma) VALUES
('G01', 'espanol'),
('G01', 'ingles'),
('G02', 'espanol'),
('G03', 'espanol'),
('G03', 'ingles'),
('G03', 'frances'),
('G04', 'espanol'),
('G04', 'portugues');

INSERT INTO GUIA_DESTINO (id_guia, id_destino) VALUES
('G01', 2),
('G01', 4),
('G02', 2),
('G03', 1),
('G03', 3),
('G04', 5),
('G04', 4);

INSERT INTO ITINERARIO (codigo_paquete, id_destino, noches) VALUES
('CAR-01', 1, 3),
('EJE-02', 2, 4),
('SAI-03', 3, 4),
('SAI-03', 1, 1),
('CUS-04', 4, 6),
('CAN-05', 5, 5),
('AMA-06', 6, 3);

INSERT INTO VENTA (documento, codigo_paquete, fecha_salida, valor_pagado) VALUES
('5010', 'CAR-01', '2026-12-12', 1850000),
('5010', 'EJE-02', '2027-01-08', 1600000),
('5010', 'CUS-04', '2027-03-20', 5400000),
('5020', 'CAR-01', '2026-12-12', 1850000),
('5030', 'EJE-02', '2027-01-08', 1520000),
('5030', 'SAI-03', '2027-02-14', 2900000),
('5040', 'CAN-05', '2027-04-01', 6200000),
('5050', 'CAR-01', '2026-12-19', 1850000),
('5060', 'SAI-03', '2027-02-14', 2755000);

COMMIT;

-- Agencia de turismo - Bases de Datos 1
-- 04: restricciones adicionales de los supuestos

USE turismo;

-- estrellas de 1 a 5
ALTER TABLE HOTEL ADD CONSTRAINT ck_hotel_estrellas CHECK (estrellas BETWEEN 1 AND 5);

-- dias, noches y valores positivos
ALTER TABLE PAQUETE ADD CONSTRAINT ck_paquete_valores CHECK (dias > 0 AND precio > 0);
ALTER TABLE ITINERARIO ADD CONSTRAINT ck_itinerario_noches CHECK (noches > 0);
ALTER TABLE VENTA ADD CONSTRAINT ck_venta_valor CHECK (valor_pagado > 0);

-- Agencia de turismo - Bases de Datos 1
-- 05: vistas (consultas guardadas, no guardan datos)

USE turismo;

-- edad es derivado: no se guarda, se calcula
CREATE OR REPLACE VIEW v_turista_edad AS
SELECT x.documento, TIMESTAMPDIFF(YEAR, x.fecha_nacimiento, CURDATE()) AS edad
FROM TURISTA x;

-- a qué subtipo pertenece cada paquete
CREATE OR REPLACE VIEW v_tipo_paquete AS
SELECT x.codigo_paquete,
       CASE
         WHEN s0.codigo_paquete IS NOT NULL THEN 'nacional'
         WHEN s1.codigo_paquete IS NOT NULL THEN 'internacional'
         ELSE 'ninguno'
       END AS tipo
FROM PAQUETE x
LEFT JOIN NACIONAL s0 ON s0.codigo_paquete = x.codigo_paquete
LEFT JOIN INTERNACIONAL s1 ON s1.codigo_paquete = x.codigo_paquete;
