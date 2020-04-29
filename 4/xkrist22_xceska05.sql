-- -----------------------------------------------------------------
-- IDS Project
-- Database system for beer
-- Authors: Jiří Křištof (xkrist22)
--          Petr Češka (xceska05)
-- Repository: https://github.com/xkrist22/IDS_2020.git
-- -----------------------------------------------------------------

-- -----------------------------------------------------------------
-- Part 2: script for creating elementary objects of database
-- -----------------------------------------------------------------

-- DROP created tables

DROP TABLE offer;
DROP TABLE beer_rating;
DROP TABLE pub_rating;
DROP TABLE beer;
DROP TABLE malt;
DROP TABLE yeast;
DROP TABLE hop;
DROP TABLE brewery;
DROP TABLE person;
DROP TABLE pub;
DROP TABLE account;



-- CREATE tables

CREATE TABLE account (
    id INT DEFAULT NULL PRIMARY KEY, -- is generated by trigger generate_account_id
    email VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    street VARCHAR(255) NOT NULL,
    house VARCHAR(255) NOT NULL,
    CONSTRAINT check_mail CHECK( REGEXP_LIKE(email, '^[a-zA-Z][-a-zA-Z0-9.]*@[-a-zA-Z0-9.]+\.[a-zA-Z][a-zA-Z][a-zA-Z]*$') )
);

CREATE TABLE pub (
    id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    CONSTRAINT pub_pk PRIMARY KEY (id),
    CONSTRAINT pub_pk_fk FOREIGN KEY (id) REFERENCES account(id) ON DELETE CASCADE
);

CREATE TABLE person (
    id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    surname VARCHAR(255) NOT NULL,
    birth_date DATE NOT NULL,
    CONSTRAINT person_pk PRIMARY KEY (id),
    CONSTRAINT person_pk_fk FOREIGN KEY (id) REFERENCES account(id) ON DELETE CASCADE
);

CREATE TABLE brewery (
    id INT NOT NULL,
    name VARCHAR(255),
    established_date DATE,
    CONSTRAINT brewery_pk PRIMARY KEY (id),
    CONSTRAINT brewery_pk_fk FOREIGN KEY (id) REFERENCES account(id) ON DELETE CASCADE
);

CREATE TABLE hop (
    id INT NOT NULL PRIMARY KEY,
    aroma VARCHAR(255) NOT NULL,
    bitterness INT NOT NULL,
    alpha_acid_volume INT NOT NULL,
    CONSTRAINT hop_check_bitterness CHECK ( bitterness>=0 ),
    CONSTRAINT hop_check_alpha_acid_volume CHECK ( alpha_acid_volume>=0 )
);

CREATE TABLE yeast (
    id INT NOT NULL PRIMARY KEY,
    state VARCHAR(32) NOT NULL,
    proteins_volume INT NOT NULL,
    sugar_volume INT NOT NULL,
    vitamins_volume INT NOT NULL,
    CONSTRAINT yeast_check_proteins_volume CHECK ( proteins_volume>=0 ),
    CONSTRAINT yeast_check_sugar_volume CHECK ( sugar_volume>=0 ),
    CONSTRAINT yeast_check_vitamins_volume CHECK ( vitamins_volume>=0 )
);

CREATE TABLE malt (
    id INT NOT NULL PRIMARY KEY,
    color VARCHAR(255) NOT NULL,
    extract VARCHAR(255) NOT NULL,
    sugar_volume INT NOT NULL,
    CONSTRAINT malt_check_sugar_volume CHECK ( sugar_volume>=0 )
);

CREATE TABLE beer (
    id INT NOT NULL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    color VARCHAR(255) NOT NULL,
    type VARCHAR(255) NOT NULL,
    alcohol_volume INT NOT NULL,
    fermentation_type VARCHAR(32) NOT NULL, -- styl kvašení
    bitterness INT NOT NULL, -- hořkost
    savor VARCHAR(255) NOT NULL,
    brewery_id INT NOT NULL,
    hop_id INT,
    yeast_id INT,
    malt_id INT,
    CONSTRAINT beer_brewery_fk FOREIGN KEY (brewery_id) REFERENCES brewery(id) ON DELETE CASCADE,
    CONSTRAINT beer_hop_fk FOREIGN KEY (hop_id) REFERENCES hop(id) ON DELETE SET NULL,
    CONSTRAINT beer_yeast_fk FOREIGN KEY (yeast_id) REFERENCES yeast(id) ON DELETE SET NULL,
    CONSTRAINT beer_malt_fk FOREIGN KEY (malt_id) REFERENCES malt(id) ON DELETE SET NULL
);

CREATE TABLE pub_rating (
    pub_id INT NOT NULL,
    person_id INT NOT NULL,
    service INT NOT NULL,
    interior INT NOT NULL,
    result INT NOT NULL,
    CONSTRAINT pub_check_rating CHECK ( service>=0 AND service<=5 AND interior>=0 AND interior<=5 AND result>=0 AND result<=5 ),
    CONSTRAINT pub_pub_rating_pk PRIMARY KEY (pub_id, person_id),
    CONSTRAINT pub_pub_fk FOREIGN KEY(pub_id) REFERENCES pub(id) ON DELETE SET NULL,
    CONSTRAINT pub_person_fk FOREIGN KEY(person_id) REFERENCES person(id) ON DELETE SET NULL
);

CREATE TABLE beer_rating (
    beer_id INT NOT NULL,
    person_id INT NOT NULL,
    taste INT NOT NULL,
    foam INT NOT NULL,
    smell INT NOT NULL,
    CONSTRAINT beer_check_rating CHECK ( taste>=0 AND taste<=5 AND foam>=0 AND foam<=5 AND smell>=0 AND smell<=5 ),
    CONSTRAINT beer_beer_rating_pk PRIMARY KEY (beer_id, person_id),
    CONSTRAINT beer_beer_fk FOREIGN KEY(beer_id) REFERENCES beer(id) ON DELETE SET NULL,
    CONSTRAINT beer_person_fk FOREIGN KEY(person_id) REFERENCES person(id) ON DELETE SET NULL
);

CREATE TABLE offer (
    pub_id INT NOT NULL,
    beer_id INT NOT NULL,
    price FLOAT NOT NULL,
    CONSTRAINT offer_check_price CHECK ( price>0 ),
    CONSTRAINT offer_offer_pk PRIMARY KEY (pub_id, beer_id),
    CONSTRAINT offer_beer_fk FOREIGN KEY(beer_id) REFERENCES beer(id) ON DELETE SET NULL,
    CONSTRAINT offer_pub_fk FOREIGN KEY(pub_id) REFERENCES pub(id) ON DELETE SET NULL
);


-- -----------------------------------------------------------------
-- Part 4: advanced objects of the database
-- -----------------------------------------------------------------

-- TRIGGERS

-- Sequence generating values for account.id
DROP SEQUENCE  account_id_sequence;
CREATE SEQUENCE account_id_sequence
    MINVALUE 1
    INCREMENT BY 1;

-- Trigger for automatic generating values of primary key for table account
CREATE OR REPLACE TRIGGER generate_account_id
	BEFORE INSERT ON account
	FOR EACH ROW
BEGIN
    	IF :NEW.id IS NULL THEN
	       :NEW.id := account_id_sequence.NEXTVAL;
	    END IF;
END;

-- Trigger for automatic converting price of beer in CZK to EUR
-- exchange rate: 27 CZK for 1 EURO
CREATE OR REPLACE TRIGGER convert_to_euro
    BEFORE INSERT ON offer
    FOR EACH ROW
BEGIN
    :NEW.price := :NEW.price / 27;
END;

-- INSERT VALUES INTO TABLE

-- demonstrate functionality of trigger generate_account_id
INSERT INTO account (email, city, street, house) values ('lx@svi.cz', 'Svitavy', 'Safarikova', '11');
INSERT INTO account (email, city, street, house) values ('standa@seznam.cz', 'Polička', 'Nadrazni', '3');
INSERT INTO account (email, city, street, house) values ('dita@gmail.com', 'Svitavy', 'Dlouhá', '32');
INSERT INTO account (email, city, street, house) values ('pavel@svi.cz', 'Svitavy', 'Safarikova', '11');
INSERT INTO account (email, city, street, house) values ('honza@seznam.cz', 'Polička', 'Nadrazni', '23');
INSERT INTO account (email, city, street, house) values ('kamil@gmail.com', 'Brno', 'Strmá', '4322');
INSERT INTO account (email, city, street, house) values ('maja@svi.cz', 'Svitavy', 'Strmá', '11');
INSERT INTO account (email, city, street, house) values ('david@seznam.cz', 'Polička', 'Nadrazni', '53');
INSERT INTO account (email, city, street, house) values ('anet@gmail.com', 'Praha', 'Dlouhá', '42');
INSERT INTO account (email, city, street, house) values ('emily@svi.cz', 'Svitavy', 'Safarikova', '111');
INSERT INTO account (email, city, street, house) values ('denis@seznam.cz', 'Olomouc', 'Skácelova', '73');
INSERT INTO account (email, city, street, house) values ('steave@gmail.com', 'Česká Třebová', 'Příční', '4');


INSERT INTO pub (id, name) values ('2', 'U Ditky');
INSERT INTO person (id, name, surname, birth_date) values (1, 'Petr', ' Češka', TO_DATE('1999-03-25','YYYY-MM-DD'));
INSERT INTO brewery (id, name, established_date) values ('3', 'Na kopečku', TO_DATE('2009-06-21','YYYY-MM-DD'));

INSERT INTO person (id, name, surname, birth_date) values (4, 'Pavel', ' Staša', TO_DATE('1999-12-23','YYYY-MM-DD'));
INSERT INTO person (id, name, surname, birth_date) values (5, 'Honza', ' Čáp', TO_DATE('1989-03-12','YYYY-MM-DD'));
INSERT INTO person (id, name, surname, birth_date) values (6, 'Kamil', ' Muller', TO_DATE('1998-01-04','YYYY-MM-DD'));


INSERT INTO pub (id, name) values ('7', 'Pelikán');
INSERT INTO pub (id, name) values ('8', 'Černá Kočka');
INSERT INTO pub (id, name) values ('9', 'Slavie');


INSERT INTO brewery (id, name, established_date) values ('10', 'Černá Hora', TO_DATE('2009-05-25','YYYY-MM-DD'));
INSERT INTO brewery (id, name, established_date) values ('11', 'Staropramen', TO_DATE('1989-04-22','YYYY-MM-DD'));
INSERT INTO brewery (id, name, established_date) values ('12', 'Bernard', TO_DATE('2019-08-17','YYYY-MM-DD'));


INSERT INTO hop (id, aroma, bitterness, alpha_acid_volume) values ('1', 'cocoa', '4', '6');
INSERT INTO hop (id, aroma, bitterness, alpha_acid_volume) values ('2', 'coffee', '3', '7');
INSERT INTO hop (id, aroma, bitterness, alpha_acid_volume) values ('3', 'orange', '5', '6');
INSERT INTO hop (id, aroma, bitterness, alpha_acid_volume) values ('5', 'citrus', '4', '8');
INSERT INTO hop (id, aroma, bitterness, alpha_acid_volume) values ('6', 'cocoa', '4', '6');
INSERT INTO hop (id, aroma, bitterness, alpha_acid_volume) values ('7', 'coffee', '3', '7');
INSERT INTO hop (id, aroma, bitterness, alpha_acid_volume) values ('8', 'orange', '2', '5');
INSERT INTO hop (id, aroma, bitterness, alpha_acid_volume) values ('9', 'citrus', '4', '1');


INSERT INTO yeast (id, state, proteins_volume, sugar_volume, vitamins_volume) values ('1', 'liquid', '2', '1', '7');
INSERT INTO yeast (id, state, proteins_volume, sugar_volume, vitamins_volume) values ('2', 'solid', '4', '7', '2');
INSERT INTO yeast (id, state, proteins_volume, sugar_volume, vitamins_volume) values ('3', 'gas', '2', '3', '7');
INSERT INTO yeast (id, state, proteins_volume, sugar_volume, vitamins_volume) values ('5', 'liquid', '8', '5', '1');
INSERT INTO yeast (id, state, proteins_volume, sugar_volume, vitamins_volume) values ('6', 'liquid', '2', '1', '7');
INSERT INTO yeast (id, state, proteins_volume, sugar_volume, vitamins_volume) values ('7', 'solid', '4', '6', '8');
INSERT INTO yeast (id, state, proteins_volume, sugar_volume, vitamins_volume) values ('8', 'gas', '1', '5', '5');
INSERT INTO yeast (id, state, proteins_volume, sugar_volume, vitamins_volume) values ('9', 'liquid', '8', '5', '1');

INSERT INTO malt (id, color, extract, sugar_volume) values ('1', 'black', 'coffee', '7');
INSERT INTO malt (id, color, extract, sugar_volume) values ('2', 'brown', 'caramel', '6');
INSERT INTO malt (id, color, extract, sugar_volume) values ('3', 'yellow', 'lemon', '7');
INSERT INTO malt (id, color, extract, sugar_volume) values ('4', 'orange', 'orange', '7');
INSERT INTO malt (id, color, extract, sugar_volume) values ('5', 'black', 'coffee', '7');
INSERT INTO malt (id, color, extract, sugar_volume) values ('6', 'brown', 'caramel', '6');
INSERT INTO malt (id, color, extract, sugar_volume) values ('7', 'yellow', 'lemon', '7');
INSERT INTO malt (id, color, extract, sugar_volume) values ('8', 'orange', 'orange', '7');

INSERT INTO beer (id, name, color, type, alcohol_volume, fermentation_type, bitterness, savor, brewery_id, hop_id, yeast_id, malt_id) values ('1', 'Mouřenín', 'yellow', 'dark', '13', 'inner', '428', 'orange', '11', '1', '2', '3');
INSERT INTO beer (id, name, color, type, alcohol_volume, fermentation_type, bitterness, savor, brewery_id, hop_id, yeast_id, malt_id) values ('2', 'Oliver','black', 'semi-dark', '12', 'inner', '473', 'banana', '12', '2', '3', '1');
INSERT INTO beer (id, name, color, type, alcohol_volume, fermentation_type, bitterness, savor, brewery_id, hop_id, yeast_id, malt_id) values ('3', 'Jedenáctka','yellow', 'semi-dark', '11', 'inner', '411', 'simple', '10', '3', '1', '4');
INSERT INTO beer (id, name, color, type, alcohol_volume, fermentation_type, bitterness, savor, brewery_id, hop_id, yeast_id, malt_id) values ('4', 'Raven Dark', 'black', 'light', '13', 'outer', '453', 'simple', '11', '5', '8', '4');
INSERT INTO beer (id, name, color, type, alcohol_volume, fermentation_type, bitterness, savor, brewery_id, hop_id, yeast_id, malt_id) values ('5', 'Raven12','brown', 'light', '12', 'inner', '523', 'banana', '12', '5', '7', '1');
INSERT INTO beer (id, name, color, type, alcohol_volume, fermentation_type, bitterness, savor, brewery_id, hop_id, yeast_id, malt_id) values ('6', 'Svitavan','brown', 'light', '13', 'inner', '423', 'orange', '12', '6', '1', '3');
INSERT INTO beer (id, name, color, type, alcohol_volume, fermentation_type, bitterness, savor, brewery_id, hop_id, yeast_id, malt_id) values ('7', 'Kovář','brown', 'dark', '14', 'outer', '421', 'cocoa', '11', '7', '3', '2');
INSERT INTO beer (id, name, color, type, alcohol_volume, fermentation_type, bitterness, savor, brewery_id, hop_id, yeast_id, malt_id) values ('8', 'Sloupec','yellow', 'light', '12', 'inner', '476', 'orange', '3', '1', '1', '8');
INSERT INTO beer (id, name, color, type, alcohol_volume, fermentation_type, bitterness, savor, brewery_id, hop_id, yeast_id, malt_id) values ('9', 'Raven','yellow', 'dark', '10', 'inner', '444', 'coffee', '10', '8', '5', '8');
INSERT INTO beer (id, name, color, type, alcohol_volume, fermentation_type, bitterness, savor, brewery_id, hop_id, yeast_id, malt_id) values ('10', 'red vine', 'yellow', 'light', '10', 'inner', '463', 'orange', '3', '3', '1', '8');


INSERT INTO beer_rating (beer_id, person_id, taste, foam, smell) values ('1', '5', '4', '4', '4');
INSERT INTO beer_rating (beer_id, person_id, taste, foam, smell) values ('2', '6', '3', '3', '1');
INSERT INTO beer_rating (beer_id, person_id, taste, foam, smell) values ('3', '6', '2', '5', '5');
INSERT INTO beer_rating (beer_id, person_id, taste, foam, smell) values ('4', '4', '3', '4', '2');
INSERT INTO beer_rating (beer_id, person_id, taste, foam, smell) values ('5', '5', '4', '1', '2');
INSERT INTO beer_rating (beer_id, person_id, taste, foam, smell) values ('6', '4', '5', '2', '3');
INSERT INTO beer_rating (beer_id, person_id, taste, foam, smell) values ('7', '4', '4', '3', '2');
INSERT INTO beer_rating (beer_id, person_id, taste, foam, smell) values ('5', '6', '4', '3', '4');
INSERT INTO beer_rating (beer_id, person_id, taste, foam, smell) values ('6', '6', '3', '2', '3');
INSERT INTO beer_rating (beer_id, person_id, taste, foam, smell) values ('7', '6', '4', '3', '5');


INSERT INTO pub_rating (pub_id, person_id, service, interior, result) values ('7', '1', '2', '2', '4');
INSERT INTO pub_rating (pub_id, person_id, service, interior, result) values ('8', '1', '3', '2', '3');
INSERT INTO pub_rating (pub_id, person_id, service, interior, result) values ('8', '5', '4', '5', '1');
INSERT INTO pub_rating (pub_id, person_id, service, interior, result) values ('9', '6', '5', '3', '5');

-- demonstrate functionality of trigger convert_to_euro
INSERT INTO offer (pub_id, beer_id, price) values ('7', '1', '27');
INSERT INTO offer (pub_id, beer_id, price) values ('7', '3', '25');
INSERT INTO offer (pub_id, beer_id, price) values ('8', '2', '22');
INSERT INTO offer (pub_id, beer_id, price) values ('8', '1', '34');
INSERT INTO offer (pub_id, beer_id, price) values ('8', '5', '33');
INSERT INTO offer (pub_id, beer_id, price) values ('9', '7', '41');


-- PROCEDURES

-- Procedure for printing statistics about beers
CREATE OR REPLACE PROCEDURE beer_stat
AS
    CURSOR beer_cursor IS SELECT id FROM beer;
    beer_id_elem INT;
    beer_avg_taste FLOAT;
    beer_avg_foam FLOAT;
    beer_avg_smell FLOAT;
    beer_avg_price FLOAT;
    beer_name VARCHAR(255);
BEGIN
    OPEN beer_cursor;
    LOOP
        -- extract id from cursor
        FETCH beer_cursor INTO beer_id_elem;
        EXIT WHEN beer_cursor%NOTFOUND;

        -- get values from tables
        SELECT AVG(taste) INTO beer_avg_taste FROM beer_rating WHERE beer_rating.beer_id = beer_id_elem;
        SELECT AVG(foam) INTO beer_avg_foam FROM beer_rating WHERE beer_rating.beer_id = beer_id_elem;
        SELECT AVG(smell) INTO beer_avg_smell FROM beer_rating WHERE beer_rating.beer_id = beer_id_elem;
        SELECT AVG(price) INTO beer_avg_price FROM offer WHERE offer.beer_id = beer_id_elem;
        SELECT name INTO beer_name FROM beer WHERE beer.id = beer_id_elem;

        -- print statistics about beer
        DBMS_OUTPUT.PUT_LINE('Beer: ' || TO_CHAR(beer_name));
        DBMS_OUTPUT.PUT_LINE('  Average taste: ' || TO_CHAR(beer_avg_taste));
        DBMS_OUTPUT.PUT_LINE('  Average foam: ' || TO_CHAR(beer_avg_foam));
        DBMS_OUTPUT.PUT_LINE('  Average smell: ' || TO_CHAR(beer_avg_smell));
        DBMS_OUTPUT.PUT_LINE('  Average price: ' || TO_CHAR(beer_avg_price));
    END LOOP;
END;

-- demonstrate procedure beer_stat
BEGIN beer_stat(); END;

