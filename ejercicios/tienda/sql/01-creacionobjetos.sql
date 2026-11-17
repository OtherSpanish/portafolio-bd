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
