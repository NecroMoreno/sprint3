/* PROBLEMA La empresa “Te lo Vendo” es un emprendimiento de un grupo de jóvenes, quienes necesitan vender sus productos en línea. 
Actualmente toman sus pedidos vía telefónica y a través del correo electrónico. Al no existir un sistema centralizado para los pedidos, 
es complejo tener control oportuno de las entregas, lo que genera que en algunos casos no se concreten algunos pedidos. 
Una opción propuesta es manejar una planilla de cálculo para el registro de los pedidos y realización de seguimiento. 
Si bien es factible su uso, a medida que se agreguen nuevos clientes el archivo irá creciendo, y será complejo mantener la integridad entre los datos, 
impidiendo relacionarlos adecuadamente. */

/* 
SOLUCIÓN 
Dados los antecedentes anteriores, es necesario desarrollar una solución tecnológica que cubra los procesos de negocio descritos y que proponga una mejora en la gestión, 
el control, la seguridad, y disponibilidad de información para el negocio y sus clientes. 
El sistema debe permitir presentar productos, tomar pedidos y hacer seguimiento de estos y la gestión de clientes. 
Además, se requiere que el sistema genere reportes y estadísticas que ayuden a tomar de decisiones y mejorar el rendimiento de la empresa, 
considerando la cantidad de clientes, y la demanda de éstos. 
Es imprescindible mantener comunicación con los encargados de entregar los pedidos, y darles la posibilidad de realizar todas sus actividades teniendo conectividad a través de dispositivos móviles. 
*/

-- SPRINT DE ENTREGA: 
-- Se solicita como entregable de este Sprint la implementación final de todos los conceptos vistos durante el Módulo 3: Bases de datos. 
-- Por tanto, se debe poner foco en lo siguiente: 
-- Comentar debidamente el código para que sea comprensible por un tercero. 
-- El script SQL debe utilizarse para crear la estructura de la base de datos, realizar operaciones en la base de datos (p. ej. rellenarla con datos) y cambiar o eliminar la estructura de la base de datos. 
-- Deben crear un usuario con privilegios para crear, eliminar y modificar tablas, insertar registros. 

-- Nuestra tienda virtual ha crecido mucho estas últimas semanas. No solo aumentó significativamente el número de colaboradores y usuarios, sino que también los productos disponibles. 
-- En este sentido, nos pidieron que diseñemos una base de datos capaz de satisfacer la creciente demanda de información y datos. 
-- TeLoVendo recibe productos de diferentes proveedores para comercializarlos.


-- esto se aplica como root
-- se crea la BD se selecciona la BD, luego se crea el usuario y sus permisos sobre la bd/esquema telovendo.
CREATE DATABASE telovendo;
USE telovendo;
CREATE USER 'admintlv'@'localhost' IDENTIFIED BY 'admin';
GRANT ALL PRIVILEGES ON telovendo.* TO 'admintlv'@'localhost';

/* Cada proveedor debe informarnos el nombre del representante legal, su nombre corporativo, al menos dos teléfonos de contacto (y el nombre de quien recibe las llamadas), 
la categoría de sus productos (solo nos pueden indicar una categoría) y un correo electrónico para enviar la factura. */

CREATE TABLE proveedores(
idProveedor MEDIUMINT NOT NULL AUTO_INCREMENT,
nombreCorporativo VARCHAR(40),
nombreRepresentate VARCHAR(40),
telefono1 VARCHAR(15),
telefono2 VARCHAR(15),
nombreAtiende VARCHAR(40),
categoria VARCHAR(50),
email VARCHAR(60),
PRIMARY KEY(idProveedor)
);

CREATE TABLE clientes(
	idCliente MEDIUMINT NOT NULL AUTO_INCREMENT,
	Direccion VARCHAR(60),
	nombre VARCHAR(40),
    apellido VARCHAR(40),
    telefono VARCHAR(15),
    fechaRegistro DATE,
	PRIMARY KEY(idCliente)
);

CREATE TABLE productos(
	idProducto MEDIUMINT NOT NULL AUTO_INCREMENT,
	idProveedor MEDIUMINT NOT NULL,
    sku CHAR(10),
    nombre VARCHAR(40),
	categoria VARCHAR(40),
	color VARCHAR(20),
    precioUnidadVenta INT,
    stock INT,
	PRIMARY KEY(idProducto,idProveedor),
	CONSTRAINT idProveedor FOREIGN KEY(idProveedor) REFERENCES proveedores(idProveedor)
);

-- un cliente puede comprar muchos productos, un producto puede ser comprado por varios clientes. Una boleta puede tener varios productos en ella y está asociada a un solo cliente, 
-- y un cliente puede estar asociado a varias boletas. 
CREATE TABLE boletas(
    idBoleta MEDIUMINT NOT NULL AUTO_INCREMENT,
    montoTotal INT,
    IVA INT,
    fecha DATETIME DEFAULT NOW(),
	PRIMARY KEY(idBoleta)
);

CREATE TABLE clientesProductos(
	idCliente MEDIUMINT NOT NULL,
	idProducto MEDIUMINT NOT NULL,
    idProveedor MEDIUMINT NOT NULL,
	idBoleta MEDIUMINT NOT NULL,
    cantidadComprada SMALLINT,
	PRIMARY KEY(idcliente,idProducto),
	CONSTRAINT idCliente FOREIGN KEY(idCliente) REFERENCES clientes(idCliente),
    CONSTRAINT idBoleta FOREIGN KEY(idBoleta) REFERENCES boletas(idBoleta),
	CONSTRAINT idProducto FOREIGN KEY(idProducto) REFERENCES productos(idProducto),
    CONSTRAINT idProveedorfk FOREIGN KEY(idProveedor) REFERENCES productos(idProveedor)
);

/* Sabemos que la mayoría de los proveedores son de productos electrónicos. 
Agregue 5 proveedores a la base de datos. 
En general, los proveedores venden muchos productos. */

INSERT INTO proveedores(nombreCorporativo, nombreRepresentate, telefono1, telefono2, nombreAtiende, categoria, email) VALUES
('Samsung','Sekito Fukiyama','977775840','977775841','sakayato','electrónicos','ventas@samsungcorp.com'),
('Cougar','Filipo Garcia','957426222','957426223','Julio','Linea Gamer','ventasla@cougarco.com'),
('Raspberry','Qu Yuan','958741236','958741237','Yuan Li','electrónica','ventas@raspberryfundation.com'),
('Arduino','Massimo Banzi','932145874','932145874','Achille Montanaro','electrónica','ventas@arduino.cc.com'),
('Xiaomi','Hans Tung','977775840','977775841','Erwin van der Valk','electrónicos','ventas@xiaomi.com');

/* TeLoVendo tiene actualmente muchos clientes, pero nos piden que ingresemos solo 5 para probar la nueva base de datos.
 Cada cliente tiene un nombre, apellido, dirección (solo pueden ingresar una).*/ 
INSERT INTO clientes (Direccion, nombre, apellido, telefono, fechaRegistro) 
VALUES 
('calle 1','Andres','Iniesta','995550213','1999-04-22'),
('calle 2', 'Cristiano','Ronaldo','995550243','2002-05-07'),
('calle 3', 'Gerard', 'Pikard','995550243','2003-10-07'),
('calle 4','Lionel','Messi','995551243','2003-04-10'),
('calle 13','Neymar','da Silva','995552244','2005-05-09');
 /* TeLoVendo tiene diferentes productos. 
 Ingrese 10 productos y su respectivo stock. Cada producto tiene información sobre su precio, su categoría, proveedor y color. Los productos pueden tener muchos proveedores. */
 
INSERT INTO productos 
(idProducto, idProveedor,sku, nombre, categoria, color, precioUnidadVenta, stock)
VALUES 
('1','1','00-456-AB','Mouse','Electronicos','Rosado','9990','50'),
('1','2','00-123-AA','Mouse','Electronicos','Negro','21990','30'),
('1','5','00-234-BC','Mouse','Electronicos','Blanco','29900','75'),
('2','1','01-890-CC','Amplificador','Electronicos','Blanco','149990','15'),
('2','5','01-890-CB','Amplificador','Electronicos','Gris','489900','10'),
('3','5','11-123-BA','Drone Fimi','Electronicos','Blanco','409000','5'),
('4','4','901234-AB','Arduino one','Electronica','Azul','13990','100'),
('5','3','012345-AB','Raspberry Pi 4','Electronica','Verde','115000','150'),
('6','1','00-456-AB','Led Smart TV','Electronicos','Negro','284990','30'),
('6','5','00-123-AA','Led Smart TV','Electronicos','Negro','159990','40');
 
 -- relleno de las otras tablas

INSERT INTO boletas(montoTotal, IVA) VALUES
(484900, 92131),
(9990, 1898),
(284990, 54148),
(459830, 87367),
(1227000, 233130),
(899700, 170943);

 INSERT INTO clientesProductos(idCliente, idProducto, idProveedor, idBoleta,cantidadComprada)VALUES
 ('1','5','3','1','3'),
 ('1','4','4','1','10'),
 ('2','1','1','2','1'),
 ('2','6','1','3','1'),
 ('5','1','1','4','15'),
 ('5','6','5','4','1'),
 ('5','2','1','4','1'),
 ('3','3','5','5','3'),
 ('4','1','5','6','30');
 
 -- Como un entregable, nos piden que diseñemos un diagrama entidad relación sólo con la información que tenemos. 
 -- En caso de tener nuevas ideas respecto a futura información requerida y nuevas entidades, solo nos piden que la indiquemos en un archivo .docx. 
 -- A partir del diagrama, debemos construir un script que cree tablas de acuerdo a las entidades e ingrese datos.
 
 -- Luego debemos realizar consultas SQL que indiquen:
-- Cuál es la categoría de productos que más se repite. 

SELECT categoria,count(categoria) AS c FROM productos GROUP BY categoria ORDER by c DESC LIMIT 1;

-- Cuáles son los productos con mayor stock 

SELECT nombre, SUM(stock) AS s FROM productos GROUP BY idProducto ORDER by s DESC;

-- Qué color de producto es más común en nuestra tienda. 

SELECT color, COUNT(color) AS c FROM productos GROUP BY color ORDER by c DESC;

-- Cual o cuales son los proveedores con menor stock de productos. 

SELECT nombreCorporativo, SUM(stock) AS s FROM productos 
JOIN proveedores ON proveedores.idProveedor = productos.idProveedor
GROUP BY productos.idProveedor ORDER by s ASC;

-- Por último: 
-- Cambien la categoría de productos más popular por ‘Electrónica y computación’. 

START TRANSACTION;

SELECT  @idProductoPopular := clientesProductos.idProducto, SUM(cantidadComprada) AS s FROM clientesProductos
GROUP BY clientesProductos.idProducto ORDER by s DESC LIMIT 1;

UPDATE productos
SET categoria = "Electrónica y computación"
WHERE idProducto = @idProductoPopular;
COMMIT;

-- Deben subir el trabajo a un repositorio en Git-Hub.
-- https://github.com/NecroMoreno/sprint3.git 
-- A modo de entrega, se debe disponer un documento Word o PDF en el que se indique: 
-- Los nombres de los integrantes del equipo 
-- Ruta del repositorio en GitHub Consideraciones adicionales 
-- El código debe estar debidamente comentado