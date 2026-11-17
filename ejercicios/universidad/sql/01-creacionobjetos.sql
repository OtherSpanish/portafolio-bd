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
