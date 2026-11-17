-- Teatro - script completo (01 + 02 + 04 + 05). Probado en MySQL 8.0.

-- Teatro - Bases de Datos 1
-- 01: creacion de la base de datos y de las 10 tablas
-- Las tablas van en orden: primero las que no dependen de otras.

SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS teatro
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE teatro;

-- ESPECTADOR
CREATE TABLE ESPECTADOR (
  documento varchar(15) NOT NULL,
  nombres varchar(50) NOT NULL,
  apellidos varchar(50) NOT NULL,
  fecha_nacimiento date NOT NULL,
  correo varchar(80) NOT NULL,
  PRIMARY KEY (documento),
  UNIQUE KEY uq_espectador_correo (correo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- TEATRO
CREATE TABLE TEATRO (
  codigo_teatro char(3) NOT NULL,
  nombre varchar(60) NOT NULL,
  direccion varchar(80) NOT NULL,
  aforo int NOT NULL,
  PRIMARY KEY (codigo_teatro)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- OBRA
CREATE TABLE OBRA (
  id_obra int NOT NULL,
  titulo varchar(80) NOT NULL,
  autor varchar(60) NOT NULL,
  duracion_min int NOT NULL,
  PRIMARY KEY (id_obra)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ACTOR
CREATE TABLE ACTOR (
  id_actor varchar(15) NOT NULL,
  nombre_artistico varchar(60) NOT NULL,
  nombres varchar(50) NOT NULL,
  apellidos varchar(50) NOT NULL,
  tipo_actor enum('cantante','bailarin','ambos') DEFAULT NULL,
  registro_vocal varchar(20) DEFAULT NULL,
  estilo_baile varchar(30) DEFAULT NULL,
  PRIMARY KEY (id_actor),
  UNIQUE KEY uq_actor_nombre_artistico (nombre_artistico)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ESP_TELEFONO
CREATE TABLE ESP_TELEFONO (
  documento varchar(15) NOT NULL,
  telefono varchar(15) NOT NULL,
  PRIMARY KEY (documento, telefono),
  CONSTRAINT fk_esp_telefono_documento FOREIGN KEY (documento) REFERENCES ESPECTADOR (documento)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- OBR_GENERO
CREATE TABLE OBR_GENERO (
  id_obra int NOT NULL,
  genero varchar(20) NOT NULL,
  PRIMARY KEY (id_obra, genero),
  CONSTRAINT fk_obr_genero_id_obra FOREIGN KEY (id_obra) REFERENCES OBRA (id_obra)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- REPARTO
CREATE TABLE REPARTO (
  id_actor varchar(15) NOT NULL,
  id_obra int NOT NULL,
  personaje varchar(40) NOT NULL,
  PRIMARY KEY (id_actor, id_obra),
  CONSTRAINT fk_reparto_id_actor FOREIGN KEY (id_actor) REFERENCES ACTOR (id_actor),
  CONSTRAINT fk_reparto_id_obra FOREIGN KEY (id_obra) REFERENCES OBRA (id_obra)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- SUPLENCIA
CREATE TABLE SUPLENCIA (
  id_suplente varchar(15) NOT NULL,
  id_titular varchar(15) NOT NULL,
  PRIMARY KEY (id_suplente),
  CONSTRAINT fk_suplencia_id_suplente FOREIGN KEY (id_suplente) REFERENCES ACTOR (id_actor),
  CONSTRAINT fk_suplencia_id_titular FOREIGN KEY (id_titular) REFERENCES ACTOR (id_actor)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- FUNCION
CREATE TABLE FUNCION (
  id_funcion int NOT NULL,
  fecha date NOT NULL,
  hora time NOT NULL,
  precio decimal(10,2) NOT NULL,
  codigo_teatro char(3) NOT NULL,
  id_obra int NOT NULL,
  PRIMARY KEY (id_funcion),
  CONSTRAINT fk_funcion_codigo_teatro FOREIGN KEY (codigo_teatro) REFERENCES TEATRO (codigo_teatro),
  CONSTRAINT fk_funcion_id_obra FOREIGN KEY (id_obra) REFERENCES OBRA (id_obra)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- BOLETA
CREATE TABLE BOLETA (
  documento varchar(15) NOT NULL,
  id_funcion int NOT NULL,
  fila char(1) NOT NULL,
  silla int NOT NULL,
  PRIMARY KEY (documento, id_funcion),
  CONSTRAINT fk_boleta_documento FOREIGN KEY (documento) REFERENCES ESPECTADOR (documento),
  CONSTRAINT fk_boleta_id_funcion FOREIGN KEY (id_funcion) REFERENCES FUNCION (id_funcion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Teatro - Bases de Datos 1
-- 02: registros de prueba, en una sola transaccion

USE teatro;

START TRANSACTION;

INSERT INTO ESPECTADOR (documento, nombres, apellidos, fecha_nacimiento, correo) VALUES
('3010', 'Mariana', 'Acosta Rey', '1991-02-11', 'mariana.acosta@correo.co'),
('3020', 'Julian', 'Bravo Diaz', '1987-05-23', 'julian.bravo@correo.co'),
('3030', 'Natalia', 'Cortes Gil', '2000-09-02', 'natalia.cortes@correo.co'),
('3040', 'Hernan', 'Duarte Paz', '1965-12-15', 'hernan.duarte@correo.co'),
('3050', 'Isabel', 'Franco Luna', '1995-03-30', 'isabel.franco@correo.co'),
('3060', 'Tomas', 'Guerra Vela', '2004-07-18', 'tomas.guerra@correo.co');

INSERT INTO TEATRO (codigo_teatro, nombre, direccion, aforo) VALUES
('COL', 'Teatro Colon', 'Cll 10 # 5-32', 900),
('MAY', 'Teatro Mayor', 'Av Cll 170 # 67-51', 1300),
('LIB', 'Teatro Libre', 'Cra 11 # 61-80', 350);

INSERT INTO OBRA (id_obra, titulo, autor, duracion_min) VALUES
(1, 'La Casa de Bernarda Alba', 'Federico Garcia Lorca', 110),
(2, 'Cats', 'Andrew Lloyd Webber', 150),
(3, 'El Avaro', 'Moliere', 95),
(4, 'Chicago', 'John Kander', 140),
(5, 'Esperando a Godot', 'Samuel Beckett', 120);

INSERT INTO ACTOR (id_actor, nombre_artistico, nombres, apellidos, tipo_actor, registro_vocal, estilo_baile) VALUES
('A01', 'Lucho Ramos', 'Luis Fernando', 'Ramos Pardo', NULL, NULL, NULL),
('A02', 'Vicky Mar', 'Victoria', 'Martinez Cruz', 'cantante', 'soprano', NULL),
('A03', 'Tono Danza', 'Antonio', 'Gil Rojas', 'bailarin', NULL, 'jazz'),
('A04', 'Cami Luz', 'Camila', 'Luz Herrera', 'ambos', 'mezzosoprano', 'contemporaneo'),
('A05', 'Pedro Sol', 'Pedro', 'Soler Mesa', NULL, NULL, NULL),
('A06', 'Sara Vega', 'Sara', 'Vega Leon', 'ambos', 'contralto', 'tap'),
('A07', 'Diego Ruiz', 'Diego', 'Ruiz Tapia', 'cantante', 'baritono', NULL);

INSERT INTO ESP_TELEFONO (documento, telefono) VALUES
('3010', '3011234567'),
('3010', '6012345678'),
('3020', '3022345678'),
('3030', '3033456789'),
('3030', '6014567890'),
('3040', '3044567890'),
('3050', '3055678901'),
('3060', '3066789012');

INSERT INTO OBR_GENERO (id_obra, genero) VALUES
(1, 'drama'),
(2, 'musical'),
(2, 'infantil'),
(3, 'comedia'),
(4, 'musical'),
(4, 'comedia'),
(5, 'drama'),
(5, 'absurdo');

INSERT INTO REPARTO (id_actor, id_obra, personaje) VALUES
('A01', 3, 'Harpagon'),
('A05', 3, 'Cleante'),
('A02', 2, 'Grizabella'),
('A04', 2, 'Jellylorum'),
('A03', 2, 'Mistoffelees'),
('A04', 4, 'Roxie Hart'),
('A06', 4, 'Velma Kelly'),
('A07', 4, 'Billy Flynn'),
('A06', 1, 'Adela'),
('A02', 1, 'Bernarda'),
('A01', 5, 'Vladimir'),
('A05', 5, 'Estragon');

INSERT INTO SUPLENCIA (id_suplente, id_titular) VALUES
('A05', 'A01'),
('A06', 'A04'),
('A07', 'A02');

INSERT INTO FUNCION (id_funcion, fecha, hora, precio, codigo_teatro, id_obra) VALUES
(1, '2026-12-04', '20:00', 85000, 'COL', 1),
(2, '2026-12-05', '20:00', 85000, 'COL', 1),
(3, '2026-12-05', '19:30', 120000, 'MAY', 2),
(4, '2026-12-06', '16:00', 95000, 'MAY', 4),
(5, '2026-12-06', '20:00', 45000, 'LIB', 3),
(6, '2026-12-07', '18:00', 45000, 'LIB', 3);

INSERT INTO BOLETA (documento, id_funcion, fila, silla) VALUES
('3010', 1, 'C', 10),
('3010', 3, 'F', 4),
('3010', 5, 'A', 2),
('3020', 1, 'C', 11),
('3030', 1, 'D', 1),
('3030', 2, 'B', 7),
('3040', 3, 'F', 5),
('3050', 4, 'H', 12),
('3060', 4, 'H', 13),
('3020', 6, 'A', 1);

COMMIT;

-- Teatro - Bases de Datos 1
-- 04: restricciones adicionales de los supuestos

USE teatro;

-- quien es cantante debe tener sus datos
ALTER TABLE ACTOR ADD CONSTRAINT ck_actor_cantante CHECK (
  tipo_actor IS NULL OR tipo_actor NOT IN ('cantante', 'ambos') OR (registro_vocal IS NOT NULL));

-- quien es bailarin debe tener sus datos
ALTER TABLE ACTOR ADD CONSTRAINT ck_actor_bailarin CHECK (
  tipo_actor IS NULL OR tipo_actor NOT IN ('bailarin', 'ambos') OR (estilo_baile IS NOT NULL));

-- un actor no puede ser suplente de si mismo
ALTER TABLE SUPLENCIA ADD CONSTRAINT ck_suplencia_distinto CHECK (id_suplente <> id_titular);

-- una silla no se vende dos veces en la misma funcion
ALTER TABLE BOLETA ADD CONSTRAINT uq_boleta_silla UNIQUE (id_funcion, fila, silla);

-- precio y aforo positivos
ALTER TABLE FUNCION ADD CONSTRAINT ck_funcion_precio CHECK (precio > 0);
ALTER TABLE TEATRO ADD CONSTRAINT ck_teatro_aforo CHECK (aforo > 0);

-- Teatro - Bases de Datos 1
-- 05: vistas (consultas guardadas, no guardan datos)

USE teatro;

-- edad es derivado: no se guarda, se calcula
CREATE OR REPLACE VIEW v_espectador_edad AS
SELECT x.documento, TIMESTAMPDIFF(YEAR, x.fecha_nacimiento, CURDATE()) AS edad
FROM ESPECTADOR x;
