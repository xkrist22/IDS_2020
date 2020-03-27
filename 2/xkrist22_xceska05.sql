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
DROP TABLE account;
DROP TABLE brewery;
DROP TABLE person;
DROP TABLE pub;


-- CREATE tables

CREATE TABLE pub (
    id INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE person (
    id INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    surname VARCHAR(255) NOT NULL,
    birth_date DATE NOT NULL
);

CREATE TABLE brewery (
    id INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    name VARCHAR(255),
    established_date DATE
);

CREATE TABLE account (
    id INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    email VARCHAR(255) NOT NULL CHECK ( REGEXP_LIKE(email, '^([a-zA-Z0-9_\-.]+)@([a-zA-Z0-9_\-.]+)\.([a-zA-Z]{2,5})$') ),
    city VARCHAR(255) NOT NULL,
    street VARCHAR(255) NOT NULL,
    house VARCHAR(255) NOT NULL,
    pub_id INT DEFAULT NULL,
    person_id INT DEFAULT NULL,
    brewery_id INT DEFAULT NULL,
    CONSTRAINT account_pub_fk FOREIGN KEY(pub_id) REFERENCES pub(id) ON DELETE SET NULL,
    CONSTRAINT account_person_fk FOREIGN KEY(person_id) REFERENCES person(id) ON DELETE SET NULL,
    CONSTRAINT account_brewery_fk FOREIGN KEY(brewery_id) REFERENCES brewery(id) ON DELETE SET NULL
);

CREATE TABLE hop (
    id INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    aroma VARCHAR(255) NOT NULL,
    bitterness INT NOT NULL,
    alpha_acid_volume INT NOT NULL,
    CONSTRAINT hop_check_bitterness CHECK ( bitterness>=0 ),
    CONSTRAINT hop_check_alpha_acid_volume CHECK ( alpha_acid_volume>=0 )
);

CREATE TABLE yeast (
    id INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    state VARCHAR(32) NOT NULL,
    proteins_volume INT NOT NULL,
    sugar_volume INT NOT NULL,
    vitamins_volume INT NOT NULL,
    CONSTRAINT yeast_check_proteins_volume CHECK ( proteins_volume>=0 ),
    CONSTRAINT yeast_check_sugar_volume CHECK ( sugar_volume>=0 ),
    CONSTRAINT yeast_check_vitamins_volume CHECK ( vitamins_volume>=0 )
);

CREATE TABLE malt (
    id INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    color VARCHAR(255) NOT NULL,
    extract VARCHAR(255) NOT NULL,
    sugar_volume INT NOT NULL,
    CONSTRAINT malt_check_sugar_volume CHECK ( sugar_volume>=0 )
);

CREATE TABLE beer (
    id INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
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
    CONSTRAINT beer_hop_fk FOREIGN KEY (hop_id) REFERENCES hop(id) ON DELETE CASCADE,
    CONSTRAINT beer_yeast_fk FOREIGN KEY (yeast_id) REFERENCES yeast(id) ON DELETE CASCADE,
    CONSTRAINT beer_malt_fk FOREIGN KEY (malt_id) REFERENCES malt(id) ON DELETE CASCADE
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
    price INT NOT NULL,
    CONSTRAINT offer_check_price CHECK ( price>0 ),
    CONSTRAINT offer_offer_pk PRIMARY KEY (pub_id, beer_id),
    CONSTRAINT offer_beer_fk FOREIGN KEY(beer_id) REFERENCES beer(id) ON DELETE SET NULL,
    CONSTRAINT offer_pub_fk FOREIGN KEY(pub_id) REFERENCES pub(id) ON DELETE SET NULL
);
