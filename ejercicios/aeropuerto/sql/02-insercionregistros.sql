-- Aeropuerto - Bases de Datos 1
-- 02: insercion de los registros de prueba (64 registros)
-- Todo va en una sola transaccion: si algo falla no queda nada a medias.
-- Ejecutar con un usuario administrador, despues de 01.

USE aeropuerto;

START TRANSACTION;

INSERT INTO BASE (codigo_base, nombre, ciudad, pais) VALUES
('BOG', 'Aeropuerto El Dorado', 'Bogota', 'Colombia'),
('MDE', 'Aeropuerto Jose Maria Cordova', 'Rionegro', 'Colombia'),
('CLO', 'Aeropuerto Alfonso Bonilla Aragon', 'Palmira', 'Colombia');

-- 1040 es piloto y tambien pasajera (tipo 'ambos')
INSERT INTO PERSONA (documento, nombres, apellidos, fecha_nacimiento, tipo_persona,
                     licencia, horas_vuelo, codigo_base, correo, millas) VALUES
('1010', 'Carlos Andres', 'Rojas Perez', '1980-03-12', 'piloto', 'LIC-0451', 12500, 'BOG', NULL, NULL),
('1020', 'Laura Marcela', 'Gomez Ruiz', '1988-07-25', 'piloto', 'LIC-0782', 6800, 'MDE', NULL, NULL),
('1030', 'Andres Felipe', 'Torres Diaz', '1975-11-02', 'piloto', 'LIC-0219', 15200, 'BOG', NULL, NULL),
('1040', 'Sofia Valentina', 'Herrera Mora', '1992-01-18', 'ambos', 'LIC-1033', 2900, 'CLO', 'sofia.herrera@correo.co', 1200),
('2010', 'Mateo', 'Sanchez Castro', '2000-05-30', 'pasajero', NULL, NULL, NULL, 'mateo.sanchez@correo.co', 5400),
('2020', 'Valeria', 'Ramirez Leon', '1997-09-14', 'pasajero', NULL, NULL, NULL, 'valeria.ramirez@correo.co', 800),
('2030', 'Santiago', 'Lopez Vargas', '1985-12-01', 'pasajero', NULL, NULL, NULL, 'santiago.lopez@correo.co', 15300),
('2040', 'Isabella', 'Martinez Gil', '2003-04-22', 'pasajero', NULL, NULL, NULL, 'isabella.martinez@correo.co', 0),
('2050', 'Daniel', 'Ortiz Navarro', '1979-08-08', 'pasajero', NULL, NULL, NULL, 'daniel.ortiz@correo.co', 9100);

INSERT INTO PER_TELEFONO (documento, telefono) VALUES
('1010', '3001112233'), ('1010', '6015550101'),
('1020', '3104445566'),
('1030', '3207778899'),
('1040', '3156667788'), ('1040', '3019990000'),
('2010', '3121234567'),
('2020', '3189876543'),
('2030', '3001239876'), ('2030', '6047771234'),
('2040', '3165554433'),
('2050', '3112223344');

INSERT INTO AVION (matricula, modelo, fabricante, codigo_base) VALUES
('HK-5001', 'A320', 'Airbus', 'BOG'),
('HK-5002', '737-800', 'Boeing', 'MDE'),
('HK-5003', 'ATR 72', 'ATR', 'CLO'),
('HK-6001', '767-300F', 'Boeing', 'BOG'),
('HK-7001', '172', 'Cessna', 'BOG');   -- avion de entrenamiento: no es comercial ni de carga

INSERT INTO AVION_COMERCIAL (matricula, num_asientos) VALUES
('HK-5001', 180), ('HK-5002', 160), ('HK-5003', 70);

INSERT INTO AVION_CARGA (matricula, capacidad_kg) VALUES
('HK-6001', 52000.00);

INSERT INTO VUELO (id_vuelo, codigo, fecha, hora_salida, destino, matricula, codigo_base_origen) VALUES
(1, 'AV101', '2026-11-20', '06:30', 'Cartagena', 'HK-5001', 'BOG'),
(2, 'AV205', '2026-11-20', '09:15', 'Bogota', 'HK-5002', 'MDE'),
(3, 'AV310', '2026-11-21', '14:00', 'Cartagena', 'HK-5003', 'CLO'),
(4, 'AV101', '2026-11-22', '06:30', 'Cartagena', 'HK-5001', 'BOG'),
(5, 'CG900', '2026-11-22', '22:00', 'Miami', 'HK-6001', 'BOG'),
(6, 'AV420', '2026-11-23', '11:45', 'San Andres', 'HK-5002', 'MDE');

INSERT INTO TRIPULACION (documento, id_vuelo, rol) VALUES
('1010', 1, 'capitan'), ('1040', 1, 'copiloto'),
('1020', 2, 'capitan'), ('1030', 2, 'copiloto'),
('1040', 3, 'capitan'), ('1020', 3, 'copiloto'),
('1030', 4, 'capitan'), ('1010', 4, 'copiloto'),
('1030', 5, 'capitan'), ('1010', 5, 'copiloto'),
('1020', 6, 'capitan'), ('1040', 6, 'copiloto');

INSERT INTO RESERVA (documento, id_vuelo, asiento, clase) VALUES
('2010', 1, '12A', 'economica'),
('2010', 3, '5C', 'economica'),
('2010', 4, '14B', 'economica'),
('2020', 1, '2A', 'ejecutiva'),
('2020', 2, '8D', 'economica'),
('2030', 2, '1A', 'ejecutiva'),
('2030', 6, '3B', 'ejecutiva'),
('2040', 3, '20F', 'economica'),
('2040', 6, '22A', 'economica'),
('2050', 1, '15C', 'economica'),
('2050', 3, '9A', 'economica'),
('2050', 4, '2C', 'ejecutiva'),
('1040', 2, '18C', 'economica');

COMMIT;
