-- Tienda en línea - Bases de Datos 1
-- 02: registros de prueba, en una sola transaccion

USE tienda;

START TRANSACTION;

INSERT INTO CIUDAD (id_ciudad, nombre, departamento) VALUES
(1, 'Bogota', 'Cundinamarca'),
(2, 'Medellin', 'Antioquia'),
(3, 'Cali', 'Valle del Cauca'),
(4, 'Barranquilla', 'Atlantico');

INSERT INTO CLIENTE (documento, nombres, apellidos, fecha_nacimiento, correo, id_ciudad) VALUES
('1001', 'Laura Sofia', 'Pardo Rincon', '1996-02-14', 'laura.pardo@correo.co', 1),
('1002', 'Miguel Angel', 'Restrepo Vela', '1988-07-03', 'miguel.restrepo@correo.co', 2),
('1003', 'Daniela', 'Ocampo Ruiz', '2001-11-21', 'daniela.ocampo@correo.co', 3),
('1004', 'Jorge', 'Barrios Mena', '1975-05-30', 'jorge.barrios@correo.co', 4),
('1005', 'Paula Andrea', 'Salcedo Gil', '1992-09-09', 'paula.salcedo@correo.co', 1),
('1006', 'Andres', 'Quiceno Lara', '1999-03-17', 'andres.quiceno@correo.co', 2);

INSERT INTO PROVEEDOR (nit, razon_social) VALUES
('900111222', 'Distribuidora Andina SAS'),
('900333444', 'Tecnoimport Ltda'),
('900555666', 'Mayorista del Caribe');

INSERT INTO MARCA (id_marca, nombre, pais) VALUES
(1, 'Samsung', 'Corea del Sur'),
(2, 'Lenovo', 'China'),
(3, 'Logitech', 'Suiza'),
(4, 'Xiaomi', 'China');

INSERT INTO PEDIDO (id_pedido, fecha, estado, documento) VALUES
(1, '2026-11-02', 'entregado', '1001'),
(2, '2026-11-03', 'entregado', '1002'),
(3, '2026-11-05', 'enviado', '1001'),
(4, '2026-11-08', 'pagado', '1003'),
(5, '2026-11-09', 'entregado', '1004'),
(6, '2026-11-10', 'enviado', '1005'),
(7, '2026-11-12', 'pagado', '1001'),
(8, '2026-11-13', 'pagado', '1006');

INSERT INTO CATEGORIA (id_categoria, nombre) VALUES
(1, 'Tecnologia'),
(2, 'Computadores'),
(3, 'Celulares'),
(4, 'Accesorios'),
(5, 'Portatiles');

INSERT INTO CUPON (codigo_cupon, descuento_pct, vence) VALUES
('BIENVENIDA10', 10, '2026-12-31'),
('NAVIDAD15', 15, '2026-12-25'),
('CYBER20', 20, '2026-11-30'),
('VIP25', 25, '2027-03-31');

INSERT INTO BODEGA (codigo_bodega, nombre, direccion) VALUES
('BOG', 'Bodega Fontibon', 'Cll 17 # 96-40'),
('MED', 'Bodega Itagui', 'Cra 50 # 30-12'),
('BAQ', 'Bodega Malambo', 'Via 40 # 85-10');

INSERT INTO TRANSPORTADORA (nit_transportadora, nombre) VALUES
('800100200', 'Servientrega'),
('800300400', 'Coordinadora'),
('800500600', 'Interrapidisimo');

INSERT INTO CLI_TELEFONO (documento, telefono) VALUES
('1001', '3001112233'),
('1001', '6014445566'),
('1002', '3102223344'),
('1003', '3153334455'),
('1004', '3004445566'),
('1004', '6053334455'),
('1005', '3115556677'),
('1006', '3126667788');

INSERT INTO PEDIDO_CUPON (id_pedido, codigo_cupon) VALUES
(1, 'BIENVENIDA10'),
(3, 'CYBER20'),
(5, 'NAVIDAD15'),
(8, 'BIENVENIDA10');

INSERT INTO SUBCATEGORIA (id_subcategoria, id_padre) VALUES
(2, 1),
(3, 1),
(4, 1),
(5, 2);

INSERT INTO PAGO (id_pago, fecha, valor, id_pedido) VALUES
(1, '2026-11-02', 1863000, 1),
(2, '2026-11-03', 2800000, 2),
(3, '2026-11-05', 624000, 3),
(4, '2026-11-08', 980000, 4),
(5, '2026-11-09', 2000000, 5),
(6, '2026-11-10', 1086000, 5),
(7, '2026-11-10', 3200000, 6),
(8, '2026-11-12', 2350000, 7),
(9, '2026-11-13', 1666000, 8);

INSERT INTO TARJETA (id_pago, franquicia, ultimos4) VALUES
(1, 'Visa', '4417'),
(3, 'Mastercard', '8820'),
(5, 'Visa', '1032'),
(7, 'Amex', '3005'),
(9, 'Visa', '4417');

INSERT INTO PSE (id_pago, banco) VALUES
(2, 'Bancolombia'),
(6, 'Davivienda'),
(8, 'Banco de Bogota');

INSERT INTO PRODUCTO (sku, nombre, precio, id_marca, id_categoria) VALUES
('SKU-001', 'Galaxy A55', 1650000, 1, 3),
('SKU-002', 'IdeaPad Slim 3', 2400000, 2, 5),
('SKU-003', 'Mouse MX Master 3S', 420000, 3, 4),
('SKU-004', 'Redmi Note 13', 980000, 4, 3),
('SKU-005', 'Teclado K380', 180000, 3, 4),
('SKU-006', 'Galaxy Tab S9', 3100000, 1, 1);

INSERT INTO ENVIO (numero_guia, fecha_envio, fecha_entrega, id_pedido, nit_transportadora, codigo_bodega) VALUES
('GU-10001', '2026-11-03', '2026-11-05', 1, '800100200', 'BOG'),
('GU-10002', '2026-11-04', '2026-11-07', 2, '800300400', 'BOG'),
('GU-10003', '2026-11-06', NULL, 3, '800100200', 'BOG'),
('GU-10004', '2026-11-10', '2026-11-13', 5, '800500600', 'BAQ'),
('GU-10005', '2026-11-11', NULL, 6, '800300400', 'MED');

INSERT INTO PRO_COLOR (sku, color) VALUES
('SKU-001', 'azul'),
('SKU-001', 'negro'),
('SKU-002', 'gris'),
('SKU-003', 'blanco'),
('SKU-003', 'grafito'),
('SKU-004', 'negro'),
('SKU-005', 'gris'),
('SKU-005', 'rosado'),
('SKU-006', 'plata');

INSERT INTO DETALLE (id_pedido, sku, cantidad, precio_unitario) VALUES
(1, 'SKU-001', 1, 1650000),
(1, 'SKU-003', 1, 420000),
(2, 'SKU-002', 1, 2400000),
(2, 'SKU-003', 1, 400000),
(3, 'SKU-005', 2, 180000),
(3, 'SKU-003', 1, 420000),
(4, 'SKU-004', 1, 980000),
(5, 'SKU-006', 1, 3100000),
(5, 'SKU-005', 1, 180000),
(6, 'SKU-001', 2, 1600000),
(7, 'SKU-002', 1, 2350000),
(8, 'SKU-004', 2, 980000);

INSERT INTO INVENTARIO (sku, codigo_bodega, stock) VALUES
('SKU-001', 'BOG', 25),
('SKU-001', 'MED', 10),
('SKU-002', 'BOG', 8),
('SKU-003', 'BOG', 40),
('SKU-003', 'BAQ', 15),
('SKU-004', 'MED', 30),
('SKU-005', 'BOG', 60),
('SKU-006', 'BAQ', 5);

INSERT INTO SUMINISTRO (nit, sku, precio_compra) VALUES
('900111222', 'SKU-001', 1320000),
('900111222', 'SKU-004', 760000),
('900333444', 'SKU-002', 1950000),
('900333444', 'SKU-003', 300000),
('900333444', 'SKU-005', 120000),
('900555666', 'SKU-006', 2500000),
('900555666', 'SKU-001', 1300000);

COMMIT;
