-- 1)  Cargar el respaldo de la base de datos unidad2.sql

-- Me conecto a través de shell de psql y ejecuto lo siguiente, para crear la base de datos a utilizar

CREATE DATABASE unidad2;

-- Posteriormente guardo el script unidad2.sql en la carpeta bin de mi postgreSQL, luego abro una cmd y entro a la siguiente ruta

-- C:\Program Files\PostgreSQL\14\bin

-- Una vez en la ruta, ejecuto lo siguiente para cargar unidad2.sql

-- psql -h localhost -p 5433 -U postgres -f unidad2.sql unidad2

-- Lo que finalmente carga en la base de datos lo suministrado por el apoyo



-- 2) Primera transacción mediante SQL Shell (psql)

-- Primero me conecto a la base de datos, y verifico que las tablas existan

-- \c unidad2

-- \dt

-- Posteriormente ejecuto la transacción

BEGIN TRANSACTION;
INSERT INTO compra (id, cliente_id, fecha) VALUES (33, 1, '2022-02-21');
INSERT INTO detalle_compra (id, producto_id, compra_id, cantidad) VALUES (43, 9, 33, 5);
UPDATE producto SET stock = stock - 5 WHERE id = 9;
COMMIT;

-- Luego verifico los nuevos registros y el stock del producto
SELECT * FROM compra ORDER BY id DESC;
SELECT * FROM detalle_compra ORDER BY id DESC;
SELECT stock FROM producto WHERE id = 9;

-- De esta manera, se verifica que la transacción fue exitosa



-- 3) Segunda transacción mediante SQL Shell (psql)
BEGIN TRANSACTION;
INSERT INTO compra (id, cliente_id, fecha) VALUES (34, 2, '2022-02-21');
INSERT INTO detalle_compra (id, producto_id, compra_id, cantidad) VALUES (44, 1, 34, 3);
UPDATE producto SET stock = stock - 3 WHERE id = 1;
SAVEPOINT check1;
INSERT INTO compra (id, cliente_id, fecha) VALUES (35, 2, '2022-02-21');
INSERT INTO detalle_compra (id, producto_id, compra_id, cantidad) VALUES (45, 2, 35, 3);
UPDATE producto SET stock = stock - 3 WHERE id = 2;
SAVEPOINT check2;
INSERT INTO compra (id, cliente_id, fecha) VALUES (36, 2, '2022-02-21');
INSERT INTO detalle_compra (id, producto_id, compra_id, cantidad) VALUES (46, 8, 36, 3);
UPDATE producto SET stock = stock - 3 WHERE id = 8;
ROLLBACK TO check2;
COMMIT;

-- Luego verifico los nuevos registros y el stock de los productos
SELECT * FROM compra ORDER BY id DESC;
SELECT * FROM detalle_compra ORDER BY id DESC;
SELECT stock FROM producto WHERE id = 1;
SELECT stock FROM producto WHERE id = 2;
SELECT stock FROM producto WHERE id = 8;

-- De esta manera, se verifica que la transacción fue exitosa para la venta de los productos 1 y 2, ya que tenian stock suficiente, mientras que la venta del producto 8 no pudo ser concretada por falta de stock



-- 4) Realizar las sigientes consultas

-- a) Deshabilitar el AUTOCOMMIT

-- \set AUTOCOMMIT off

-- b) Insertar un nuevo cliente

INSERT INTO cliente (id, nombre, email) VALUES (11, 'usuario011', 'usuario011@hotmail.com');

-- c) Confirmar que fue agregado en la tabla cliente

SELECT * FROM cliente WHERE id = 11; -- Efectivamentee devuelve el usuario 11

-- d) Realizar un ROLLBACK

ROLLBACK;

-- e) Confirmar que se restauró la información, sin considerar la inserción del
-- punto b

SELECT * FROM cliente WHERE id = 11; -- Efectivamente devuelve 0 filas, luego del
-- ROLLBACK, el usuario 11 no existe

-- f) Habilitar de nuevo el AUTOCOMMIT

-- \set AUTOCOMMIT on