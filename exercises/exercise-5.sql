-- 1
USE pc;

-- 1.1
SELECT AVG(SPEED)
FROM pc;

-- 1.2
SELECT product.maker, AVG(screen)
FROM product
         LEFT OUTER JOIN laptop ON product.model = laptop.model
GROUP BY product.maker;

-- 1.3
SELECT AVG(speed)
FROM laptop
WHERE price > 1000;

-- 1.4
SELECT AVG(price)
FROM pc
         INNER JOIN product ON pc.model = product.model
WHERE maker = 'A';

-- 1.5
SELECT (SUM(pc.price) + SUM(laptop.price)) / (COUNT(pc.price) + COUNT(laptop.price))
FROM product
         LEFT OUTER JOIN laptop ON product.model = laptop.model
         LEFT OUTER JOIN pc ON product.model = pc.model;

-- 1.6
SELECT speed, AVG(price)
FROM pc
GROUP BY speed;

-- 1.7
SELECT maker
FROM product
WHERE type = 'pc'
GROUP BY maker
HAVING COUNT(model) >= 3;

-- 1.8



-- 2
USE ships;

-- 2.1
SELECT COUNT(*)
FROM CLASSES;

-- 2.2
SELECT AVG(NUMGUNS)
FROM SHIPS
         INNER JOIN CLASSES on CLASSES.CLASS = SHIPS.CLASS;

SELECT CLASSES.CLASS, MIN(LAUNCHED) AS FIRST, MAX(LAUNCHED) AS LAST
FROM CLASSES
         LEFT OUTER JOIN SHIPS on CLASSES.CLASS = SHIPS.CLASS
GROUP BY CLASSES.CLASS;

-- 2.3
SELECT CLASSES.CLASS, MIN(LAUNCHED), MAX(LAUNCHED)
FROM CLASSES
         LEFT OUTER JOIN SHIPS on CLASSES.CLASS = SHIPS.CLASS
GROUP BY CLASSES.CLASS;

-- 2.4
SELECT CLASS, COUNT(*)
FROM SHIPS
         INNER JOIN OUTCOMES on SHIPS.NAME = OUTCOMES.SHIP
WHERE OUTCOMES.RESULT = 'sunk'
GROUP BY CLASS;

-- 2.5


-- 3
