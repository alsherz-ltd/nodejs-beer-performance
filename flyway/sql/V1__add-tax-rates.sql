CREATE TABLE tax_rates
(
    standard          DECIMAL,
    food              DECIMAL,
    childrens_clothes DECIMAL
);

INSERT INTO tax_rates (standard, food, childrens_clothes)
VALUES (0.2, 0.05, 0);
