-- Red de bibliotecas - script completo (01 + 02 + 04 + 05). Probado en MySQL 8.0.

-- Red de bibliotecas - Bases de Datos 1
-- 01: creacion de la sede de datos y de las 9 tablas
SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS biblioteca
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE biblioteca;

CREATE TABLE SEDE (
  codigo_sede char(3) NOT NULL,
  nombre varchar(80) NOT NULL,
  ciudad varchar(50) NOT NULL,
  pais varchar(50) NOT NULL,
  PRIMARY KEY (codigo_sede)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE PERSONA (
  documento varchar(15) NOT NULL,
  nombres varchar(50) NOT NULL,
  apellidos varchar(50) NOT NULL,
  fecha_nacimiento date NOT NULL,
  tipo_persona enum('bibliotecario','lector','ambos') NOT NULL,
  registro varchar(10) DEFAULT NULL,
  anios_experiencia int DEFAULT NULL,
  codigo_sede char(3) DEFAULT NULL,
  correo varchar(80) DEFAULT NULL,
  prestamos int DEFAULT NULL,
  PRIMARY KEY (documento),
  UNIQUE KEY uq_persona_registro (registro),
  UNIQUE KEY uq_persona_correo (correo),
  KEY fk_persona_sede (codigo_sede),
  CONSTRAINT fk_persona_sede FOREIGN KEY (codigo_sede) REFERENCES SEDE (codigo_sede)
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
  codigo_sede char(3) NOT NULL,
  PRIMARY KEY (codigo_sala),
  KEY fk_sala_sede (codigo_sede),
  CONSTRAINT fk_sala_sede FOREIGN KEY (codigo_sede) REFERENCES SEDE (codigo_sede)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE SALA_COMPUTO (
  codigo_sala varchar(10) NOT NULL,
  num_equipos int NOT NULL,
  PRIMARY KEY (codigo_sala),
  CONSTRAINT fk_sala_computo_sala FOREIGN KEY (codigo_sala) REFERENCES SALA (codigo_sala)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE SALA_INFANTIL (
  codigo_sala varchar(10) NOT NULL,
  area_m2 decimal(10,2) NOT NULL,
  PRIMARY KEY (codigo_sala),
  CONSTRAINT fk_sala_infantil_sala FOREIGN KEY (codigo_sala) REFERENCES SALA (codigo_sala)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE TALLER (
  id_taller bigint NOT NULL AUTO_INCREMENT,
  codigo varchar(8) NOT NULL,
  fecha date NOT NULL,
  hora_inicio time NOT NULL,
  tema varchar(50) NOT NULL,
  codigo_sala varchar(10) NOT NULL,
  sede_taller char(3) NOT NULL,
  PRIMARY KEY (id_taller),
  UNIQUE KEY uq_taller_codigo_fecha (codigo,fecha),
  KEY fk_taller_sala (codigo_sala),
  KEY fk_taller_sede (sede_taller),
  CONSTRAINT fk_taller_sala FOREIGN KEY (codigo_sala) REFERENCES SALA (codigo_sala),
  CONSTRAINT fk_taller_sede FOREIGN KEY (sede_taller) REFERENCES SEDE (codigo_sede)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE ORIENTACION (
  documento varchar(15) NOT NULL,
  id_taller bigint NOT NULL,
  rol enum('principal','apoyo') NOT NULL,
  PRIMARY KEY (documento,id_taller),
  KEY fk_orientacion_taller (id_taller),
  CONSTRAINT fk_orientacion_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento),
  CONSTRAINT fk_orientacion_taller FOREIGN KEY (id_taller) REFERENCES TALLER (id_taller)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE INSCRIPCION (
  documento varchar(15) NOT NULL,
  id_taller bigint NOT NULL,
  puesto varchar(4) NOT NULL,
  modalidad enum('presencial','virtual') NOT NULL,
  PRIMARY KEY (documento,id_taller),
  UNIQUE KEY uq_inscripcion_taller_puesto (id_taller,puesto),
  CONSTRAINT fk_inscripcion_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento),
  CONSTRAINT fk_inscripcion_taller FOREIGN KEY (id_taller) REFERENCES TALLER (id_taller)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Red de bibliotecas - Bases de Datos 1
-- 02: registros de prueba (64), en una sola transaccion

USE biblioteca;



START TRANSACTION;



INSERT INTO SEDE (codigo_sede, nombre, ciudad, pais) VALUES
('BOG', 'Biblioteca Virgilio Barco', 'Bogota', 'Colombia'),
('MED', 'Biblioteca EPM', 'Medellin', 'Colombia'),
('CAL', 'Biblioteca Departamental', 'Cali', 'Colombia');

INSERT INTO PERSONA (documento, nombres, apellidos, fecha_nacimiento, tipo_persona,
                     registro, anios_experiencia, codigo_sede, correo, prestamos) VALUES
('1010', 'Hernando', 'Lozada Rey', '1980-03-12', 'bibliotecario', 'BIB-1101', 17, 'BOG', NULL, NULL),
('1020', 'Patricia', 'Ospina Vela', '1988-07-25', 'bibliotecario', 'BIB-1288', 9, 'MED', NULL, NULL),
('1030', 'German', 'Riascos Mesa', '1975-11-02', 'bibliotecario', 'BIB-0975', 28, 'BOG', NULL, NULL),
('1040', 'Teresa', 'Galindo Paz', '1992-01-18', 'ambos', 'BIB-1390', 5, 'CAL', 'teresa.galindo@correo.co', 40),
('2010', 'Nicolas', 'Arias Cano', '2000-05-30', 'lector', NULL, NULL, NULL, 'nicolas.arias@correo.co', 85),
('2020', 'Valentina', 'Cruz Leon', '1997-09-14', 'lector', NULL, NULL, NULL, 'valentina.cruz@correo.co', 12),
('2030', 'Emilio', 'Duarte Gil', '1985-12-01', 'lector', NULL, NULL, NULL, 'emilio.duarte@correo.co', 130),
('2040', 'Luciana', 'Romero Sol', '2003-04-22', 'lector', NULL, NULL, NULL, 'luciana.romero@correo.co', 3),
('2050', 'Ignacio', 'Vargas Lima', '1979-08-08', 'lector', NULL, NULL, NULL, 'ignacio.vargas@correo.co', 66);

INSERT INTO PER_TELEFONO (documento, telefono) VALUES
('1010', '3001112233'),
('1010', '6015550101'),
('1020', '3104445566'),
('1030', '3207778899'),
('1040', '3156667788'),
('1040', '3019990000'),
('2010', '3121234567'),
('2020', '3189876543'),
('2030', '3001239876'),
('2030', '6047771234'),
('2040', '3165554433'),
('2050', '3112223344');

INSERT INTO SALA (codigo_sala, nombre_sala, piso, codigo_sede) VALUES
('SL-01', 'Sala Digital', 'Piso 2', 'BOG'),
('SL-02', 'Sala Multimedia', 'Piso 1', 'MED'),
('SL-03', 'Sala Digital', 'Piso 3', 'CAL'),
('SL-04', 'Sala Infantil', 'Piso 1', 'BOG'),
('SL-05', 'Hemeroteca', 'Piso 1', 'BOG');

INSERT INTO SALA_COMPUTO (codigo_sala, num_equipos) VALUES
('SL-01', 30),
('SL-02', 24),
('SL-03', 20);

INSERT INTO SALA_INFANTIL (codigo_sala, area_m2) VALUES
('SL-04', 120.00);

INSERT INTO TALLER (id_taller, codigo, fecha, hora_inicio, tema, codigo_sala, sede_taller) VALUES
(1, 'LEC01', '2026-09-05', '10:00', 'Club de lectura', 'SL-01', 'BOG'),
(2, 'ESC02', '2026-09-05', '15:00', 'Escritura creativa', 'SL-02', 'MED'),
(3, 'LEC03', '2026-09-06', '10:00', 'Club de lectura', 'SL-03', 'CAL'),
(4, 'LEC01', '2026-09-07', '10:00', 'Club de lectura', 'SL-01', 'BOG'),
(5, 'CUE05', '2026-09-07', '16:00', 'Cuentos para ninos', 'SL-04', 'BOG'),
(6, 'INV06', '2026-09-08', '14:00', 'Investigacion', 'SL-02', 'MED');

INSERT INTO ORIENTACION (documento, id_taller, rol) VALUES
('1010', 1, 'principal'),
('1040', 1, 'apoyo'),
('1020', 2, 'principal'),
('1030', 2, 'apoyo'),
('1040', 3, 'principal'),
('1020', 3, 'apoyo'),
('1030', 4, 'principal'),
('1010', 4, 'apoyo'),
('1030', 5, 'principal'),
('1010', 5, 'apoyo'),
('1020', 6, 'principal'),
('1040', 6, 'apoyo');

INSERT INTO INSCRIPCION (documento, id_taller, puesto, modalidad) VALUES
('2010', 1, '12', 'presencial'),
('2010', 3, '5', 'presencial'),
('2010', 4, '14', 'presencial'),
('2020', 1, '2', 'virtual'),
('2020', 2, '8', 'presencial'),
('2030', 2, '1', 'virtual'),
('2030', 6, '3', 'virtual'),
('2040', 3, '20', 'presencial'),
('2040', 6, '22', 'presencial'),
('2050', 1, '15', 'presencial'),
('2050', 3, '9', 'presencial'),
('2050', 4, '4', 'virtual'),
('1040', 2, '18', 'presencial');



COMMIT;

-- Red de bibliotecas - Bases de Datos 1
-- 04: restricciones adicionales de los supuestos
USE biblioteca;

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_bibliotecario CHECK (
  tipo_persona = 'lector'
  OR (registro IS NOT NULL AND anios_experiencia IS NOT NULL AND codigo_sede IS NOT NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_lector CHECK (
  tipo_persona <> 'lector'
  OR (registro IS NULL AND anios_experiencia IS NULL AND codigo_sede IS NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_lector CHECK (
  tipo_persona = 'bibliotecario' OR (correo IS NOT NULL AND prestamos IS NOT NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_bibliotecario CHECK (
  tipo_persona <> 'bibliotecario' OR (correo IS NULL AND prestamos IS NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_horas CHECK (anios_experiencia IS NULL OR anios_experiencia >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_prestamos CHECK (prestamos IS NULL OR prestamos >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_correo CHECK (correo IS NULL OR correo LIKE '%_@_%._%');

ALTER TABLE SALA_COMPUTO ADD CONSTRAINT ck_sala_computo_asientos CHECK (num_equipos > 0);
ALTER TABLE SALA_INFANTIL ADD CONSTRAINT ck_sala_infantil_capacidad CHECK (area_m2 > 0);

ALTER TABLE TALLER ADD CONSTRAINT ck_taller_tema CHECK (CHAR_LENGTH(TRIM(tema)) > 0);

ALTER TABLE ORIENTACION ADD COLUMN es_principal tinyint
  GENERATED ALWAYS AS (IF(rol = 'principal', 1, NULL)) VIRTUAL;
ALTER TABLE ORIENTACION ADD CONSTRAINT uq_orientacion_principal UNIQUE (id_taller, es_principal);

SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'biblioteca' AND CONSTRAINT_TYPE IN ('CHECK', 'UNIQUE')
ORDER BY TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME;

-- Red de bibliotecas - Bases de Datos 1
-- 05: vistas
USE biblioteca;

CREATE OR REPLACE VIEW v_persona_edad AS
SELECT p.documento, p.nombres, p.apellidos, p.tipo_persona, p.fecha_nacimiento,
       TIMESTAMPDIFF(YEAR, p.fecha_nacimiento, CURDATE()) AS edad
FROM PERSONA p;

CREATE OR REPLACE VIEW v_tipo_sala AS
SELECT a.codigo_sala, a.piso, a.nombre_sala, a.codigo_sede,
       CASE
         WHEN c.codigo_sala IS NOT NULL THEN 'computo'
         WHEN g.codigo_sala IS NOT NULL THEN 'infantil'
         ELSE 'otro'
       END AS tipo,
       c.num_equipos, g.area_m2
FROM SALA a
LEFT JOIN SALA_COMPUTO c ON c.codigo_sala = a.codigo_sala
LEFT JOIN SALA_INFANTIL g ON g.codigo_sala = a.codigo_sala;

CREATE OR REPLACE VIEW v_orientacion_taller AS
SELECT v.id_taller, v.codigo, v.fecha, v.tema, t.rol,
       p.documento, p.nombres, p.apellidos
FROM ORIENTACION t
JOIN TALLER v ON v.id_taller = t.id_taller
JOIN PERSONA p ON p.documento = t.documento;

CREATE OR REPLACE VIEW v_ocupacion_taller AS
SELECT v.id_taller, v.codigo, v.fecha, v.tema, c.num_equipos,
       COUNT(r.documento) AS ocupados,
       ROUND(100 * COUNT(r.documento) / c.num_equipos, 2) AS porcentaje
FROM TALLER v
JOIN SALA_COMPUTO c ON c.codigo_sala = v.codigo_sala
LEFT JOIN INSCRIPCION r ON r.id_taller = v.id_taller
GROUP BY v.id_taller, v.codigo, v.fecha, v.tema, c.num_equipos;

SELECT * FROM v_tipo_sala;
SELECT * FROM v_ocupacion_taller ORDER BY id_taller;
