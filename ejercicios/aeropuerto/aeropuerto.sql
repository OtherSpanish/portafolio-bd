-- =====================================================================
--  Ejercicio: AEROPUERTO
--  Portafolio de Bases de Datos — Juan Carlos Morales
--  Script probado en PostgreSQL 16 (SQL estándar, compatible con MySQL 8
--  salvo donde se indica).
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. DDL — Creación de tablas
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS reserva;
DROP TABLE IF EXISTS tripula;
DROP TABLE IF EXISTS vuelo;
DROP TABLE IF EXISTS avion_carga;
DROP TABLE IF EXISTS avion_comercial;
DROP TABLE IF EXISTS avion;
DROP TABLE IF EXISTS pasajero;
DROP TABLE IF EXISTS piloto;
DROP TABLE IF EXISTS telefono_persona;
DROP TABLE IF EXISTS persona;
DROP TABLE IF EXISTS base;

CREATE TABLE base (
    codigo_base  CHAR(3)      PRIMARY KEY,
    nombre       VARCHAR(80)  NOT NULL,
    ciudad       VARCHAR(50)  NOT NULL,
    pais         VARCHAR(50)  NOT NULL
);

CREATE TABLE persona (
    documento         VARCHAR(15)  PRIMARY KEY,
    nombres           VARCHAR(50)  NOT NULL,
    apellidos         VARCHAR(50)  NOT NULL,
    fecha_nacimiento  DATE         NOT NULL
);

-- Atributo multivaluado "telefono" de PERSONA
CREATE TABLE telefono_persona (
    documento  VARCHAR(15)  NOT NULL,
    telefono   VARCHAR(15)  NOT NULL,
    PRIMARY KEY (documento, telefono),
    FOREIGN KEY (documento) REFERENCES persona(documento) ON DELETE CASCADE
);

-- Subclase PILOTO (especialización de PERSONA)
CREATE TABLE piloto (
    documento    VARCHAR(15)  PRIMARY KEY,
    licencia     VARCHAR(10)  NOT NULL UNIQUE,
    horas_vuelo  INT          NOT NULL CHECK (horas_vuelo >= 0),
    codigo_base  CHAR(3)      NOT NULL,
    FOREIGN KEY (documento)   REFERENCES persona(documento) ON DELETE CASCADE,
    FOREIGN KEY (codigo_base) REFERENCES base(codigo_base)
);

-- Subclase PASAJERO (especialización de PERSONA)
CREATE TABLE pasajero (
    documento  VARCHAR(15)   PRIMARY KEY,
    correo     VARCHAR(80)   NOT NULL UNIQUE,
    millas     INT           NOT NULL DEFAULT 0 CHECK (millas >= 0),
    FOREIGN KEY (documento) REFERENCES persona(documento) ON DELETE CASCADE
);

CREATE TABLE avion (
    matricula    VARCHAR(10)  PRIMARY KEY,
    modelo       VARCHAR(40)  NOT NULL,
    fabricante   VARCHAR(40)  NOT NULL,
    codigo_base  CHAR(3)      NOT NULL,
    FOREIGN KEY (codigo_base) REFERENCES base(codigo_base)
);

-- Subclases de AVION (especialización disjunta y parcial)
CREATE TABLE avion_comercial (
    matricula     VARCHAR(10)  PRIMARY KEY,
    num_asientos  INT          NOT NULL CHECK (num_asientos > 0),
    FOREIGN KEY (matricula) REFERENCES avion(matricula) ON DELETE CASCADE
);

CREATE TABLE avion_carga (
    matricula     VARCHAR(10)    PRIMARY KEY,
    capacidad_kg  DECIMAL(10,2)  NOT NULL CHECK (capacidad_kg > 0),
    FOREIGN KEY (matricula) REFERENCES avion(matricula) ON DELETE CASCADE
);

CREATE TABLE vuelo (
    id_vuelo            INT          PRIMARY KEY,
    codigo              VARCHAR(8)   NOT NULL,
    fecha               DATE         NOT NULL,
    hora_salida         TIME         NOT NULL,
    destino             VARCHAR(50)  NOT NULL,
    matricula           VARCHAR(10)  NOT NULL,
    codigo_base_origen  CHAR(3)      NOT NULL,
    UNIQUE (codigo, fecha),
    FOREIGN KEY (matricula)          REFERENCES avion(matricula),
    FOREIGN KEY (codigo_base_origen) REFERENCES base(codigo_base)
);

-- Relación M:N PILOTO —TRIPULA— VUELO
CREATE TABLE tripula (
    documento  VARCHAR(15)  NOT NULL,
    id_vuelo   INT          NOT NULL,
    rol        VARCHAR(10)  NOT NULL CHECK (rol IN ('CAPITAN', 'COPILOTO')),
    PRIMARY KEY (documento, id_vuelo),
    FOREIGN KEY (documento) REFERENCES piloto(documento),
    FOREIGN KEY (id_vuelo)  REFERENCES vuelo(id_vuelo) ON DELETE CASCADE
);

-- Relación M:N PASAJERO —RESERVA— VUELO
CREATE TABLE reserva (
    documento  VARCHAR(15)  NOT NULL,
    id_vuelo   INT          NOT NULL,
    asiento    VARCHAR(4)   NOT NULL,
    clase      VARCHAR(10)  NOT NULL CHECK (clase IN ('ECONOMICA', 'EJECUTIVA')),
    PRIMARY KEY (documento, id_vuelo),
    UNIQUE (id_vuelo, asiento),
    FOREIGN KEY (documento) REFERENCES pasajero(documento),
    FOREIGN KEY (id_vuelo)  REFERENCES vuelo(id_vuelo) ON DELETE CASCADE
);

-- ---------------------------------------------------------------------
-- 2. DML — Datos de prueba
-- ---------------------------------------------------------------------
INSERT INTO base (codigo_base, nombre, ciudad, pais) VALUES
('BOG', 'Aeropuerto El Dorado',              'Bogotá',   'Colombia'),
('MDE', 'Aeropuerto José María Córdova',     'Rionegro', 'Colombia'),
('CLO', 'Aeropuerto Alfonso Bonilla Aragón', 'Palmira',  'Colombia');

INSERT INTO persona (documento, nombres, apellidos, fecha_nacimiento) VALUES
('1010', 'Carlos Andrés',    'Rojas Pérez',    '1980-03-12'),
('1020', 'Laura Marcela',    'Gómez Ruiz',     '1988-07-25'),
('1030', 'Andrés Felipe',    'Torres Díaz',    '1975-11-02'),
('1040', 'Sofía Valentina',  'Herrera Mora',   '1992-01-18'),
('2010', 'Mateo',            'Sánchez Castro', '2000-05-30'),
('2020', 'Valeria',          'Ramírez León',   '1997-09-14'),
('2030', 'Santiago',         'López Vargas',   '1985-12-01'),
('2040', 'Isabella',         'Martínez Gil',   '2003-04-22'),
('2050', 'Daniel',           'Ortiz Navarro',  '1979-08-08');

INSERT INTO telefono_persona (documento, telefono) VALUES
('1010', '3001112233'), ('1010', '6015550101'),
('1020', '3104445566'),
('1030', '3207778899'),
('1040', '3156667788'), ('1040', '3019990000'),
('2010', '3121234567'),
('2020', '3189876543'),
('2030', '3001239876'), ('2030', '6047771234'),
('2040', '3165554433'),
('2050', '3112223344');

INSERT INTO piloto (documento, licencia, horas_vuelo, codigo_base) VALUES
('1010', 'LIC-0451', 12500, 'BOG'),
('1020', 'LIC-0782',  6800, 'MDE'),
('1030', 'LIC-0219', 15200, 'BOG'),
('1040', 'LIC-1033',  2900, 'CLO');

-- 1040 es piloto Y pasajera (especialización solapada)
INSERT INTO pasajero (documento, correo, millas) VALUES
('1040', 'sofia.herrera@correo.co',  1200),
('2010', 'mateo.sanchez@correo.co',  5400),
('2020', 'valeria.ramirez@correo.co', 800),
('2030', 'santiago.lopez@correo.co', 15300),
('2040', 'isabella.martinez@correo.co', 0),
('2050', 'daniel.ortiz@correo.co',   9100);

INSERT INTO avion (matricula, modelo, fabricante, codigo_base) VALUES
('HK-5001', 'A320',     'Airbus',  'BOG'),
('HK-5002', '737-800',  'Boeing',  'MDE'),
('HK-5003', 'ATR 72',   'ATR',     'CLO'),
('HK-6001', '767-300F', 'Boeing',  'BOG'),
('HK-7001', '172',      'Cessna',  'BOG');   -- de entrenamiento: ni comercial ni carga (parcial)

INSERT INTO avion_comercial (matricula, num_asientos) VALUES
('HK-5001', 180),
('HK-5002', 160),
('HK-5003',  70);

INSERT INTO avion_carga (matricula, capacidad_kg) VALUES
('HK-6001', 52000.00);

INSERT INTO vuelo (id_vuelo, codigo, fecha, hora_salida, destino, matricula, codigo_base_origen) VALUES
(1, 'AV101', '2026-11-20', '06:30', 'Cartagena',  'HK-5001', 'BOG'),
(2, 'AV205', '2026-11-20', '09:15', 'Bogotá',     'HK-5002', 'MDE'),
(3, 'AV310', '2026-11-21', '14:00', 'Cartagena',  'HK-5003', 'CLO'),
(4, 'AV101', '2026-11-22', '06:30', 'Cartagena',  'HK-5001', 'BOG'),
(5, 'CG900', '2026-11-22', '22:00', 'Miami',      'HK-6001', 'BOG'),
(6, 'AV420', '2026-11-23', '11:45', 'San Andrés', 'HK-5002', 'MDE');

INSERT INTO tripula (documento, id_vuelo, rol) VALUES
('1010', 1, 'CAPITAN'),  ('1040', 1, 'COPILOTO'),
('1020', 2, 'CAPITAN'),  ('1030', 2, 'COPILOTO'),
('1040', 3, 'CAPITAN'),  ('1020', 3, 'COPILOTO'),
('1030', 4, 'CAPITAN'),  ('1010', 4, 'COPILOTO'),
('1030', 5, 'CAPITAN'),  ('1010', 5, 'COPILOTO'),
('1020', 6, 'CAPITAN'),  ('1040', 6, 'COPILOTO');

INSERT INTO reserva (documento, id_vuelo, asiento, clase) VALUES
('2010', 1, '12A', 'ECONOMICA'),
('2010', 3, '5C',  'ECONOMICA'),
('2010', 4, '14B', 'ECONOMICA'),
('2020', 1, '2A',  'EJECUTIVA'),
('2020', 2, '8D',  'ECONOMICA'),
('2030', 2, '1A',  'EJECUTIVA'),
('2030', 6, '3B',  'EJECUTIVA'),
('2040', 3, '20F', 'ECONOMICA'),
('2040', 6, '22A', 'ECONOMICA'),
('2050', 1, '15C', 'ECONOMICA'),
('2050', 3, '9A',  'ECONOMICA'),
('2050', 4, '2C',  'EJECUTIVA'),
('1040', 2, '18C', 'ECONOMICA');
