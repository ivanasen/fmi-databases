USE pc;

SELECT maker, laptop.model, price
FROM laptop
         JOIN product ON laptop.model = product.model
WHERE screen = 15;