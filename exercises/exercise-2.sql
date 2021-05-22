-- Problem 1
USE movies;

-- 1.1
SELECT MOVIESTAR.NAME
FROM MOVIESTAR
         JOIN STARSIN S ON MOVIESTAR.NAME = S.STARNAME
WHERE MOVIESTAR.GENDER = 'F'
  AND S.MOVIETITLE = 'Terms of Endearment';

-- 1.2
SELECT MOVIESTAR.NAME
FROM MOVIESTAR
         JOIN STARSIN S on MOVIESTAR.NAME = S.STARNAME
         JOIN MOVIE M on M.TITLE = S.MOVIETITLE and M.YEAR = S.MOVIEYEAR
WHERE S.MOVIEYEAR = 1995
  AND M.STUDIONAME = 'MGM';


-- Problem 2
USE pc;

SELECT maker, laptop.model, price
FROM laptop
         JOIN product ON laptop.model = product.model
WHERE screen = 15;

-- 2.1
SELECT speed, p.maker
FROM laptop
         JOIN product p on p.model = laptop.model
WHERE hd >= 9;

-- 2.2
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

-- 2.3
SELECT pc1.hd
FROM pc pc1,
     pc pc2
WHERE pc1.hd = pc2.hd
  AND pc1.model != pc2.model;

-- 2.4
SELECT pc1.model, pc2.model
FROM pc pc1
         JOIN pc pc2 ON pc1.speed = pc2.speed AND pc1.ram = pc2.ram
WHERE pc1.model < pc2.model;

-- 2.5 (Will use 500 MHz since we have no PCs with a 1000 MHz processor)
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


-- Problem 3
USE ships;

-- 3.1
SELECT NAME
FROM SHIPS
         JOIN CLASSES C on C.CLASS = SHIPS.CLASS
WHERE C.DISPLACEMENT > 35000;

-- 3.2
SELECT NAME, C.DISPLACEMENT, C.NUMGUNS
FROM SHIPS
         JOIN CLASSES C on C.CLASS = SHIPS.CLASS
         JOIN OUTCOMES O on SHIPS.NAME = O.SHIP
WHERE O.BATTLE = 'Guadalcanal';

-- 3.3
SELECT DISTINCT C1.COUNTRY
FROM CLASSES C1
         JOIN CLASSES C2 ON C2.COUNTRY = C1.COUNTRY
WHERE C1.TYPE = 'bc'
  AND C2.TYPE = 'bb';

-- 3.4
SELECT DISTINCT O1.SHIP
FROM OUTCOMES O1
         JOIN OUTCOMES O2 ON O1.SHIP = O2.SHIP
WHERE O1.BATTLE != O2.BATTLE;
