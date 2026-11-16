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
