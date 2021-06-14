INSERT INTO Product.ProductType (type) VALUES ('Żywność');
INSERT INTO Product.ProductType (type) VALUES ('Napój bezalkoholowy');

INSERT INTO Product.Product (typeId, name, price) VALUES (1, 'Spaghetti', 20.00);
INSERT INTO Product.Product (typeId, name, price) VALUES (1, 'Schabowy', 21.53);
INSERT INTO Product.Product (typeId, name, price) VALUES (1, 'Schab pieczony', 22.34);
INSERT INTO Product.Product (typeId, name, price) VALUES (1, 'Pierogi', 14.99);
INSERT INTO Product.Product (typeId, name, price) VALUES (1, 'Naleśniki', 10.95);
INSERT INTO Product.Product (typeId, name, price) VALUES (1, 'Racuchy', 11.11);
INSERT INTO Product.Product (typeId, name, price) VALUES (1, 'Placek po węgiersku', 17.25);
INSERT INTO Product.Product (typeId, name, price) VALUES (1, 'Szarlotka', 13.35);
INSERT INTO Product.Product (typeId, name, price) VALUES (1, 'Karpatka', 6.54);
INSERT INTO Product.Product (typeId, name, price) VALUES (1, 'Owoce morza', 31.95);
INSERT INTO Product.Product (typeId, name, price) VALUES (2, 'Kawa', 6.99);
INSERT INTO Product.Product (typeId, name, price) VALUES (2, 'Koktajl', 8.99);
INSERT INTO Product.Product (typeId, name, price) VALUES (2, 'Woda niegazowana', 3.29);
INSERT INTO Product.Product (typeId, name, price) VALUES (2, 'Woda gazowana', 1.99);
INSERT INTO Product.Product (typeId, name, price) VALUES (2, 'Coca-Cola', 4.99);
INSERT INTO Product.Product (typeId, name, price) VALUES (2, 'Sprite', 4.95);
INSERT INTO Product.Product (typeId, name, price) VALUES (2, 'Fanta', 5.15);

INSERT INTO Purchase.Discount (minOrderNumber, minOrderPrice, available, discount, validityDate) VALUES (10, 30.00, 1, 3, NULL);
INSERT INTO Purchase.Discount (minOrderNumber, minOrderPrice, available, discount, validityDate) VALUES (NULL, 1000.00, 1, 5, DATEADD(dd, 7, GETDATE()));