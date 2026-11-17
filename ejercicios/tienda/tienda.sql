-- Tienda en línea - script completo (01 + 02 + 04 + 05). Probado en MySQL 8.0.

-- Tienda en línea - Bases de Datos 1
-- 01: creacion de la base de datos y de las 21 tablas
-- Las tablas van en orden: primero las que no dependen de otras.

SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS tienda
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE tienda;

-- CIUDAD
CREATE TABLE CIUDAD (
  id_ciudad int NOT NULL,
  nombre varchar(60) NOT NULL,
  departamento varchar(40) NOT NULL,
  PRIMARY KEY (id_ciudad)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- CLIENTE
CREATE TABLE CLIENTE (
  documento varchar(15) NOT NULL,
  nombres varchar(50) NOT NULL,
  apellidos varchar(50) NOT NULL,
  fecha_nacimiento date NOT NULL,
  correo varchar(80) NOT NULL,
  id_ciudad int NOT NULL,
  PRIMARY KEY (documento),
  UNIQUE KEY uq_cliente_correo (correo),
  CONSTRAINT fk_cliente_id_ciudad FOREIGN KEY (id_ciudad) REFERENCES CIUDAD (id_ciudad)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- PROVEEDOR
CREATE TABLE PROVEEDOR (
  nit varchar(12) NOT NULL,
  razon_social varchar(80) NOT NULL,
  PRIMARY KEY (nit),
  UNIQUE KEY uq_proveedor_razon_social (razon_social)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- MARCA
CREATE TABLE MARCA (
  id_marca int NOT NULL,
  nombre varchar(40) NOT NULL,
  pais varchar(40) NOT NULL,
  PRIMARY KEY (id_marca),
  UNIQUE KEY uq_marca_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- PEDIDO
CREATE TABLE PEDIDO (
  id_pedido int NOT NULL,
  fecha date NOT NULL,
  estado enum('pagado','enviado','entregado') NOT NULL,
  documento varchar(15) NOT NULL,
  PRIMARY KEY (id_pedido),
  CONSTRAINT fk_pedido_documento FOREIGN KEY (documento) REFERENCES CLIENTE (documento)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- CATEGORIA
CREATE TABLE CATEGORIA (
  id_categoria int NOT NULL,
  nombre varchar(40) NOT NULL,
  PRIMARY KEY (id_categoria),
  UNIQUE KEY uq_categoria_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- CUPON
CREATE TABLE CUPON (
  codigo_cupon varchar(12) NOT NULL,
  descuento_pct int NOT NULL,
  vence date NOT NULL,
  PRIMARY KEY (codigo_cupon)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- BODEGA
CREATE TABLE BODEGA (
  codigo_bodega char(3) NOT NULL,
  nombre varchar(60) NOT NULL,
  direccion varchar(80) NOT NULL,
  PRIMARY KEY (codigo_bodega)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- TRANSPORTADORA
CREATE TABLE TRANSPORTADORA (
  nit_transportadora varchar(12) NOT NULL,
  nombre varchar(60) NOT NULL,
  PRIMARY KEY (nit_transportadora),
  UNIQUE KEY uq_transportadora_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- CLI_TELEFONO
CREATE TABLE CLI_TELEFONO (
  documento varchar(15) NOT NULL,
  telefono varchar(15) NOT NULL,
  PRIMARY KEY (documento, telefono),
  CONSTRAINT fk_cli_telefono_documento FOREIGN KEY (documento) REFERENCES CLIENTE (documento)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- PEDIDO_CUPON
CREATE TABLE PEDIDO_CUPON (
  id_pedido int NOT NULL,
  codigo_cupon varchar(12) NOT NULL,
  PRIMARY KEY (id_pedido),
  CONSTRAINT fk_pedido_cupon_id_pedido FOREIGN KEY (id_pedido) REFERENCES PEDIDO (id_pedido),
  CONSTRAINT fk_pedido_cupon_codigo_cupon FOREIGN KEY (codigo_cupon) REFERENCES CUPON (codigo_cupon)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- SUBCATEGORIA
CREATE TABLE SUBCATEGORIA (
  id_subcategoria int NOT NULL,
  id_padre int NOT NULL,
  PRIMARY KEY (id_subcategoria),
  CONSTRAINT fk_subcategoria_id_subcategoria FOREIGN KEY (id_subcategoria) REFERENCES CATEGORIA (id_categoria),
  CONSTRAINT fk_subcategoria_id_padre FOREIGN KEY (id_padre) REFERENCES CATEGORIA (id_categoria)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- PAGO
CREATE TABLE PAGO (
  id_pago int NOT NULL,
  fecha date NOT NULL,
  valor decimal(12,2) NOT NULL,
  id_pedido int NOT NULL,
  PRIMARY KEY (id_pago),
  CONSTRAINT fk_pago_id_pedido FOREIGN KEY (id_pedido) REFERENCES PEDIDO (id_pedido)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- TARJETA
CREATE TABLE TARJETA (
  id_pago int NOT NULL,
  franquicia varchar(20) NOT NULL,
  ultimos4 char(4) NOT NULL,
  PRIMARY KEY (id_pago),
  CONSTRAINT fk_tarjeta_id_pago FOREIGN KEY (id_pago) REFERENCES PAGO (id_pago)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- PSE
CREATE TABLE PSE (
  id_pago int NOT NULL,
  banco varchar(40) NOT NULL,
  PRIMARY KEY (id_pago),
  CONSTRAINT fk_pse_id_pago FOREIGN KEY (id_pago) REFERENCES PAGO (id_pago)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- PRODUCTO
CREATE TABLE PRODUCTO (
  sku varchar(10) NOT NULL,
  nombre varchar(80) NOT NULL,
  precio decimal(12,2) NOT NULL,
  id_marca int NOT NULL,
  id_categoria int NOT NULL,
  PRIMARY KEY (sku),
  CONSTRAINT fk_producto_id_marca FOREIGN KEY (id_marca) REFERENCES MARCA (id_marca),
  CONSTRAINT fk_producto_id_categoria FOREIGN KEY (id_categoria) REFERENCES CATEGORIA (id_categoria)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ENVIO
CREATE TABLE ENVIO (
  numero_guia varchar(15) NOT NULL,
  fecha_envio date NOT NULL,
  fecha_entrega date DEFAULT NULL,
  id_pedido int NOT NULL,
  nit_transportadora varchar(12) NOT NULL,
  codigo_bodega char(3) NOT NULL,
  PRIMARY KEY (numero_guia),
  UNIQUE KEY uq_envio_id_pedido (id_pedido),
  CONSTRAINT fk_envio_id_pedido FOREIGN KEY (id_pedido) REFERENCES PEDIDO (id_pedido),
  CONSTRAINT fk_envio_nit_transportadora FOREIGN KEY (nit_transportadora) REFERENCES TRANSPORTADORA (nit_transportadora),
  CONSTRAINT fk_envio_codigo_bodega FOREIGN KEY (codigo_bodega) REFERENCES BODEGA (codigo_bodega)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- PRO_COLOR
CREATE TABLE PRO_COLOR (
  sku varchar(10) NOT NULL,
  color varchar(20) NOT NULL,
  PRIMARY KEY (sku, color),
  CONSTRAINT fk_pro_color_sku FOREIGN KEY (sku) REFERENCES PRODUCTO (sku)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- DETALLE
CREATE TABLE DETALLE (
  id_pedido int NOT NULL,
  sku varchar(10) NOT NULL,
  cantidad int NOT NULL,
  precio_unitario decimal(12,2) NOT NULL,
  PRIMARY KEY (id_pedido, sku),
  CONSTRAINT fk_detalle_id_pedido FOREIGN KEY (id_pedido) REFERENCES PEDIDO (id_pedido),
  CONSTRAINT fk_detalle_sku FOREIGN KEY (sku) REFERENCES PRODUCTO (sku)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- INVENTARIO
CREATE TABLE INVENTARIO (
  sku varchar(10) NOT NULL,
  codigo_bodega char(3) NOT NULL,
  stock int NOT NULL,
  PRIMARY KEY (sku, codigo_bodega),
  CONSTRAINT fk_inventario_sku FOREIGN KEY (sku) REFERENCES PRODUCTO (sku),
  CONSTRAINT fk_inventario_codigo_bodega FOREIGN KEY (codigo_bodega) REFERENCES BODEGA (codigo_bodega)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- SUMINISTRO
CREATE TABLE SUMINISTRO (
  nit varchar(12) NOT NULL,
  sku varchar(10) NOT NULL,
  precio_compra decimal(12,2) NOT NULL,
  PRIMARY KEY (nit, sku),
  CONSTRAINT fk_suministro_nit FOREIGN KEY (nit) REFERENCES PROVEEDOR (nit),
  CONSTRAINT fk_suministro_sku FOREIGN KEY (sku) REFERENCES PRODUCTO (sku)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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

-- Tienda en línea - Bases de Datos 1
-- 04: restricciones adicionales de los supuestos

USE tienda;

-- cantidades, precios y stock positivos
ALTER TABLE DETALLE ADD CONSTRAINT ck_detalle_valores CHECK (cantidad > 0 AND precio_unitario > 0);
ALTER TABLE INVENTARIO ADD CONSTRAINT ck_inventario_stock CHECK (stock >= 0);
ALTER TABLE PAGO ADD CONSTRAINT ck_pago_valor CHECK (valor > 0);

-- el descuento va de 1 a 50 por ciento
ALTER TABLE CUPON ADD CONSTRAINT ck_cupon_pct CHECK (descuento_pct BETWEEN 1 AND 50);

-- una categoria no puede estar dentro de si misma
ALTER TABLE SUBCATEGORIA ADD CONSTRAINT ck_subcategoria_distinta CHECK (id_subcategoria <> id_padre);

-- la entrega no puede ser antes del envio
ALTER TABLE ENVIO ADD CONSTRAINT ck_envio_fechas CHECK (fecha_entrega IS NULL OR fecha_entrega >= fecha_envio);

-- Tienda en línea - Bases de Datos 1
-- 05: vistas (consultas guardadas, no guardan datos)

USE tienda;

-- edad es derivado: no se guarda, se calcula
CREATE OR REPLACE VIEW v_cliente_edad AS
SELECT x.documento, TIMESTAMPDIFF(YEAR, x.fecha_nacimiento, CURDATE()) AS edad
FROM CLIENTE x;

-- a qué subtipo pertenece cada pago
CREATE OR REPLACE VIEW v_tipo_pago AS
SELECT x.id_pago,
       CASE
         WHEN s0.id_pago IS NOT NULL THEN 'tarjeta'
         WHEN s1.id_pago IS NOT NULL THEN 'pse'
         ELSE 'ninguno'
       END AS tipo
FROM PAGO x
LEFT JOIN TARJETA s0 ON s0.id_pago = x.id_pago
LEFT JOIN PSE s1 ON s1.id_pago = x.id_pago;
