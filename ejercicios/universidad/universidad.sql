-- Universidad - script completo (01 + 02 + 04 + 05). Probado en MySQL 8.0.

-- Universidad - Bases de Datos 1
-- 01: creacion de la base de datos y de las 11 tablas
-- Las tablas van en orden: primero las que no dependen de otras.

SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS universidad
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE universidad;

-- SEDE
CREATE TABLE SEDE (
  codigo_sede char(3) NOT NULL,
  nombre varchar(80) NOT NULL,
  ciudad varchar(50) NOT NULL,
  direccion varchar(80) NOT NULL,
  PRIMARY KEY (codigo_sede)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- PROFESOR
CREATE TABLE PROFESOR (
  id_profesor varchar(15) NOT NULL,
  nombres varchar(50) NOT NULL,
  apellidos varchar(50) NOT NULL,
  titulo varchar(60) NOT NULL,
  fecha_ingreso date NOT NULL,
  codigo_sede char(3) NOT NULL,
  PRIMARY KEY (id_profesor),
  CONSTRAINT fk_profesor_codigo_sede FOREIGN KEY (codigo_sede) REFERENCES SEDE (codigo_sede)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- PLANTA
CREATE TABLE PLANTA (
  id_profesor varchar(15) NOT NULL,
  salario decimal(12,2) NOT NULL,
  categoria varchar(20) NOT NULL,
  PRIMARY KEY (id_profesor),
  CONSTRAINT fk_planta_id_profesor FOREIGN KEY (id_profesor) REFERENCES PROFESOR (id_profesor)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- CATEDRA
CREATE TABLE CATEDRA (
  id_profesor varchar(15) NOT NULL,
  valor_hora decimal(10,2) NOT NULL,
  horas_semana int NOT NULL,
  PRIMARY KEY (id_profesor),
  CONSTRAINT fk_catedra_id_profesor FOREIGN KEY (id_profesor) REFERENCES PROFESOR (id_profesor)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ASIGNATURA
CREATE TABLE ASIGNATURA (
  cod_asignatura char(6) NOT NULL,
  nombre varchar(80) NOT NULL,
  creditos int NOT NULL,
  PRIMARY KEY (cod_asignatura)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- PRERREQUISITO
CREATE TABLE PRERREQUISITO (
  cod_asignatura char(6) NOT NULL,
  cod_requisito char(6) NOT NULL,
  PRIMARY KEY (cod_asignatura, cod_requisito),
  CONSTRAINT fk_prerrequisito_cod_asignatura FOREIGN KEY (cod_asignatura) REFERENCES ASIGNATURA (cod_asignatura),
  CONSTRAINT fk_prerrequisito_cod_requisito FOREIGN KEY (cod_requisito) REFERENCES ASIGNATURA (cod_asignatura)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- PROGRAMA
CREATE TABLE PROGRAMA (
  id_programa int NOT NULL,
  nombre varchar(80) NOT NULL,
  nivel enum('pregrado','posgrado') NOT NULL,
  creditos int NOT NULL,
  codigo_sede char(3) NOT NULL,
  id_director varchar(15) NOT NULL,
  PRIMARY KEY (id_programa),
  UNIQUE KEY uq_programa_nombre (nombre),
  UNIQUE KEY uq_programa_id_director (id_director),
  CONSTRAINT fk_programa_codigo_sede FOREIGN KEY (codigo_sede) REFERENCES SEDE (codigo_sede),
  CONSTRAINT fk_programa_id_director FOREIGN KEY (id_director) REFERENCES PROFESOR (id_profesor)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ESTUDIANTE
CREATE TABLE ESTUDIANTE (
  id_estudiante varchar(15) NOT NULL,
  nombres varchar(50) NOT NULL,
  apellidos varchar(50) NOT NULL,
  fecha_nacimiento date NOT NULL,
  correo varchar(80) NOT NULL,
  id_programa int NOT NULL,
  PRIMARY KEY (id_estudiante),
  UNIQUE KEY uq_estudiante_correo (correo),
  CONSTRAINT fk_estudiante_id_programa FOREIGN KEY (id_programa) REFERENCES PROGRAMA (id_programa)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- CURSO
CREATE TABLE CURSO (
  id_curso int NOT NULL,
  grupo char(2) NOT NULL,
  periodo char(6) NOT NULL,
  horario varchar(30) NOT NULL,
  id_profesor varchar(15) NOT NULL,
  cod_asignatura char(6) NOT NULL,
  PRIMARY KEY (id_curso),
  CONSTRAINT fk_curso_id_profesor FOREIGN KEY (id_profesor) REFERENCES PROFESOR (id_profesor),
  CONSTRAINT fk_curso_cod_asignatura FOREIGN KEY (cod_asignatura) REFERENCES ASIGNATURA (cod_asignatura)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- EST_TELEFONO
CREATE TABLE EST_TELEFONO (
  id_estudiante varchar(15) NOT NULL,
  telefono varchar(15) NOT NULL,
  PRIMARY KEY (id_estudiante, telefono),
  CONSTRAINT fk_est_telefono_id_estudiante FOREIGN KEY (id_estudiante) REFERENCES ESTUDIANTE (id_estudiante)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- MATRICULA
CREATE TABLE MATRICULA (
  id_estudiante varchar(15) NOT NULL,
  id_curso int NOT NULL,
  nota decimal(3,1) DEFAULT NULL,
  PRIMARY KEY (id_estudiante, id_curso),
  CONSTRAINT fk_matricula_id_estudiante FOREIGN KEY (id_estudiante) REFERENCES ESTUDIANTE (id_estudiante),
  CONSTRAINT fk_matricula_id_curso FOREIGN KEY (id_curso) REFERENCES CURSO (id_curso)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Universidad - Bases de Datos 1
-- 02: registros de prueba, en una sola transaccion

USE universidad;

START TRANSACTION;

INSERT INTO SEDE (codigo_sede, nombre, ciudad, direccion) VALUES
('USQ', 'Sede Usaquen', 'Bogota', 'Cra 9 # 131A-02'),
('CHA', 'Sede Chapinero', 'Bogota', 'Cra 7 # 63-44'),
('CHI', 'Sede Chia', 'Chia', 'Km 20 Autopista Norte');

INSERT INTO PROFESOR (id_profesor, nombres, apellidos, titulo, fecha_ingreso, codigo_sede) VALUES
('P01', 'Martha Lucia', 'Rincon Vega', 'Doctora en Educacion', '2008-02-01', 'USQ'),
('P02', 'Jorge Eliecer', 'Cardenas Ruiz', 'Magister en Software', '2015-07-15', 'USQ'),
('P03', 'Diana Carolina', 'Pardo Mesa', 'Magister en Datos', '2019-01-20', 'CHI'),
('P04', 'Hector', 'Salazar Nino', 'Ingeniero de Sistemas', '2021-08-01', 'CHA'),
('P05', 'Paola Andrea', 'Quintero Gil', 'Doctora en Matematicas', '2012-02-10', 'USQ'),
('P06', 'Ricardo', 'Montoya Paz', 'Magister en Redes', '2023-01-16', 'CHI');

INSERT INTO PLANTA (id_profesor, salario, categoria) VALUES
('P01', 8500000, 'titular'),
('P02', 6200000, 'asociado'),
('P05', 7900000, 'titular');

INSERT INTO CATEDRA (id_profesor, valor_hora, horas_semana) VALUES
('P03', 95000, 12),
('P04', 80000, 8);

INSERT INTO ASIGNATURA (cod_asignatura, nombre, creditos) VALUES
('PRG101', 'Programacion 1', 3),
('PRG201', 'Estructuras de Datos', 3),
('BDD101', 'Bases de Datos 1', 3),
('MAT101', 'Calculo Diferencial', 4),
('EST101', 'Estadistica', 3),
('RED101', 'Redes 1', 3);

INSERT INTO PRERREQUISITO (cod_asignatura, cod_requisito) VALUES
('PRG201', 'PRG101'),
('BDD101', 'PRG201'),
('BDD101', 'MAT101'),
('EST101', 'MAT101'),
('RED101', 'PRG101');

INSERT INTO PROGRAMA (id_programa, nombre, nivel, creditos, codigo_sede, id_director) VALUES
(1, 'Ingenieria de Sistemas', 'pregrado', 160, 'USQ', 'P01'),
(2, 'Ingenieria Electronica', 'pregrado', 165, 'CHI', 'P03'),
(3, 'Maestria en Ciencia de Datos', 'posgrado', 48, 'USQ', 'P05');

INSERT INTO ESTUDIANTE (id_estudiante, nombres, apellidos, fecha_nacimiento, correo, id_programa) VALUES
('E01', 'Juan Camilo', 'Rojas Perez', '2004-03-12', 'juan.rojas@unimail.co', 1),
('E02', 'Maria Fernanda', 'Lopez Diaz', '2005-07-25', 'maria.lopez@unimail.co', 1),
('E03', 'Andres', 'Gutierrez Mora', '2003-11-02', 'andres.gutierrez@unimail.co', 1),
('E04', 'Laura', 'Castillo Rey', '2004-01-18', 'laura.castillo@unimail.co', 2),
('E05', 'Sebastian', 'Ortega Luna', '2002-05-30', 'sebastian.ortega@unimail.co', 2),
('E06', 'Valentina', 'Herrera Gil', '2005-09-14', 'valentina.herrera@unimail.co', 1),
('E07', 'Camilo', 'Vargas Leon', '1996-12-01', 'camilo.vargas@unimail.co', 3),
('E08', 'Natalia', 'Suarez Pinto', '1998-04-22', 'natalia.suarez@unimail.co', 3);

INSERT INTO CURSO (id_curso, grupo, periodo, horario, id_profesor, cod_asignatura) VALUES
(1, '01', '2026-2', 'Lun-Mie 7-9', 'P02', 'BDD101'),
(2, '02', '2026-2', 'Mar-Jue 9-11', 'P04', 'BDD101'),
(3, '01', '2026-2', 'Lun-Mie 9-11', 'P03', 'PRG201'),
(4, '01', '2026-2', 'Vie 7-11', 'P05', 'MAT101'),
(5, '01', '2026-2', 'Mar-Jue 7-9', 'P02', 'PRG101'),
(6, '01', '2026-2', 'Sab 8-12', 'P05', 'EST101');

INSERT INTO EST_TELEFONO (id_estudiante, telefono) VALUES
('E01', '3001234567'),
('E01', '6017441122'),
('E02', '3109876543'),
('E03', '3152223344'),
('E03', '3205556677'),
('E04', '3014445566'),
('E05', '3126667788'),
('E06', '3187778899'),
('E07', '3008889900'),
('E07', '6015553311'),
('E08', '3161112233');

INSERT INTO MATRICULA (id_estudiante, id_curso, nota) VALUES
('E01', 1, 4.5),
('E01', 3, 3.8),
('E01', 4, 4.1),
('E02', 1, 3.2),
('E02', 5, 4.7),
('E03', 2, 2.9),
('E03', 4, 3.5),
('E04', 3, 4.0),
('E04', 5, NULL),
('E05', 2, 3.6),
('E06', 5, 4.9),
('E06', 1, 3.9),
('E07', 6, 4.2),
('E08', 6, NULL);

COMMIT;

-- Universidad - Bases de Datos 1
-- 04: restricciones adicionales de los supuestos

USE universidad;

-- la nota va de 0 a 5
ALTER TABLE MATRICULA ADD CONSTRAINT ck_matricula_nota CHECK (nota IS NULL OR nota BETWEEN 0 AND 5);

-- una asignatura no puede ser requisito de si misma
ALTER TABLE PRERREQUISITO ADD CONSTRAINT ck_prerrequisito_distinto CHECK (cod_asignatura <> cod_requisito);

-- los creditos y los pagos son positivos
ALTER TABLE ASIGNATURA ADD CONSTRAINT ck_asignatura_creditos CHECK (creditos > 0);
ALTER TABLE PLANTA ADD CONSTRAINT ck_planta_salario CHECK (salario > 0);
ALTER TABLE CATEDRA ADD CONSTRAINT ck_catedra_valor CHECK (valor_hora > 0 AND horas_semana > 0);

-- Universidad - Bases de Datos 1
-- 05: vistas (consultas guardadas, no guardan datos)

USE universidad;

-- edad es derivado: no se guarda, se calcula
CREATE OR REPLACE VIEW v_estudiante_edad AS
SELECT x.id_estudiante, TIMESTAMPDIFF(YEAR, x.fecha_nacimiento, CURDATE()) AS edad
FROM ESTUDIANTE x;

-- a qué subtipo pertenece cada profesor
CREATE OR REPLACE VIEW v_tipo_profesor AS
SELECT x.id_profesor,
       CASE
         WHEN s0.id_profesor IS NOT NULL THEN 'planta'
         WHEN s1.id_profesor IS NOT NULL THEN 'catedra'
         ELSE 'ninguno'
       END AS tipo
FROM PROFESOR x
LEFT JOIN PLANTA s0 ON s0.id_profesor = x.id_profesor
LEFT JOIN CATEDRA s1 ON s1.id_profesor = x.id_profesor;
