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
