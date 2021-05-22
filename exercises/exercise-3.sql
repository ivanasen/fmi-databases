-- Problem 1
USE movies;

-- 1.1
-- Using nested SQL
SELECT NAME
FROM MOVIESTAR
WHERE GENDER = 'F'
  AND NAME IN (SELECT NAME FROM MOVIEEXEC WHERE NETWORTH >= 10000000);

-- Using JOIN
SELECT MOVIESTAR.NAME
FROM MOVIESTAR
         INNER JOIN MOVIEEXEC on MOVIESTAR.NAME = MOVIEEXEC.NAME
WHERE MOVIEEXEC.NETWORTH >= 10000000
  AND GENDER = 'F';

-- 1.2
-- Using nested SQL
SELECT NAME
FROM MOVIESTAR
WHERE NAME NOT IN (SELECT NAME FROM MOVIEEXEC);

-- Using JOIN
SELECT MOVIESTAR.NAME
FROM MOVIESTAR
         LEFT OUTER JOIN MOVIEEXEC on MOVIESTAR.NAME = MOVIEEXEC.NAME
WHERE MOVIEEXEC.NAME IS NULL;


-- Problem 2
USE pc;

-- 2.1
-- Nested SQL
SELECT DISTINCT maker
FROM product
WHERE 500 <= ANY (SELECT speed FROM pc WHERE pc.model = product.model);

-- JOIN
SELECT DISTINCT maker
FROM product
         INNER JOIN pc ON pc.model = product.model
WHERE pc.speed >= 500;

-- 2.2
SELECT *
FROM laptop
WHERE speed < ALL (SELECT speed FROM pc);

-- 2.3
SELECT model
FROM (SELECT model, price
      FROM laptop
      UNION
      SELECT model, price
      FROM pc
      UNION
      SELECT model, price
      FROM printer) products_with_prices
WHERE price >= ALL (SELECT price
                    FROM laptop
                    UNION
                    SELECT price
                    FROM pc
                    UNION
                    SELECT price
                    FROM printer);

-- 2.4
-- JOIN with nested SQL
SELECT DISTINCT maker
FROM printer
         INNER JOIN product p on p.model = printer.model
WHERE color = 'y'
  AND price <= ALL (SELECT price FROM printer WHERE color = 'y');

-- Nested SQL only
SELECT DISTINCT maker
FROM product
WHERE model IN
      (SELECT model
       FROM printer
       WHERE color = 'y'
         AND price <= ALL (SELECT price FROM printer WHERE color = 'y'));

-- 2.5
SELECT DISTINCT maker
FROM product
WHERE model IN
      (SELECT model
       FROM pc pc1
       WHERE ram <= ALL (SELECT ram FROM pc)
         AND speed >= ALL (SELECT speed
                           FROM pc pc2
                           WHERE pc2.ram = pc1.ram));


-- Problem 3
USE ships;

-- 3.1
SELECT DISTINCT COUNTRY
FROM CLASSES
WHERE NUMGUNS >= ALL (SELECT NUMGUNS FROM CLASSES);

-- 3.2
-- Nested SQL
SELECT NAME
FROM SHIPS
WHERE CLASS IN (SELECT CLASS FROM CLASSES WHERE BORE = 16);

-- JOIN
SELECT NAME
FROM SHIPS
         INNER JOIN CLASSES on CLASSES.CLASS = SHIPS.CLASS
WHERE CLASSES.BORE = 16;

-- 3.3
-- Nested SQL
SELECT NAME
FROM BATTLES
WHERE NAME IN (SELECT BATTLE
               FROM OUTCOMES
               WHERE SHIP IN (SELECT NAME FROM SHIPS WHERE CLASS = 'Kongo'));

-- JOIN
SELECT BATTLES.NAME
FROM BATTLES
         INNER JOIN OUTCOMES on BATTLES.NAME = OUTCOMES.BATTLE
         INNER JOIN SHIPS on OUTCOMES.SHIP = SHIPS.NAME
WHERE SHIPS.CLASS = 'Kongo';

-- 3.4
-- Nested SQL
SELECT NAME
FROM SHIPS
WHERE CLASS IN (SELECT CLASS
                FROM CLASSES C1
                WHERE NUMGUNS >= ALL (SELECT NUMGUNS
                                      FROM CLASSES C2
                                      WHERE C1.BORE = C2.BORE));


-- JOIN
SELECT NAME
FROM SHIPS
         INNER JOIN CLASSES C1 on C1.CLASS = SHIPS.CLASS
WHERE NUMGUNS >= ALL (SELECT NUMGUNS FROM CLASSES C2 WHERE C2.BORE = C1.BORE);