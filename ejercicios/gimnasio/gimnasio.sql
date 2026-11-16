-- Gimnasio - script completo (01 + 02 + 04 + 05). Probado en MySQL 8.0.

-- Gimnasio - Bases de Datos 1
-- 01: creacion de la sede de datos y de las 9 tablas
SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS gimnasio
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE gimnasio;

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
  tipo_persona enum('entrenador','socio','ambos') NOT NULL,
  certificacion varchar(10) DEFAULT NULL,
  anios_experiencia int DEFAULT NULL,
  codigo_sede char(3) DEFAULT NULL,
  correo varchar(80) DEFAULT NULL,
  puntos int DEFAULT NULL,
  PRIMARY KEY (documento),
  UNIQUE KEY uq_persona_certificacion (certificacion),
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
  ambiente varchar(40) NOT NULL,
  piso varchar(40) NOT NULL,
  codigo_sede char(3) NOT NULL,
  PRIMARY KEY (codigo_sala),
  KEY fk_sala_sede (codigo_sede),
  CONSTRAINT fk_sala_sede FOREIGN KEY (codigo_sede) REFERENCES SEDE (codigo_sede)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE SALA_CARDIO (
  codigo_sala varchar(10) NOT NULL,
  num_maquinas int NOT NULL,
  PRIMARY KEY (codigo_sala),
  CONSTRAINT fk_sala_cardio_sala FOREIGN KEY (codigo_sala) REFERENCES SALA (codigo_sala)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE PISCINA (
  codigo_sala varchar(10) NOT NULL,
  volumen_m3 decimal(10,2) NOT NULL,
  PRIMARY KEY (codigo_sala),
  CONSTRAINT fk_piscina_sala FOREIGN KEY (codigo_sala) REFERENCES SALA (codigo_sala)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE CLASE (
  id_clase bigint NOT NULL AUTO_INCREMENT,
  codigo varchar(8) NOT NULL,
  fecha date NOT NULL,
  hora_inicio time NOT NULL,
  actividad varchar(50) NOT NULL,
  codigo_sala varchar(10) NOT NULL,
  sede_clase char(3) NOT NULL,
  PRIMARY KEY (id_clase),
  UNIQUE KEY uq_clase_codigo_fecha (codigo,fecha),
  KEY fk_clase_sala (codigo_sala),
  KEY fk_clase_sede (sede_clase),
  CONSTRAINT fk_clase_sala FOREIGN KEY (codigo_sala) REFERENCES SALA (codigo_sala),
  CONSTRAINT fk_clase_sede FOREIGN KEY (sede_clase) REFERENCES SEDE (codigo_sede)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE INSTRUCCION (
  documento varchar(15) NOT NULL,
  id_clase bigint NOT NULL,
  rol enum('principal','apoyo') NOT NULL,
  PRIMARY KEY (documento,id_clase),
  KEY fk_instruccion_clase (id_clase),
  CONSTRAINT fk_instruccion_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento),
  CONSTRAINT fk_instruccion_clase FOREIGN KEY (id_clase) REFERENCES CLASE (id_clase)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE CUPO (
  documento varchar(15) NOT NULL,
  id_clase bigint NOT NULL,
  puesto varchar(4) NOT NULL,
  plan enum('basico','premium') NOT NULL,
  PRIMARY KEY (documento,id_clase),
  UNIQUE KEY uq_cupo_clase_puesto (id_clase,puesto),
  CONSTRAINT fk_cupo_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento),
  CONSTRAINT fk_cupo_clase FOREIGN KEY (id_clase) REFERENCES CLASE (id_clase)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Gimnasio - Bases de Datos 1
-- 02: registros de prueba (64), en una sola transaccion

USE gimnasio;



START TRANSACTION;



INSERT INTO SEDE (codigo_sede, nombre, ciudad, pais) VALUES
('BOG', 'Sede Chapinero', 'Bogota', 'Colombia'),
('MED', 'Sede Laureles', 'Medellin', 'Colombia'),
('BAQ', 'Sede Norte', 'Barranquilla', 'Colombia');

INSERT INTO PERSONA (documento, nombres, apellidos, fecha_nacimiento, tipo_persona,
                     certificacion, anios_experiencia, codigo_sede, correo, puntos) VALUES
('1010', 'Andres Camilo', 'Rueda Lara', '1980-03-12', 'entrenador', 'CER-210', 10, 'BOG', NULL, NULL),
('1020', 'Paola Andrea', 'Vargas Cruz', '1988-07-25', 'entrenador', 'CER-344', 6, 'MED', NULL, NULL),
('1030', 'Sebastian', 'Mora Ortiz', '1975-11-02', 'entrenador', 'CER-118', 14, 'BOG', NULL, NULL),
('1040', 'Natalia Sofia', 'Pineda Gil', '1992-01-18', 'ambos', 'CER-402', 3, 'BAQ', 'natalia.pineda@correo.co', 350),
('2010', 'Luis Miguel', 'Torres Pena', '2000-05-30', 'socio', NULL, NULL, NULL, 'luis.torres@correo.co', 1200),
('2020', 'Laura', 'Gutierrez Sol', '1997-09-14', 'socio', NULL, NULL, NULL, 'laura.gutierrez@correo.co', 90),
('2030', 'Esteban', 'Rojas Prieto', '1985-12-01', 'socio', NULL, NULL, NULL, 'esteban.rojas@correo.co', 2600),
('2040', 'Manuela', 'Cortes Lima', '2003-04-22', 'socio', NULL, NULL, NULL, 'manuela.cortes@correo.co', 0),
('2050', 'Ricardo', 'Herrera Paz', '1979-08-08', 'socio', NULL, NULL, NULL, 'ricardo.herrera@correo.co', 1800);

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

INSERT INTO SALA (codigo_sala, ambiente, piso, codigo_sede) VALUES
('SL-01', 'Cardio 1', 'Piso 1', 'BOG'),
('SL-02', 'Funcional', 'Piso 2', 'MED'),
('SL-03', 'Cardio 2', 'Piso 1', 'BAQ'),
('SL-04', 'Funcional', 'Sotano', 'BOG'),
('SL-05', 'Estiramiento', 'Piso 3', 'BOG');

INSERT INTO SALA_CARDIO (codigo_sala, num_maquinas) VALUES
('SL-01', 40),
('SL-02', 35),
('SL-03', 25);

INSERT INTO PISCINA (codigo_sala, volumen_m3) VALUES
('SL-04', 375.00);

INSERT INTO CLASE (id_clase, codigo, fecha, hora_inicio, actividad, codigo_sala, sede_clase) VALUES
(1, 'SPN01', '2026-03-02', '06:00', 'Spinning', 'SL-01', 'BOG'),
(2, 'FUN02', '2026-03-02', '07:00', 'Funcional', 'SL-02', 'MED'),
(3, 'SPN03', '2026-03-03', '18:00', 'Spinning', 'SL-03', 'BAQ'),
(4, 'SPN01', '2026-03-04', '06:00', 'Spinning', 'SL-01', 'BOG'),
(5, 'NAT05', '2026-03-04', '19:00', 'Natacion', 'SL-04', 'BOG'),
(6, 'YOG06', '2026-03-05', '08:00', 'Yoga', 'SL-02', 'MED');

INSERT INTO INSTRUCCION (documento, id_clase, rol) VALUES
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

INSERT INTO CUPO (documento, id_clase, puesto, plan) VALUES
('2010', 1, 'B12', 'basico'),
('2010', 3, 'B05', 'basico'),
('2010', 4, 'B14', 'basico'),
('2020', 1, 'B02', 'premium'),
('2020', 2, 'C08', 'basico'),
('2030', 2, 'C01', 'premium'),
('2030', 6, 'C03', 'premium'),
('2040', 3, 'B20', 'basico'),
('2040', 6, 'C22', 'basico'),
('2050', 1, 'B15', 'basico'),
('2050', 3, 'B09', 'basico'),
('2050', 4, 'B04', 'premium'),
('1040', 2, 'C18', 'basico');



COMMIT;

-- Gimnasio - Bases de Datos 1
-- 04: restricciones adicionales de los supuestos
USE gimnasio;

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_entrenador CHECK (
  tipo_persona = 'socio'
  OR (certificacion IS NOT NULL AND anios_experiencia IS NOT NULL AND codigo_sede IS NOT NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_socio CHECK (
  tipo_persona <> 'socio'
  OR (certificacion IS NULL AND anios_experiencia IS NULL AND codigo_sede IS NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_socio CHECK (
  tipo_persona = 'entrenador' OR (correo IS NOT NULL AND puntos IS NOT NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_entrenador CHECK (
  tipo_persona <> 'entrenador' OR (correo IS NULL AND puntos IS NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_horas CHECK (anios_experiencia IS NULL OR anios_experiencia >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_puntos CHECK (puntos IS NULL OR puntos >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_correo CHECK (correo IS NULL OR correo LIKE '%_@_%._%');

ALTER TABLE SALA_CARDIO ADD CONSTRAINT ck_sala_cardio_asientos CHECK (num_maquinas > 0);
ALTER TABLE PISCINA ADD CONSTRAINT ck_piscina_capacidad CHECK (volumen_m3 > 0);

ALTER TABLE CLASE ADD CONSTRAINT ck_clase_actividad CHECK (CHAR_LENGTH(TRIM(actividad)) > 0);

ALTER TABLE INSTRUCCION ADD COLUMN es_principal tinyint
  GENERATED ALWAYS AS (IF(rol = 'principal', 1, NULL)) VIRTUAL;
ALTER TABLE INSTRUCCION ADD CONSTRAINT uq_instruccion_principal UNIQUE (id_clase, es_principal);

SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'gimnasio' AND CONSTRAINT_TYPE IN ('CHECK', 'UNIQUE')
ORDER BY TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME;

-- Gimnasio - Bases de Datos 1
-- 05: vistas
USE gimnasio;

CREATE OR REPLACE VIEW v_persona_edad AS
SELECT p.documento, p.nombres, p.apellidos, p.tipo_persona, p.fecha_nacimiento,
       TIMESTAMPDIFF(YEAR, p.fecha_nacimiento, CURDATE()) AS edad
FROM PERSONA p;

CREATE OR REPLACE VIEW v_tipo_sala AS
SELECT a.codigo_sala, a.piso, a.ambiente, a.codigo_sede,
       CASE
         WHEN c.codigo_sala IS NOT NULL THEN 'cardio'
         WHEN g.codigo_sala IS NOT NULL THEN 'piscina'
         ELSE 'otro'
       END AS tipo,
       c.num_maquinas, g.volumen_m3
FROM SALA a
LEFT JOIN SALA_CARDIO c ON c.codigo_sala = a.codigo_sala
LEFT JOIN PISCINA g ON g.codigo_sala = a.codigo_sala;

CREATE OR REPLACE VIEW v_instruccion_clase AS
SELECT v.id_clase, v.codigo, v.fecha, v.actividad, t.rol,
       p.documento, p.nombres, p.apellidos
FROM INSTRUCCION t
JOIN CLASE v ON v.id_clase = t.id_clase
JOIN PERSONA p ON p.documento = t.documento;

CREATE OR REPLACE VIEW v_ocupacion_clase AS
SELECT v.id_clase, v.codigo, v.fecha, v.actividad, c.num_maquinas,
       COUNT(r.documento) AS ocupados,
       ROUND(100 * COUNT(r.documento) / c.num_maquinas, 2) AS porcentaje
FROM CLASE v
JOIN SALA_CARDIO c ON c.codigo_sala = v.codigo_sala
LEFT JOIN CUPO r ON r.id_clase = v.id_clase
GROUP BY v.id_clase, v.codigo, v.fecha, v.actividad, c.num_maquinas;

SELECT * FROM v_tipo_sala;
SELECT * FROM v_ocupacion_clase ORDER BY id_clase;
