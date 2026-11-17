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
