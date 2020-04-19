CREATE OR REPLACE TRIGGER pub_remove
BEFORE DELETE ON account
FOR EACH ROW
BEGIN
DELETE FROM offer WHERE pub_id = :old.id;
DELETE FROM pub_rating WHERE pub_id = :old.id;
DELETE FROM pub WHERE id = :old.id;
END;

CREATE OR REPLACE TRIGGER test
BEFORE DELETE ON offer
FOR EACH ROWł
BEGIN
DELETE FROM pub_rating WHERE pub_id = :old.id;
END;

CREATE OR REPLACE TRIGGER pub1
BEFORE DELETE ON pub
FOR EACH ROW
BEGIN
DELETE FROM offer where pub_id = 7;ł
DELETE FROM pub_rating where pub_id = 7;
END;

CREATE OR REPLACE TRIGGER tst
BEFORE DELETE ON beer
FOR EACH ROW
BEGIN
DELETE FROM beer_rating WHERE beer_id = :old.id;
DELETE FROM offer WHERE beer_id = :old.id;
END;
