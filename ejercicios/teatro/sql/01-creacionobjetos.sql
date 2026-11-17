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
