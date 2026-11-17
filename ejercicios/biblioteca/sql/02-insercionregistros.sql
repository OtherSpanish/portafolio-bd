-- Red de bibliotecas - Bases de Datos 1
-- 02: registros de prueba, en una sola transaccion

USE biblioteca;

START TRANSACTION;

INSERT INTO AUTOR (id_autor, nombre, nacionalidad) VALUES
(1, 'Gabriel Garcia Marquez', 'colombiana'),
(2, 'Isabel Allende', 'chilena'),
(3, 'Julio Cortazar', 'argentina'),
(4, 'Rafael Pombo', 'colombiana'),
(5, 'Laura Restrepo', 'colombiana'),
(6, 'Pilar Quintana', 'colombiana');

INSERT INTO EDITORIAL (id_editorial, nombre, pais) VALUES
(1, 'Penguin Random House', 'Espana'),
(2, 'Planeta', 'Espana'),
(3, 'Panamericana', 'Colombia');

INSERT INTO SEDE (codigo_sede, nombre, localidad) VALUES
('VBA', 'Biblioteca Virgilio Barco', 'Teusaquillo'),
('TIN', 'Biblioteca El Tintal', 'Kennedy'),
('TUN', 'Biblioteca El Tunal', 'Tunjuelito');

INSERT INTO LECTOR (carne, nombres, apellidos, fecha_nacimiento, correo, tipo_lector, acudiente, ocupacion) VALUES
('L-1001', 'Valeria', 'Cruz Leon', '2014-03-02', NULL, 'infantil', 'Martha Leon', NULL),
('L-1002', 'Nicolas', 'Arias Cano', '1990-07-19', 'nicolas.arias@correo.co', 'adulto', NULL, 'contador'),
('L-1003', 'Emilio', 'Duarte Gil', '1958-11-04', 'emilio.duarte@correo.co', 'adulto', NULL, 'pensionado'),
('L-1004', 'Luciana', 'Romero Sol', '2016-09-27', NULL, 'infantil', 'Andres Romero', NULL),
('L-1005', 'Ignacio', 'Vargas Lima', '2001-01-15', 'ignacio.vargas@correo.co', 'adulto', NULL, 'estudiante'),
('L-1006', 'Sofia', 'Beltran Ruiz', '1985-05-08', 'sofia.beltran@correo.co', 'adulto', NULL, 'docente');

INSERT INTO BIBLIOTECARIO (id_bibliotecario, nombres, apellidos, turno, codigo_sede) VALUES
('B01', 'Hernando', 'Lozada Rey', 'manana', 'VBA'),
('B02', 'Patricia', 'Ospina Vela', 'tarde', 'VBA'),
('B03', 'German', 'Riascos Mesa', 'manana', 'TIN'),
('B04', 'Teresa', 'Galindo Paz', 'tarde', 'TUN');

INSERT INTO LEC_TELEFONO (carne, telefono) VALUES
('L-1001', '3201112233'),
('L-1002', '3002223344'),
('L-1002', '6013334455'),
('L-1003', '3104445566'),
('L-1004', '3115556677'),
('L-1005', '3126667788'),
('L-1005', '6017778899'),
('L-1006', '3138889900');

INSERT INTO LIBRO (isbn, titulo, anio, id_editorial) VALUES
('9789584279', 'Cien anos de soledad', 1967, 1),
('9789584280', 'Cronica de una muerte anunciada', 1981, 1),
('9789584281', 'La casa de los espiritus', 1982, 2),
('9789584282', 'Rayuela', 1963, 1),
('9789584283', 'Cuentos pintados', 1867, 3),
('9789584284', 'Delirio', 2004, 2),
('9789584285', 'Cuentos de America', 2010, 3);

INSERT INTO EJEMPLAR (codigo_barras, estado, isbn, codigo_sede) VALUES
('EJ-001', 'bueno', '9789584279', 'VBA'),
('EJ-002', 'regular', '9789584279', 'TIN'),
('EJ-003', 'bueno', '9789584280', 'VBA'),
('EJ-004', 'bueno', '9789584281', 'TUN'),
('EJ-005', 'danado', '9789584282', 'VBA'),
('EJ-006', 'bueno', '9789584283', 'TIN'),
('EJ-007', 'bueno', '9789584283', 'TUN'),
('EJ-008', 'regular', '9789584284', 'VBA'),
('EJ-009', 'bueno', '9789584285', 'TIN');

INSERT INTO AUTORIA (id_autor, isbn) VALUES
(1, '9789584279'),
(1, '9789584280'),
(2, '9789584281'),
(3, '9789584282'),
(4, '9789584283'),
(5, '9789584284'),
(3, '9789584285'),
(1, '9789584285');

INSERT INTO PRESTAMO (carne, codigo_barras, id_bibliotecario, fecha_prestamo, fecha_devolucion) VALUES
('L-1002', 'EJ-001', 'B01', '2026-10-01', '2026-10-15'),
('L-1002', 'EJ-003', 'B02', '2026-10-20', '2026-11-02'),
('L-1002', 'EJ-008', 'B01', '2026-11-05', NULL),
('L-1003', 'EJ-001', 'B02', '2026-10-18', '2026-10-30'),
('L-1001', 'EJ-006', 'B03', '2026-10-10', '2026-10-24'),
('L-1004', 'EJ-007', 'B04', '2026-11-03', NULL),
('L-1005', 'EJ-002', 'B03', '2026-11-01', '2026-11-12'),
('L-1006', 'EJ-005', 'B01', '2026-09-15', '2026-09-29'),
('L-1005', 'EJ-001', 'B01', '2026-11-10', NULL);

COMMIT;
