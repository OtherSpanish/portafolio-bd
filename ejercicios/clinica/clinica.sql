-- Clínica - script completo (01 + 02 + 04 + 05). Probado en MySQL 8.0.

-- Clínica - Bases de Datos 1
-- 01: creacion de la sede de datos y de las 9 tablas
SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS clinica
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE clinica;

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
  tipo_persona enum('medico','paciente','ambos') NOT NULL,
  registro_medico varchar(10) DEFAULT NULL,
  anios_experiencia int DEFAULT NULL,
  codigo_sede char(3) DEFAULT NULL,
  correo varchar(80) DEFAULT NULL,
  visitas int DEFAULT NULL,
  PRIMARY KEY (documento),
  UNIQUE KEY uq_persona_registro_medico (registro_medico),
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

CREATE TABLE CONSULTORIO (
  codigo_consultorio varchar(10) NOT NULL,
  bloque varchar(40) NOT NULL,
  piso varchar(40) NOT NULL,
  codigo_sede char(3) NOT NULL,
  PRIMARY KEY (codigo_consultorio),
  KEY fk_consultorio_sede (codigo_sede),
  CONSTRAINT fk_consultorio_sede FOREIGN KEY (codigo_sede) REFERENCES SEDE (codigo_sede)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE OBSERVACION (
  codigo_consultorio varchar(10) NOT NULL,
  num_camillas int NOT NULL,
  PRIMARY KEY (codigo_consultorio),
  CONSTRAINT fk_observacion_consultorio FOREIGN KEY (codigo_consultorio) REFERENCES CONSULTORIO (codigo_consultorio)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE LABORATORIO (
  codigo_consultorio varchar(10) NOT NULL,
  area_m2 decimal(10,2) NOT NULL,
  PRIMARY KEY (codigo_consultorio),
  CONSTRAINT fk_laboratorio_consultorio FOREIGN KEY (codigo_consultorio) REFERENCES CONSULTORIO (codigo_consultorio)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE JORNADA (
  id_jornada bigint NOT NULL AUTO_INCREMENT,
  codigo varchar(8) NOT NULL,
  fecha date NOT NULL,
  hora_inicio time NOT NULL,
  especialidad varchar(50) NOT NULL,
  codigo_consultorio varchar(10) NOT NULL,
  sede_jornada char(3) NOT NULL,
  PRIMARY KEY (id_jornada),
  UNIQUE KEY uq_jornada_codigo_fecha (codigo,fecha),
  KEY fk_jornada_consultorio (codigo_consultorio),
  KEY fk_jornada_sede (sede_jornada),
  CONSTRAINT fk_jornada_consultorio FOREIGN KEY (codigo_consultorio) REFERENCES CONSULTORIO (codigo_consultorio),
  CONSTRAINT fk_jornada_sede FOREIGN KEY (sede_jornada) REFERENCES SEDE (codigo_sede)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE ATENCION (
  documento varchar(15) NOT NULL,
  id_jornada bigint NOT NULL,
  rol enum('principal','apoyo') NOT NULL,
  PRIMARY KEY (documento,id_jornada),
  KEY fk_atencion_jornada (id_jornada),
  CONSTRAINT fk_atencion_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento),
  CONSTRAINT fk_atencion_jornada FOREIGN KEY (id_jornada) REFERENCES JORNADA (id_jornada)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE CITA (
  documento varchar(15) NOT NULL,
  id_jornada bigint NOT NULL,
  turno varchar(4) NOT NULL,
  regimen enum('contributivo','subsidiado') NOT NULL,
  PRIMARY KEY (documento,id_jornada),
  UNIQUE KEY uq_cita_jornada_turno (id_jornada,turno),
  CONSTRAINT fk_cita_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento),
  CONSTRAINT fk_cita_jornada FOREIGN KEY (id_jornada) REFERENCES JORNADA (id_jornada)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Clínica - Bases de Datos 1
-- 02: registros de prueba (64), en una sola transaccion

USE clinica;



START TRANSACTION;



INSERT INTO SEDE (codigo_sede, nombre, ciudad, pais) VALUES
('BOG', 'Sede Norte', 'Bogota', 'Colombia'),
('MED', 'Sede Envigado', 'Medellin', 'Colombia'),
('CAL', 'Sede San Fernando', 'Cali', 'Colombia');

INSERT INTO PERSONA (documento, nombres, apellidos, fecha_nacimiento, tipo_persona,
                     registro_medico, anios_experiencia, codigo_sede, correo, visitas) VALUES
('1010', 'Javier Andres', 'Cuellar Rios', '1980-03-12', 'medico', 'RM-24051', 15, 'BOG', NULL, NULL),
('1020', 'Natalia', 'Prieto Ramos', '1988-07-25', 'medico', 'RM-31882', 8, 'MED', NULL, NULL),
('1030', 'Eduardo', 'Villamil Sanz', '1975-11-02', 'medico', 'RM-18190', 26, 'BOG', NULL, NULL),
('1040', 'Monica Patricia', 'Salgado Diaz', '1992-01-18', 'ambos', 'RM-40233', 4, 'CAL', 'monica.salgado@correo.co', 3),
('2010', 'Brayan', 'Suarez Lopez', '2000-05-30', 'paciente', NULL, NULL, NULL, 'brayan.suarez@correo.co', 7),
('2020', 'Catalina', 'Neira Pinto', '1997-09-14', 'paciente', NULL, NULL, NULL, 'catalina.neira@correo.co', 2),
('2030', 'Alejandro', 'Forero Caro', '1985-12-01', 'paciente', NULL, NULL, NULL, 'alejandro.forero@correo.co', 12),
('2040', 'Gabriela', 'Medina Ruiz', '2003-04-22', 'paciente', NULL, NULL, NULL, 'gabriela.medina@correo.co', 1),
('2050', 'Rodrigo', 'Pardo Vega', '1979-08-08', 'paciente', NULL, NULL, NULL, 'rodrigo.pardo@correo.co', 9);

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

INSERT INTO CONSULTORIO (codigo_consultorio, bloque, piso, codigo_sede) VALUES
('C-101', 'Bloque A', 'Piso 1', 'BOG'),
('C-205', 'Bloque B', 'Piso 2', 'MED'),
('C-110', 'Bloque A', 'Piso 1', 'CAL'),
('C-301', 'Bloque C', 'Piso 3', 'BOG'),
('C-102', 'Bloque A', 'Piso 1', 'BOG');

INSERT INTO OBSERVACION (codigo_consultorio, num_camillas) VALUES
('C-101', 6),
('C-205', 4),
('C-110', 5);

INSERT INTO LABORATORIO (codigo_consultorio, area_m2) VALUES
('C-301', 42.50);

INSERT INTO JORNADA (id_jornada, codigo, fecha, hora_inicio, especialidad, codigo_consultorio, sede_jornada) VALUES
(1, 'VAC01', '2027-01-15', '07:00', 'Vacunacion', 'C-101', 'BOG'),
(2, 'ODO02', '2027-01-15', '08:00', 'Odontologia', 'C-205', 'MED'),
(3, 'VAC03', '2027-01-16', '07:00', 'Vacunacion', 'C-110', 'CAL'),
(4, 'VAC01', '2027-01-17', '07:00', 'Vacunacion', 'C-101', 'BOG'),
(5, 'LAB05', '2027-01-17', '06:00', 'Toma de muestras', 'C-301', 'BOG'),
(6, 'PED06', '2027-01-18', '09:00', 'Pediatria', 'C-205', 'MED');

INSERT INTO ATENCION (documento, id_jornada, rol) VALUES
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

INSERT INTO CITA (documento, id_jornada, turno, regimen) VALUES
('2010', 1, 'T12', 'contributivo'),
('2010', 3, 'T05', 'contributivo'),
('2010', 4, 'T14', 'contributivo'),
('2020', 1, 'T02', 'subsidiado'),
('2020', 2, 'T08', 'contributivo'),
('2030', 2, 'T01', 'subsidiado'),
('2030', 6, 'T03', 'subsidiado'),
('2040', 3, 'T20', 'contributivo'),
('2040', 6, 'T22', 'contributivo'),
('2050', 1, 'T15', 'contributivo'),
('2050', 3, 'T09', 'contributivo'),
('2050', 4, 'T04', 'subsidiado'),
('1040', 2, 'T18', 'contributivo');



COMMIT;

-- Clínica - Bases de Datos 1
-- 04: restricciones adicionales de los supuestos
USE clinica;

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_medico CHECK (
  tipo_persona = 'paciente'
  OR (registro_medico IS NOT NULL AND anios_experiencia IS NOT NULL AND codigo_sede IS NOT NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_paciente CHECK (
  tipo_persona <> 'paciente'
  OR (registro_medico IS NULL AND anios_experiencia IS NULL AND codigo_sede IS NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_paciente CHECK (
  tipo_persona = 'medico' OR (correo IS NOT NULL AND visitas IS NOT NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_medico CHECK (
  tipo_persona <> 'medico' OR (correo IS NULL AND visitas IS NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_horas CHECK (anios_experiencia IS NULL OR anios_experiencia >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_visitas CHECK (visitas IS NULL OR visitas >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_correo CHECK (correo IS NULL OR correo LIKE '%_@_%._%');

ALTER TABLE OBSERVACION ADD CONSTRAINT ck_observacion_asientos CHECK (num_camillas > 0);
ALTER TABLE LABORATORIO ADD CONSTRAINT ck_laboratorio_capacidad CHECK (area_m2 > 0);

ALTER TABLE JORNADA ADD CONSTRAINT ck_jornada_especialidad CHECK (CHAR_LENGTH(TRIM(especialidad)) > 0);

ALTER TABLE ATENCION ADD COLUMN es_principal tinyint
  GENERATED ALWAYS AS (IF(rol = 'principal', 1, NULL)) VIRTUAL;
ALTER TABLE ATENCION ADD CONSTRAINT uq_atencion_principal UNIQUE (id_jornada, es_principal);

SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'clinica' AND CONSTRAINT_TYPE IN ('CHECK', 'UNIQUE')
ORDER BY TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME;

-- Clínica - Bases de Datos 1
-- 05: vistas
USE clinica;

CREATE OR REPLACE VIEW v_persona_edad AS
SELECT p.documento, p.nombres, p.apellidos, p.tipo_persona, p.fecha_nacimiento,
       TIMESTAMPDIFF(YEAR, p.fecha_nacimiento, CURDATE()) AS edad
FROM PERSONA p;

CREATE OR REPLACE VIEW v_tipo_consultorio AS
SELECT a.codigo_consultorio, a.piso, a.bloque, a.codigo_sede,
       CASE
         WHEN c.codigo_consultorio IS NOT NULL THEN 'observacion'
         WHEN g.codigo_consultorio IS NOT NULL THEN 'laboratorio'
         ELSE 'otro'
       END AS tipo,
       c.num_camillas, g.area_m2
FROM CONSULTORIO a
LEFT JOIN OBSERVACION c ON c.codigo_consultorio = a.codigo_consultorio
LEFT JOIN LABORATORIO g ON g.codigo_consultorio = a.codigo_consultorio;

CREATE OR REPLACE VIEW v_atencion_jornada AS
SELECT v.id_jornada, v.codigo, v.fecha, v.especialidad, t.rol,
       p.documento, p.nombres, p.apellidos
FROM ATENCION t
JOIN JORNADA v ON v.id_jornada = t.id_jornada
JOIN PERSONA p ON p.documento = t.documento;

CREATE OR REPLACE VIEW v_ocupacion_jornada AS
SELECT v.id_jornada, v.codigo, v.fecha, v.especialidad, c.num_camillas,
       COUNT(r.documento) AS ocupados,
       ROUND(100 * COUNT(r.documento) / c.num_camillas, 2) AS porcentaje
FROM JORNADA v
JOIN OBSERVACION c ON c.codigo_consultorio = v.codigo_consultorio
LEFT JOIN CITA r ON r.id_jornada = v.id_jornada
GROUP BY v.id_jornada, v.codigo, v.fecha, v.especialidad, c.num_camillas;

SELECT * FROM v_tipo_consultorio;
SELECT * FROM v_ocupacion_jornada ORDER BY id_jornada;
