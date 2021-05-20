USE pc;

SELECT maker, laptop.model, price
FROM laptop
         JOIN product ON laptop.model = product.model
WHERE screen = 15;

-- Problem 1
SELECT speed, p.maker
FROM laptop
         JOIN product p on p.model = laptop.model
WHERE hd >= 9;

-- Problem 2
SELECT laptop.model, price
FROM laptop
         JOIN product p on p.model = laptop.model
WHERE P.maker = 'B'
UNION
SELECT pc.model, price
FROM pc
         JOIN product p on p.model = pc.model
WHERE p.maker = 'B'
UNION
SELECT printer.model, price
FROM printer
         JOIN product p on p.model = printer.model
WHERE p.maker = 'B';

-- Problem 3
SELECT pc1.hd
FROM pc pc1,
     pc pc2
WHERE pc1.hd = pc2.hd
  AND pc1.model != pc2.model;

-- Problem 4
SELECT pc1.model, pc2.model
FROM pc pc1
         JOIN pc pc2 ON pc1.speed = pc2.speed AND pc1.ram = pc2.ram
WHERE pc1.model < pc2.model;

-- Problem 5 (Will use 500 MHz since we have no PCs with a 1000 MHz processor)
-- Nested statement
SELECT DISTINCT maker
FROM product
WHERE (SELECT COUNT(pc.model)
       FROM pc
                JOIN product p ON p.model = pc.model
       WHERE pc.speed >= 500
         AND p.maker = product.maker) >= 2;

-- Only joins
SELECT DISTINCT product1.maker
FROM pc p1
         CROSS JOIN pc p2
         JOIN product product1 ON product1.model = p1.model
         JOIN product product2 ON product2.model = p2.model
WHERE p1.code != p2.code
  AND p1.speed >= 500
  AND p2.speed >= 500
  AND product1.maker = product2.maker;