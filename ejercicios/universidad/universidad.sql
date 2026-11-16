-- Universidad - script completo (01 + 02 + 04 + 05). Probado en MySQL 8.0.

-- Universidad - Bases de Datos 1
-- 01: creacion de la sede de datos y de las 9 tablas
SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS universidad
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE universidad;

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
  tipo_persona enum('profesor','estudiante','ambos') NOT NULL,
  registro varchar(10) DEFAULT NULL,
  anios_experiencia int DEFAULT NULL,
  codigo_sede char(3) DEFAULT NULL,
  correo varchar(80) DEFAULT NULL,
  creditos int DEFAULT NULL,
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

CREATE TABLE SALON (
  codigo_salon varchar(10) NOT NULL,
  bloque varchar(40) NOT NULL,
  piso varchar(40) NOT NULL,
  codigo_sede char(3) NOT NULL,
  PRIMARY KEY (codigo_salon),
  KEY fk_salon_sede (codigo_sede),
  CONSTRAINT fk_salon_sede FOREIGN KEY (codigo_sede) REFERENCES SEDE (codigo_sede)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE LABORATORIO (
  codigo_salon varchar(10) NOT NULL,
  num_equipos int NOT NULL,
  PRIMARY KEY (codigo_salon),
  CONSTRAINT fk_laboratorio_salon FOREIGN KEY (codigo_salon) REFERENCES SALON (codigo_salon)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE AUDITORIO (
  codigo_salon varchar(10) NOT NULL,
  area_m2 decimal(10,2) NOT NULL,
  PRIMARY KEY (codigo_salon),
  CONSTRAINT fk_auditorio_salon FOREIGN KEY (codigo_salon) REFERENCES SALON (codigo_salon)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE CURSO (
  id_curso bigint NOT NULL AUTO_INCREMENT,
  codigo varchar(8) NOT NULL,
  fecha date NOT NULL,
  hora_inicio time NOT NULL,
  asignatura varchar(50) NOT NULL,
  codigo_salon varchar(10) NOT NULL,
  sede_curso char(3) NOT NULL,
  PRIMARY KEY (id_curso),
  UNIQUE KEY uq_curso_codigo_fecha (codigo,fecha),
  KEY fk_curso_salon (codigo_salon),
  KEY fk_curso_sede (sede_curso),
  CONSTRAINT fk_curso_salon FOREIGN KEY (codigo_salon) REFERENCES SALON (codigo_salon),
  CONSTRAINT fk_curso_sede FOREIGN KEY (sede_curso) REFERENCES SEDE (codigo_sede)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE DOCENCIA (
  documento varchar(15) NOT NULL,
  id_curso bigint NOT NULL,
  rol enum('titular','auxiliar') NOT NULL,
  PRIMARY KEY (documento,id_curso),
  KEY fk_docencia_curso (id_curso),
  CONSTRAINT fk_docencia_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento),
  CONSTRAINT fk_docencia_curso FOREIGN KEY (id_curso) REFERENCES CURSO (id_curso)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE INSCRIPCION (
  documento varchar(15) NOT NULL,
  id_curso bigint NOT NULL,
  puesto varchar(4) NOT NULL,
  modalidad enum('presencial','virtual') NOT NULL,
  PRIMARY KEY (documento,id_curso),
  UNIQUE KEY uq_inscripcion_curso_puesto (id_curso,puesto),
  CONSTRAINT fk_inscripcion_persona FOREIGN KEY (documento) REFERENCES PERSONA (documento),
  CONSTRAINT fk_inscripcion_curso FOREIGN KEY (id_curso) REFERENCES CURSO (id_curso)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Universidad - Bases de Datos 1
-- 02: registros de prueba (64), en una sola transaccion

USE universidad;



START TRANSACTION;



INSERT INTO SEDE (codigo_sede, nombre, ciudad, pais) VALUES
('BOG', 'Sede Usaquen', 'Bogota', 'Colombia'),
('MED', 'Sede Poblado', 'Medellin', 'Colombia'),
('CAL', 'Sede Granada', 'Cali', 'Colombia');

INSERT INTO PERSONA (documento, nombres, apellidos, fecha_nacimiento, tipo_persona,
                     registro, anios_experiencia, codigo_sede, correo, creditos) VALUES
('1010', 'Jorge Ivan', 'Pardo Silva', '1980-03-12', 'profesor', 'REG-1201', 18, 'BOG', NULL, NULL),
('1020', 'Diana Carolina', 'Mesa Rios', '1988-07-25', 'profesor', 'REG-1388', 9, 'MED', NULL, NULL),
('1030', 'Ricardo', 'Nunez Vela', '1975-11-02', 'profesor', 'REG-0975', 25, 'BOG', NULL, NULL),
('1040', 'Sara Lucia', 'Quintero Paz', '1992-01-18', 'ambos', 'REG-1590', 4, 'CAL', 'sara.quintero@correo.co', 30),
('2010', 'Tomas', 'Bermudez Cano', '2000-05-30', 'estudiante', NULL, NULL, NULL, 'tomas.bermudez@correo.co', 112),
('2020', 'Camila', 'Ospina Reyes', '1997-09-14', 'estudiante', NULL, NULL, NULL, 'camila.ospina@correo.co', 64),
('2030', 'Juan David', 'Arango Mejia', '1985-12-01', 'estudiante', NULL, NULL, NULL, 'juan.arango@correo.co', 140),
('2040', 'Mariana', 'Cardenas Ruiz', '2003-04-22', 'estudiante', NULL, NULL, NULL, 'mariana.cardenas@correo.co', 16),
('2050', 'Felipe', 'Salazar Duque', '1979-08-08', 'estudiante', NULL, NULL, NULL, 'felipe.salazar@correo.co', 88);

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

INSERT INTO SALON (codigo_salon, bloque, piso, codigo_sede) VALUES
('S-101', 'Bloque A', 'Piso 1', 'BOG'),
('S-205', 'Bloque B', 'Piso 2', 'MED'),
('S-310', 'Bloque C', 'Piso 3', 'CAL'),
('S-401', 'Bloque B', 'Piso 4', 'BOG'),
('S-115', 'Bloque A', 'Piso 1', 'BOG');

INSERT INTO LABORATORIO (codigo_salon, num_equipos) VALUES
('S-101', 30),
('S-205', 24),
('S-310', 20);

INSERT INTO AUDITORIO (codigo_salon, area_m2) VALUES
('S-401', 180.50);

INSERT INTO CURSO (id_curso, codigo, fecha, hora_inicio, asignatura, codigo_salon, sede_curso) VALUES
(1, 'BD101', '2026-02-02', '07:00', 'Bases de Datos', 'S-101', 'BOG'),
(2, 'PR201', '2026-02-02', '09:00', 'Programacion', 'S-205', 'MED'),
(3, 'BD301', '2026-02-03', '14:00', 'Bases de Datos', 'S-310', 'CAL'),
(4, 'BD101', '2026-02-04', '07:00', 'Bases de Datos', 'S-101', 'BOG'),
(5, 'SE900', '2026-02-04', '18:00', 'Seminario', 'S-401', 'BOG'),
(6, 'CA420', '2026-02-05', '11:00', 'Calculo', 'S-205', 'MED');

INSERT INTO DOCENCIA (documento, id_curso, rol) VALUES
('1010', 1, 'titular'),
('1040', 1, 'auxiliar'),
('1020', 2, 'titular'),
('1030', 2, 'auxiliar'),
('1040', 3, 'titular'),
('1020', 3, 'auxiliar'),
('1030', 4, 'titular'),
('1010', 4, 'auxiliar'),
('1030', 5, 'titular'),
('1010', 5, 'auxiliar'),
('1020', 6, 'titular'),
('1040', 6, 'auxiliar');

INSERT INTO INSCRIPCION (documento, id_curso, puesto, modalidad) VALUES
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

-- Universidad - Bases de Datos 1
-- 04: restricciones adicionales de los supuestos
USE universidad;

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_profesor CHECK (
  tipo_persona = 'estudiante'
  OR (registro IS NOT NULL AND anios_experiencia IS NOT NULL AND codigo_sede IS NOT NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_estudiante CHECK (
  tipo_persona <> 'estudiante'
  OR (registro IS NULL AND anios_experiencia IS NULL AND codigo_sede IS NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_datos_estudiante CHECK (
  tipo_persona = 'profesor' OR (correo IS NOT NULL AND creditos IS NOT NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_solo_profesor CHECK (
  tipo_persona <> 'profesor' OR (correo IS NULL AND creditos IS NULL));

ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_horas CHECK (anios_experiencia IS NULL OR anios_experiencia >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_creditos CHECK (creditos IS NULL OR creditos >= 0);
ALTER TABLE PERSONA ADD CONSTRAINT ck_persona_correo CHECK (correo IS NULL OR correo LIKE '%_@_%._%');

ALTER TABLE LABORATORIO ADD CONSTRAINT ck_laboratorio_asientos CHECK (num_equipos > 0);
ALTER TABLE AUDITORIO ADD CONSTRAINT ck_auditorio_capacidad CHECK (area_m2 > 0);

ALTER TABLE CURSO ADD CONSTRAINT ck_curso_asignatura CHECK (CHAR_LENGTH(TRIM(asignatura)) > 0);

ALTER TABLE DOCENCIA ADD COLUMN es_titular tinyint
  GENERATED ALWAYS AS (IF(rol = 'titular', 1, NULL)) VIRTUAL;
ALTER TABLE DOCENCIA ADD CONSTRAINT uq_docencia_titular UNIQUE (id_curso, es_titular);

SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'universidad' AND CONSTRAINT_TYPE IN ('CHECK', 'UNIQUE')
ORDER BY TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME;

-- Universidad - Bases de Datos 1
-- 05: vistas
USE universidad;

CREATE OR REPLACE VIEW v_persona_edad AS
SELECT p.documento, p.nombres, p.apellidos, p.tipo_persona, p.fecha_nacimiento,
       TIMESTAMPDIFF(YEAR, p.fecha_nacimiento, CURDATE()) AS edad
FROM PERSONA p;

CREATE OR REPLACE VIEW v_tipo_salon AS
SELECT a.codigo_salon, a.piso, a.bloque, a.codigo_sede,
       CASE
         WHEN c.codigo_salon IS NOT NULL THEN 'laboratorio'
         WHEN g.codigo_salon IS NOT NULL THEN 'auditorio'
         ELSE 'otro'
       END AS tipo,
       c.num_equipos, g.area_m2
FROM SALON a
LEFT JOIN LABORATORIO c ON c.codigo_salon = a.codigo_salon
LEFT JOIN AUDITORIO g ON g.codigo_salon = a.codigo_salon;

CREATE OR REPLACE VIEW v_docencia_curso AS
SELECT v.id_curso, v.codigo, v.fecha, v.asignatura, t.rol,
       p.documento, p.nombres, p.apellidos
FROM DOCENCIA t
JOIN CURSO v ON v.id_curso = t.id_curso
JOIN PERSONA p ON p.documento = t.documento;

CREATE OR REPLACE VIEW v_ocupacion_curso AS
SELECT v.id_curso, v.codigo, v.fecha, v.asignatura, c.num_equipos,
       COUNT(r.documento) AS ocupados,
       ROUND(100 * COUNT(r.documento) / c.num_equipos, 2) AS porcentaje
FROM CURSO v
JOIN LABORATORIO c ON c.codigo_salon = v.codigo_salon
LEFT JOIN INSCRIPCION r ON r.id_curso = v.id_curso
GROUP BY v.id_curso, v.codigo, v.fecha, v.asignatura, c.num_equipos;

SELECT * FROM v_tipo_salon;
SELECT * FROM v_ocupacion_curso ORDER BY id_curso;
