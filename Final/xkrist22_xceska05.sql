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
FOR EACH ROW
BEGIN
DELETE FROM pub_rating WHERE pub_id = :old.id;
END;
