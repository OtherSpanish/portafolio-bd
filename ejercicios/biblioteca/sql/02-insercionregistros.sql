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
