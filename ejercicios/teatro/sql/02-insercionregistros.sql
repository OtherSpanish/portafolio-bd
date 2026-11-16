-- Teatro - Bases de Datos 1
-- 02: registros de prueba (64), en una sola transaccion

USE teatro;



START TRANSACTION;



INSERT INTO TEATRO (codigo_teatro, nombre, ciudad, pais) VALUES
('BOG', 'Teatro Colon', 'Bogota', 'Colombia'),
('MED', 'Teatro Pablo Tobon', 'Medellin', 'Colombia'),
('CAL', 'Teatro Municipal', 'Cali', 'Colombia');

INSERT INTO PERSONA (documento, nombres, apellidos, fecha_nacimiento, tipo_persona,
                     carnet, anios_carrera, codigo_teatro, correo, puntos) VALUES
('1010', 'Alejandro', 'Buitrago Diaz', '1980-03-12', 'actor', 'ACT-301', 22, 'BOG', NULL, NULL),
('1020', 'Carolina', 'Restrepo Gil', '1988-07-25', 'actor', 'ACT-455', 11, 'MED', NULL, NULL),
('1030', 'Gustavo', 'Arenas Polo', '1975-11-02', 'actor', 'ACT-118', 30, 'BOG', NULL, NULL),
('1040', 'Elena Maria', 'Montes Ruiz', '1992-01-18', 'ambos', 'ACT-602', 6, 'CAL', 'elena.montes@correo.co', 120),
('2010', 'Pablo', 'Sierra Cano', '2000-05-30', 'espectador', NULL, NULL, NULL, 'pablo.sierra@correo.co', 540),
('2020', 'Juliana', 'Velez Mora', '1997-09-14', 'espectador', NULL, NULL, NULL, 'juliana.velez@correo.co', 60),
('2030', 'Martin', 'Ochoa Prada', '1985-12-01', 'espectador', NULL, NULL, NULL, 'martin.ochoa@correo.co', 980),
('2040', 'Antonia', 'Rey Salas', '2003-04-22', 'espectador', NULL, NULL, NULL, 'antonia.rey@correo.co', 0),
('2050', 'Simon', 'Castano Leon', '1979-08-08', 'espectador', NULL, NULL, NULL, 'simon.castano@correo.co', 730);

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

INSERT INTO SALA (codigo_sala, nombre_sala, piso, codigo_teatro) VALUES
('SA-01', 'Sala Principal', 'Piso 1', 'BOG'),
('SA-02', 'Sala Estudio', 'Piso 2', 'MED'),
('SA-03', 'Sala Grande', 'Piso 1', 'CAL'),
('SA-04', 'Sala Estudio', 'Piso 3', 'BOG'),
('SA-05', 'Foyer', 'Piso 1', 'BOG');

INSERT INTO SALA_MAYOR (codigo_sala, num_sillas) VALUES
('SA-01', 750),
('SA-02', 420),
('SA-03', 600);

INSERT INTO SALA_ENSAYO (codigo_sala, area_m2) VALUES
('SA-04', 95.00);

INSERT INTO FUNCION (id_funcion, codigo, fecha, hora_inicio, obra, codigo_sala, teatro_funcion) VALUES
(1, 'HAM01', '2026-10-02', '19:00', 'Hamlet', 'SA-01', 'BOG'),
(2, 'BOD02', '2026-10-02', '20:00', 'Bodas de Sangre', 'SA-02', 'MED'),
(3, 'HAM03', '2026-10-03', '19:00', 'Hamlet', 'SA-03', 'CAL'),
(4, 'HAM01', '2026-10-04', '19:00', 'Hamlet', 'SA-01', 'BOG'),
(5, 'ENS05', '2026-10-04', '10:00', 'Ensayo General', 'SA-04', 'BOG'),
(6, 'MIS06', '2026-10-05', '17:00', 'La Miseria', 'SA-02', 'MED');

INSERT INTO ELENCO (documento, id_funcion, rol) VALUES
('1010', 1, 'protagonista'),
('1040', 1, 'reparto'),
('1020', 2, 'protagonista'),
('1030', 2, 'reparto'),
('1040', 3, 'protagonista'),
('1020', 3, 'reparto'),
('1030', 4, 'protagonista'),
('1010', 4, 'reparto'),
('1030', 5, 'protagonista'),
('1010', 5, 'reparto'),
('1020', 6, 'protagonista'),
('1040', 6, 'reparto');

INSERT INTO BOLETA (documento, id_funcion, silla, zona) VALUES
('2010', 1, 'F12', 'general'),
('2010', 3, 'A05', 'general'),
('2010', 4, 'C14', 'general'),
('2020', 1, 'P02', 'palco'),
('2020', 2, 'D08', 'general'),
('2030', 2, 'P01', 'palco'),
('2030', 6, 'P03', 'palco'),
('2040', 3, 'H20', 'general'),
('2040', 6, 'J22', 'general'),
('2050', 1, 'F15', 'general'),
('2050', 3, 'B09', 'general'),
('2050', 4, 'P04', 'palco'),
('1040', 2, 'E18', 'general');



COMMIT;
